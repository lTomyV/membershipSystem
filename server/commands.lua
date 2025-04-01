local QBCore = exports['qb-core']:GetCoreObject()

QBCore.Commands.Add(Config.commands.addCoins.cmd, Config.commands.addCoins.dsc, {}, false, function(source, args)
    local src = source
    local xPlayer = QBCore.Functions.GetPlayer(src)
    local target = tonumber(args[1])
    local amount = tonumber(args[2])

    if target and amount then
        local xTarget = QBCore.Functions.GetPlayer(target)

        if xTarget then
            MySQL.Async.execute('UPDATE players SET coins = coins + @coins WHERE citizenid = @citizenid', {['@coins'] = amount, ['@citizenid'] = xTarget.PlayerData.citizenid}, function(rowsChanged)
                if rowsChanged > 0 then
                    sendToDiscord("["..xPlayer.PlayerData.license.."] has added "..amount.." coins to "..xTarget.PlayerData.charinfo.firstname.." "..xTarget.PlayerData.charinfo.lastname.." ["..xTarget.PlayerData.license.."]")
                    TriggerClientEvent('QBCore:Notify', xPlayer.PlayerData.source, 'Has añadido '..amount..' coins a '..xTarget.PlayerData.charinfo.firstname..' '..xTarget.PlayerData.charinfo.lastname, 'success')
                    TriggerClientEvent('QBCore:Notify', xTarget.PlayerData.source, 'Has recibido '..amount..' coins de '..xPlayer.PlayerData.charinfo.firstname..' '..xPlayer.PlayerData.charinfo.lastname, 'success')
                    xTarget.Functions.SetPlayerData('coins', xTarget.PlayerData.coins + amount)
                end
            end)
        else
            TriggerClientEvent('QBCore:Notify', xPlayer.PlayerData.source, 'El jugador no está conectado', 'error')
        end
    else
        TriggerClientEvent('QBCore:Notify', xPlayer.PlayerData.source, 'Debes ingresar un ID y una cantidad', 'error')
    end
end, "admin")

QBCore.Commands.Add(Config.commands.removeCoins.cmd, Config.commands.removeCoins.dsc, {}, false, function(source, args)
    local src = source
    local xPlayer = QBCore.Functions.GetPlayer(src)
    local target = tonumber(args[1])
    local amount = tonumber(args[2])

    if target and amount then
        local xTarget = QBCore.Functions.GetPlayer(target)

        if xTarget then
            MySQL.Async.execute('UPDATE players SET coins = coins - @coins WHERE citizenid = @citizenid', {['@coins'] = amount, ['@citizenid'] = xTarget.PlayerData.citizenid}, function(rowsChanged)
                if rowsChanged > 0 then
                    sendToDiscord("["..xPlayer.PlayerData.license.."] has removed "..amount.." coins to "..xTarget.PlayerData.charinfo.firstname.." "..xTarget.PlayerData.charinfo.lastname.." ["..xTarget.PlayerData.license.."]")
                    TriggerClientEvent('QBCore:Notify', xPlayer.PlayerData.source, 'Has removido '..amount..' coins a '..xTarget.PlayerData.charinfo.firstname..' '..xTarget.PlayerData.charinfo.lastname, 'success')
                    TriggerClientEvent('QBCore:Notify', xTarget.PlayerData.source, 'Te retiraron x'..amount..' coins STAFF: '..GetPlayerName(xPlayer.PlayerData.source), 'error')
                    xTarget.Functions.SetPlayerData('coins', xTarget.PlayerData.coins - amount)
                end
            end)
        else
            TriggerClientEvent('QBCore:Notify', xPlayer.PlayerData.source, 'El jugador no está conectado', 'error')
        end
    else
        TriggerClientEvent('QBCore:Notify', xPlayer.PlayerData.source, 'Debes ingresar un ID y una cantidad', 'error')
    end
end, "admin")

QBCore.Commands.Add(Config.commands.setCoins.cmd, Config.commands.setCoins.dsc, {}, false, function(source, args)
    local src = source
    local xPlayer = QBCore.Functions.GetPlayer(src)
    local target = tonumber(args[1])
    local amount = tonumber(args[2])

    if target and amount then
        local xTarget = QBCore.Functions.GetPlayer(target)

        if xTarget then
            MySQL.Async.execute('UPDATE players SET coins = @coins WHERE citizenid = @citizenid', {['@coins'] = amount, ['@citizenid'] = xTarget.PlayerData.citizenid}, function(rowsChanged)
                if rowsChanged > 0 then
                    sendToDiscord("["..xPlayer.PlayerData.license.."] has set "..amount.." coins to "..xTarget.PlayerData.charinfo.firstname.." "..xTarget.PlayerData.charinfo.lastname.." ["..xTarget.PlayerData.license.."]")
                    TriggerClientEvent('QBCore:Notify', xPlayer.PlayerData.source, 'Has establecido '..amount..' coins a '..xTarget.PlayerData.charinfo.firstname..' '..xTarget.PlayerData.charinfo.lastname, 'success')
                    TriggerClientEvent('QBCore:Notify', xTarget.PlayerData.source, 'Tus coins han sido establecidos a '..amount..' por '..xPlayer.PlayerData.charinfo.firstname..' '..xPlayer.PlayerData.charinfo.lastname, 'success')
                    xTarget.Functions.SetPlayerData('coins', amount)
                end
            end)
        else
            TriggerClientEvent('QBCore:Notify', xPlayer.PlayerData.source, 'El jugador no está conectado', 'error')
        end
    else
        TriggerClientEvent('QBCore:Notify', xPlayer.PlayerData.source, 'Debes ingresar un ID y una cantidad', 'error')
    end
end, "admin")

QBCore.Commands.Add(Config.commands.addMembership.cmd, Config.commands.addMembership.dsc, {}, false, function(source, args)
    local src = source
    local xPlayer = QBCore.Functions.GetPlayer(src)
    local target = tonumber(args[1])
    local rank = args[2] and string.lower(args[2]) or nil

    local isLicense = false
    -- Check if target starts with "license:"
    if string.match(args[1], "license:") then
        isLicense = true
    end

    if isLicense then
        if target and rank then
            -- Check if the rank exists
            if Config.ranks[rank] then
                MySQL.Async.execute('UPDATE players SET membership = @membership WHERE license = @license', {['@membership'] = rank, ['@license'] = target}, function(rowsChanged)
                    if rowsChanged > 0 then
                        sendToDiscord("["..xPlayer.PlayerData.license.."] has added "..rank.." membership to "..target)
                        
                        TriggerClientEvent('QBCore:Notify', xPlayer.PlayerData.source, 'Has añadido '..rank..' membresía a '..target, 'success')
                    end
                end)
            else
                TriggerClientEvent('QBCore:Notify', xPlayer.PlayerData.source, 'El rango no existe', 'error')
            end
        else
            TriggerClientEvent('QBCore:Notify', xPlayer.PlayerData.source, 'Debes ingresar un ID y un rango', 'error')
        end
    else
        if target and rank then 
            -- Check if the rank exists
            if Config.ranks[rank] then
                local xTarget = QBCore.Functions.GetPlayer(target)
                if xTarget then
                    MySQL.Async.execute('UPDATE players SET membership = @membership WHERE citizenid = @citizenid', {['@membership'] = rank, ['@citizenid'] = xTarget.PlayerData.citizenid}, function(rowsChanged)
                        if rowsChanged > 0 then
                            xTarget.Functions.SetPlayerData('membership', rank)
                            sendToDiscord("["..xPlayer.PlayerData.license.."] has added "..rank.." membership to "..xTarget.PlayerData.charinfo.firstname.." "..xTarget.PlayerData.charinfo.lastname.." ["..xTarget.PlayerData.license.."]")
                            TriggerClientEvent('QBCore:Notify', xPlayer.PlayerData.source, 'Has añadido '..rank..' membresía a '..xTarget.PlayerData.charinfo.firstname..' '..xTarget.PlayerData.charinfo.lastname, 'success')
                            TriggerClientEvent('QBCore:Notify', xTarget.PlayerData.source, 'Has recibido membresía '..rank..' de '..xPlayer.PlayerData.charinfo.firstname..' '..xPlayer.PlayerData.charinfo.lastname, 'success')
                        end
                    end)
                else
                    TriggerClientEvent('QBCore:Notify', xPlayer.PlayerData.source, 'El jugador no está conectado', 'error')
                end
            else
                TriggerClientEvent('QBCore:Notify', xPlayer.PlayerData.source, 'El rango no existe', 'error')
            end  
        else
            TriggerClientEvent('QBCore:Notify', xPlayer.PlayerData.source, 'Debes ingresar un ID y un rango', 'error')
        end
    end
end, "admin")

QBCore.Commands.Add(Config.commands.removeMembership.cmd, Config.commands.removeMembership.dsc, {}, false, function(source, args)
    local src = source
    local xPlayer = QBCore.Functions.GetPlayer(src)
    local target = tonumber(args[1])

    local isLicense = false
    -- Check if target starts with "license:"
    if string.match(args[1], "license:") then
        isLicense = true
    end

    if isLicense then
        if target then
            MySQL.Async.execute('UPDATE players SET membership = @membership WHERE license = @license', {['@membership'] = nil, ['@license'] = target}, function(rowsChanged)
                if rowsChanged > 0 then
                    sendToDiscord("["..xPlayer.PlayerData.license.."] has removed membership to "..target)
                    TriggerClientEvent('QBCore:Notify', xPlayer.PlayerData.source, 'Has removido membresía a '..target, 'success')
                end
            end)
        else
            TriggerClientEvent('QBCore:Notify', xPlayer.PlayerData.source, 'Debes ingresar un ID', 'error')
        end
    else
        if target then
            local xTarget = QBCore.Functions.GetPlayer(target)
    
            if xTarget then
                MySQL.Async.execute('UPDATE players SET membership = @membership WHERE citizenid = @citizenid', {['@membership'] = nil, ['@citizenid'] = xTarget.PlayerData.citizenid}, function(rowsChanged)
                    if rowsChanged > 0 then
                        sendToDiscord("["..xPlayer.PlayerData.license.."] has removed membership to "..xTarget.PlayerData.charinfo.firstname.." "..xTarget.PlayerData.charinfo.lastname.." ["..xTarget.PlayerData.license.."]")
                        TriggerClientEvent('QBCore:Notify', xPlayer.PlayerData.source, 'Has removido membresía a '..xTarget.PlayerData.charinfo.firstname..' '..xTarget.PlayerData.charinfo.lastname, 'success')
                        TriggerClientEvent('QBCore:Notify', xTarget.PlayerData.source, 'Tu membresía acaba de ser revocada', 'error')
                        xTarget.Functions.SetPlayerData('membership', nil)
                    end
                end)
            else
                TriggerClientEvent('QBCore:Notify', xPlayer.PlayerData.source, 'El jugador no está conectado', 'error')
            end
        else
            TriggerClientEvent('QBCore:Notify', xPlayer.PlayerData.source, 'Debes ingresar un ID', 'error')
        end
    end
end, "admin")

-- Suggestions for addCoins command
TriggerEvent('chat:addSuggestion', '/' .. Config.commands.addCoins.cmd, Config.commands.addCoins.dsc, {
    { name="playerID", help="ID of the player" },
    { name="amount", help="Amount of coins to add" }
})

-- Suggestions for removeCoins command
TriggerEvent('chat:addSuggestion', '/' .. Config.commands.removeCoins.cmd, Config.commands.removeCoins.dsc, {
    { name="playerID", help="ID of the player" },
    { name="amount", help="Amount of coins to remove" }
})

-- Suggestions for setCoins command
TriggerEvent('chat:addSuggestion', '/' .. Config.commands.setCoins.cmd, Config.commands.setCoins.dsc, {
    { name="playerID", help="ID of the player" },
    { name="amount", help="Amount of coins to set" }
})

-- Suggestions for addMembership command
TriggerEvent('chat:addSuggestion', '/' .. Config.commands.addMembership.cmd, Config.commands.addMembership.dsc, {
    { name="playerID/license", help="ID or license of the player" },
    { name="rank", help="Rank to add" }
})

-- Suggestions for removeMembership command
TriggerEvent('chat:addSuggestion', '/' .. Config.commands.removeMembership.cmd, Config.commands.removeMembership.dsc, {
    { name="playerID/license", help="ID or license of the player" }
})