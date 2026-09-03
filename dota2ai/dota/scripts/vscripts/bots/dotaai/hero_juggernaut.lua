local Config = require(GetScriptDirectory() .. "/dotaai/config")
local State = require(GetScriptDirectory() .. "/dotaai/state")
local Actions = require(GetScriptDirectory() .. "/dotaai/actions")
local Strategy = require(GetScriptDirectory() .. "/dotaai/strategy")

local Hero = {}
local nextDecision = -1000
local nextItemPurchase = -1000

local function Ability(bot, name)
    return bot:GetAbilityByName(name)
end

local function ValidEnemy(enemy)
    return enemy ~= nil
        and enemy:IsAlive()
        and enemy:CanBeSeen()
        and not enemy:IsInvulnerable()
end

local function FountainLocation()
    local fountain = GetTeamFountain()
    if fountain ~= nil then return fountain:GetLocation() end
    return nil
end

local function ChooseSkill(bot)
    if bot:GetAbilityPoints() <= 0 then return end

    local order = {
        "juggernaut_blade_fury",
        "juggernaut_blade_dance",
        "juggernaut_healing_ward",
        "juggernaut_blade_dance",
        "juggernaut_blade_fury",
        "juggernaut_omnislash",
    }

    for _, name in ipairs(order) do
        local ability = Ability(bot, name)
        if ability ~= nil and ability:CanAbilityBeUpgraded() then
            bot:Action_LevelAbility(name)
            return
        end
    end
end

local function UseAbilities(bot, state)
    if bot:IsUsingAbility() or bot:IsChanneling() then return true end

    local enemy, score = Strategy.FindAttackTarget(bot, state.enemies)
    if not ValidEnemy(enemy) then return false end

    local bladeFury = Ability(bot, "juggernaut_blade_fury")
    local healingWard = Ability(bot, "juggernaut_healing_ward")
    local omnislash = Ability(bot, "juggernaut_omnislash")

    if omnislash ~= nil
        and omnislash:IsFullyCastable()
        and state.mana_percent >= Config.OMNISLASH_MIN_MANA
        and score >= 35
        and GetUnitToUnitDistance(bot, enemy) <= omnislash:GetCastRange() + 50 then

        if Actions.UseAbilityOnEntity(bot, omnislash, enemy) then
            print("[DotaAI] Omnislash -> " .. enemy:GetUnitName())
            return true
        end
    end

    if bladeFury ~= nil
        and bladeFury:IsFullyCastable()
        and state.mana_percent >= Config.BLADE_FURY_MIN_MANA
        and GetUnitToUnitDistance(bot, enemy) <= 500 then

        if Actions.UseAbility(bot, bladeFury) then
            print("[DotaAI] Blade Fury")
            return true
        end
    end

    if healingWard ~= nil
        and healingWard:IsFullyCastable()
        and state.health_percent < 0.55
        and #state.enemies == 0 then

        if Actions.UseAbilityOnLocation(bot, healingWard, bot:GetLocation()) then
            print("[DotaAI] Healing Ward")
            return true
        end
    end

    return false
end

local function ThinkCombat(bot, state)
    local enemy, score = Strategy.FindAttackTarget(bot, state.enemies)

    if ValidEnemy(enemy) then
        if state.health_percent < Config.DANGER_HP and #state.enemies >= 2 then
            local fountain = FountainLocation()
            if fountain ~= nil then Actions.Move(bot, fountain) end
            return
        end

        if score >= 15 then
            Actions.Attack(bot, enemy)
            return
        end
    end
end

local function ThinkFarm(bot, state)
    local lastHit = Strategy.FindLastHit(bot, state.enemy_creeps)

    if lastHit ~= nil then
        Actions.Attack(bot, lastHit)
        return
    end

    if #state.enemy_creeps > 0 then
        local creep = state.enemy_creeps[1]
        if creep ~= nil then Actions.Move(bot, creep:GetLocation()) end
    end
end

local function ThinkLane(bot)
    local lane = bot:GetAssignedLane()
    if lane == nil then lane = LANE_MID end

    local location = GetLocationAlongLane(lane, 0.55)
    if location ~= nil then Actions.Move(bot, location) end
end

function Hero.Think(bot)
    local now = DotaTime()

    if now - nextDecision < Config.THINK_INTERVAL then return end
    nextDecision = now

    if not bot:IsAlive() then return end

    ChooseSkill(bot)

    local state = State.Build(bot)

    if Config.DEBUG and math.floor(now) % 10 == 0 then
        print(string.format(
            "[DotaAI] t=%.1f hp=%.2f mana=%.2f enemies=%d creeps=%d mode=%d",
            now, state.health_percent, state.mana_percent,
            #state.enemies, #state.enemy_creeps, state.active_mode
        ))
    end

    if Strategy.ShouldRetreat(state) then
        local fountain = FountainLocation()
        if fountain ~= nil then Actions.Move(bot, fountain) end
        return
    end

    if UseAbilities(bot, state) then return end

    if #state.enemies > 0 then
        ThinkCombat(bot, state)
        return
    end

    ThinkFarm(bot, state)

    if #state.enemy_creeps == 0 then
        ThinkLane(bot)
    end
end

function Hero.AbilityUsageThink(bot)
    -- Centralized in Think for V0.1.
end

function Hero.ItemPurchaseThink(bot)
    local now = DotaTime()
    if now - nextItemPurchase < 2.0 then return end
    nextItemPurchase = now

    for _, itemName in ipairs(Config.ITEM_BUILD) do
        if bot:FindItemSlot(itemName) == -1 then
            local cost = GetItemCost(itemName)
            if cost ~= nil and bot:GetGold() >= cost then
                bot:Action_PurchaseItem(itemName)
                print("[DotaAI] bought " .. itemName)
                return
            end
        end
    end
end

return Hero
