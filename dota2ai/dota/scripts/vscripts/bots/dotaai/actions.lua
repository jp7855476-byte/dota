local Actions = {}

function Actions.Move(bot, location)
    if location ~= nil then bot:Action_MoveToLocation(location) end
end

function Actions.Attack(bot, target)
    if target ~= nil then bot:Action_AttackUnit(target, true) end
end

function Actions.Stop(bot)
    bot:Action_ClearActions(false)
end

function Actions.UseAbility(bot, ability)
    if ability ~= nil and ability:IsFullyCastable() then
        bot:Action_UseAbility(ability)
        return true
    end
    return false
end

function Actions.UseAbilityOnEntity(bot, ability, target)
    if ability ~= nil and target ~= nil and ability:IsFullyCastable() then
        bot:Action_UseAbilityOnEntity(ability, target)
        return true
    end
    return false
end

function Actions.UseAbilityOnLocation(bot, ability, location)
    if ability ~= nil and location ~= nil and ability:IsFullyCastable() then
        bot:Action_UseAbilityOnLocation(ability, location)
        return true
    end
    return false
end

return Actions
