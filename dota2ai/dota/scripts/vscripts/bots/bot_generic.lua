local AI = require(GetScriptDirectory() .. "/dotaai/hero_juggernaut")
local Config = require(GetScriptDirectory() .. "/dotaai/config")

local npcBot = GetBot()
local lastThink = -1000

function Think()
    if npcBot == nil then return end

    local now = DotaTime()
    if now - lastThink < Config.THINK_INTERVAL then return end
    lastThink = now

    local ok, err = pcall(function()
        AI.Think(npcBot)
    end)

    if not ok then
        print("[DotaAI] ERROR: " .. tostring(err))
    end
end

function AbilityUsageThink()
    if npcBot == nil then return end
    local ok, err = pcall(function() AI.AbilityUsageThink(npcBot) end)
    if not ok then print("[DotaAI] ABILITY ERROR: " .. tostring(err)) end
end

function ItemPurchaseThink()
    if npcBot == nil then return end
    local ok, err = pcall(function() AI.ItemPurchaseThink(npcBot) end)
    if not ok then print("[DotaAI] ITEM ERROR: " .. tostring(err)) end
end

function BuybackUsageThink() end
function CourierUsageThink() end
function MinionThink(hMinionUnit) end
