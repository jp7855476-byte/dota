local preferred = {
    "npc_dota_hero_juggernaut",
    "npc_dota_hero_axe",
    "npc_dota_hero_crystal_maiden",
    "npc_dota_hero_sniper",
    "npc_dota_hero_lion",
}

local function AlreadyPicked(hero)
    for _, id in pairs(GetTeamPlayers(GetTeam())) do
        if GetSelectedHeroName(id) == hero then return true end
    end
    for _, id in pairs(GetTeamPlayers(GetOpposingTeam())) do
        if GetSelectedHeroName(id) == hero then return true end
    end
    return false
end

local function PickForSlot(slot)
    if slot == 1 and not AlreadyPicked(preferred[1]) then
        return preferred[1]
    end
    for i = 2, #preferred do
        if not AlreadyPicked(preferred[i]) then return preferred[i] end
    end
    return GetRandomHero()
end

function Think()
    if GetGameState() ~= GAME_STATE_HERO_SELECTION then return end

    for slot, id in pairs(GetTeamPlayers(GetTeam())) do
        if IsPlayerBot(id)
            and IsPlayerInHeroSelectionControl(id)
            and GetSelectedHeroName(id) == "" then

            local hero = PickForSlot(slot)
            SelectHero(id, hero)
            print("[DotaAI] selected " .. hero .. " for bot " .. tostring(id))
            return
        end
    end
end

function GetBotNames()
    return {
        "DotaAI-Juggernaut",
        "DotaAI-Axe",
        "DotaAI-CrystalMaiden",
        "DotaAI-Sniper",
        "DotaAI-Lion",
    }
end

function UpdateLaneAssignments()
    if GetTeam() == TEAM_RADIANT then
        return {
            [1] = LANE_BOT, [2] = LANE_MID, [3] = LANE_TOP,
            [4] = LANE_TOP, [5] = LANE_BOT,
        }
    end
    return {
        [1] = LANE_TOP, [2] = LANE_MID, [3] = LANE_BOT,
        [4] = LANE_BOT, [5] = LANE_TOP,
    }
end
