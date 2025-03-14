local QBCore = exports['qb-core']:GetCoreObject()

Citizen.CreateThread(function()
    local availableRanks = "["
    for k, v in pairs(Config.ranks) do
        if k == #Config.ranks then
            availableRanks = availableRanks .. v.label .. "]"
        else
            availableRanks = availableRanks .. v.label .. ", "
        end
    end
    TriggerEvent('chat:addSuggestion', '/' .. Config.commands.addMembership.cmd, Config.commands.addMembership.dsc, {
        { name = 'id', help = 'Player ID' },
        { name = 'rank', help = 'Membership rank ' .. availableRanks .. '' }
    })
    TriggerEvent('chat:addSuggestion', '/' .. Config.commands.removeMembership.cmd, Config.commands.removeMembership.dsc, {
        { name = 'id', help = 'Player ID' }
    })
    TriggerEvent('chat:addSuggestion', '/' .. Config.commands.addCoins.cmd, Config.commands.addCoins.dsc, {
        { name = 'id', help = 'Player ID' },
        { name = 'amount', help = 'Amount of coins' }
    })
    TriggerEvent('chat:addSuggestion', '/' .. Config.commands.removeCoins.cmd, Config.commands.removeCoins.dsc, {
        { name = 'id', help = 'Player ID' },
        { name = 'amount', help = 'Amount of coins' }
    })
    TriggerEvent('chat:addSuggestion', '/' .. Config.commands.setCoins.cmd, Config.commands.setCoins.dsc, {
        { name = 'id', help = 'Player ID' },
        { name = 'amount', help = 'Amount of coins' }
    })
end)