local QBCore = exports['qb-core']:GetCoreObject()

-- Create a callback that makes the player pay with coins
QBCore.Functions.CreateCallback('memberships:server:PayWithCoins', function(source, cb, amount)
    local xPlayer = QBCore.Functions.GetPlayer(source)
    if xPlayer then
        if xPlayer.PlayerData.coins >= amount then
            MySQL.Async.execute('UPDATE players SET coins = coins - @amount WHERE identifier = @identifier', {
                ['@amount'] = amount,
                ['@identifier'] = xPlayer.PlayerData.identifier
            })
            xPlayer.Functions.SetPlayerData('coins', xPlayer.PlayerData.coins - amount)
            cb(true)
        else
            cb(false)
        end
    else
        cb(false)
    end
end)