local QBCore = exports['qb-core']:GetCoreObject()

Citizen.CreateThread(function()
    local sleepThread = Config.paymentDelay * 60000

    while true do
        Citizen.Wait(sleepThread)
        if Config.debug then
            print('Membership System: Paying members...')
        end
        payThread()
    end
end)

local function payThread()
    local players = QBCore.Functions.GetActivePlayers()

    for k, player in pairs(players) do
        local src = player
        local xPlayer = QBCore.Functions.GetPlayer(src)
        local citizenid = xPlayer.PlayerData.citizenid
        local rank = xPlayer.PlayerData.membership

        if rank ~= nil then
            addPayment(citizenid, rank)
        end
    end
end

local function addPayment(citizenid, rank)
    local rankData = Config.ranks[rank]
    local xPlayer = QBCore.Functions.GetPlayerByCitizenId(citizenid)

    MySQL.Async.execute('UPDATE players SET coins = coins + @coins WHERE citizenid = @citizenid', {['@coins'] = rankData.coinPayment, ['@citizenid'] = citizenid}, function(rowsChanged)
        if rowsChanged > 0 and xPlayer then
            TriggerClientEvent('QBCore:Notify', xPlayer.PlayerData.source, 'Recibiste x'..rankData.coinPayment..' coins de tu membresía', 'success')
        end
    end)
end