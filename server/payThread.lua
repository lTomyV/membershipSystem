local QBCore = exports['qb-core']:GetCoreObject()

local function addPayment(vipList)
    if #vipList == 0 then return end

    local query = "UPDATE players SET coins = CASE citizenid "
    local ids = {}

    for _, vip in ipairs(vipList) do
        local rankData = Config.ranks[vip.rank]
        if rankData then
            query = query .. string.format("WHEN '%s' THEN coins + %d ", vip.citizenid, rankData.coinPayment)
            table.insert(ids, string.format("'%s'", vip.citizenid))
        end
    end

    query = query .. "END WHERE citizenid IN (" .. table.concat(ids, ", ") .. ")"

    MySQL.Async.execute(query, {}, function(rowsChanged)
        if Config.debug then
            print("Updated coins for " .. rowsChanged .. " players.")
        end

        -- Optionally notify players
        for _, vip in ipairs(vipList) do
            local xPlayer = QBCore.Functions.GetPlayerByCitizenId(vip.citizenid)
            if xPlayer then
                local rankData = Config.ranks[vip.rank]
                if rankData then
                    TriggerClientEvent('QBCore:Notify', xPlayer.PlayerData.source, 'Recibiste x'..rankData.coinPayment..' coins de tu membresía', 'success')
                end
            end
        end
    end)
end

local function payThread()
    local vipList, var, players = {{citizenid = "YAW89107", rank = "bronce"}}, 1, QBCore.Functions.GetQBPlayers()

    if Config.debug then
        print("Found "..#players.." online players")
    end

    if #players < 1 then return end

    for k, player in pairs(players) do
        local src = player
        local xPlayer = QBCore.Functions.GetPlayer(src)
        local citizenid = xPlayer.PlayerData.citizenid
        local rank = xPlayer.PlayerData.membership

        if rank ~= nil then
            var = var+1
            table.insert(vipList, {citizenid = citizenid, rank = rank})
        end
    end
    
    addPayment(vipList)
    if Config.debug then
        print("Paid to "..var.." vips")
    end
end

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