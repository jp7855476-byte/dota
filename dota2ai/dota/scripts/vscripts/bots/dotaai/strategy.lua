local Strategy = {}

function Strategy.FindAttackTarget(bot, enemies)
    local best = nil
    local bestScore = -999999

    for _, enemy in pairs(enemies) do
        if enemy ~= nil and enemy:IsAlive() and enemy:CanBeSeen() then
            local distance = GetUnitToUnitDistance(bot, enemy)
            local score = -distance * 0.01

            score = score
                + (1.0 - enemy:GetHealth() / math.max(1, enemy:GetMaxHealth())) * 40

            if enemy:IsChanneling() then score = score + 25 end
            if enemy:IsHero() then score = score + 30 end

            if score > bestScore then
                bestScore = score
                best = enemy
            end
        end
    end

    return best, bestScore
end

function Strategy.FindLastHit(bot, creeps)
    local best = nil
    local lowestHealth = 999999

    for _, creep in pairs(creeps) do
        if creep ~= nil and creep:IsAlive() and creep:CanBeSeen() then
            local hp = creep:GetHealth()
            local damage = bot:GetEstimatedDamageToTarget(
                true, creep, 0.5, DAMAGE_TYPE_PHYSICAL
            )

            if damage >= hp and hp < lowestHealth then
                lowestHealth = hp
                best = creep
            end
        end
    end

    return best
end

function Strategy.ShouldRetreat(state)
    if not state.alive then return false end
    if state.health_percent <= 0.23 then return true end
    if state.health_percent < 0.38 and #state.enemies >= 2 then return true end
    return false
end

return Strategy
