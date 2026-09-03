local State = {}

local function Percent(value, maximum)
    if maximum == nil or maximum <= 0 then return 0 end
    return value / maximum
end

function State.Build(bot)
    return {
        time = DotaTime(),
        alive = bot:IsAlive(),

        health = bot:GetHealth(),
        max_health = bot:GetMaxHealth(),
        health_percent = Percent(bot:GetHealth(), bot:GetMaxHealth()),

        mana = bot:GetMana(),
        max_mana = bot:GetMaxMana(),
        mana_percent = Percent(bot:GetMana(), bot:GetMaxMana()),

        level = bot:GetLevel(),
        gold = bot:GetGold(),
        location = bot:GetLocation(),

        active_mode = bot:GetActiveMode(),
        active_mode_desire = bot:GetActiveModeDesire(),

        enemies = bot:GetNearbyHeroes(1100, true, BOT_MODE_NONE),
        allies = bot:GetNearbyHeroes(1100, false, BOT_MODE_NONE),
        enemy_creeps = bot:GetNearbyLaneCreeps(800, true),
        allied_creeps = bot:GetNearbyLaneCreeps(800, false),
    }
end

return State
