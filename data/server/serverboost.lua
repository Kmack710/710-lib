

local boostActive = false
local boostTimeRemaining = 0 -- minutes 
local function isBoostActive()
    return boostActive
end

Framework.BoostActive = function()
    return boostActive
end

RegisterCommand('boosttime', function(source, args, rawCommand)
    local source = source 
    local Player = Framework.PlayerDataS(source)
    if boostActive then
        Player.Notify('There is ' .. boostTimeRemaining .. ' minutes remaining on the server boost!', 'success')
    else
        Player.Notify('There is no server boost active!', 'error')
    end
end)

exports('isBoostActive', isBoostActive)

lib.callback.register('710-stuff:isBoostActive', function(source)
    return isBoostActive()
end)

lib.callback.register('710-stuff:GetBoostTimeRemaining', function(source)
    return boostTimeRemaining
end)


local function startBoostTimer()
    CreateThread(function()
        Wait(1500)
        while boostTimeRemaining > 0 do
            Wait(60 * 1000)
            boostTimeRemaining = boostTimeRemaining - 1
        end
        boostActive = false
    end)
end

RegisterCommand('serverboost', function(source, args, rawCommand)
    local source = source
    local Player = Framework.PlayerDataS(source)
    local tbxid = args[1]
    local tbxcode = MySQL.query.await('SELECT * FROM 710_boost WHERE tbxid = ?', {tbxid})
    if tbxcode[1] then
        if tbxcode[1].redeemed == 0 then
            if not boostActive then
                MySQL.query('UPDATE 710_boost SET redeemed = 1 WHERE tbxid = ?', {tbxid})
                boostActive = true
                boostTimeRemaining = tbxcode[1].boosthrs * 60
                startBoostTimer()
                local multi = "2x"
                Wait(1000)
                -- Example -- Removes stress for 30 seconds and removes 10 units every 5 seconds
                local buffTime = boostTimeRemaining * 60000
                TriggerClientEvent('710-stuff:ServerBoostBuffs', -1, buffTime)
                
                Player.Notify('SERVER BOOST ACTIVE! This will boost alot of things by '..multi..'!! This boost will last for '..boostTimeRemaining..' Minutes!')
            else
                Player.Notify('Server Boost is already active!, There is ' .. boostTimeRemaining .. ' minutes remaining!', 'error')
            end
        else
            Player.Notify('This code has already been redeemed!', 'error')
        end
    else
        Player.Notify('This code is invalid!', 'error')
    end
end)


AddEventHandler('onResourceStart', function(resourceName)
    if (GetCurrentResourceName() ~= resourceName) then
        return
    end
    --[[CREATE TABLE `710_boost` (
	`tbxid` VARCHAR(255) NULL DEFAULT NULL COLLATE 'utf8mb3_general_ci',
	`boosthrs` INT(11) NULL DEFAULT NULL,
	`redeemed` INT(11) NULL DEFAULT NULL
)]]
    if ShConfig.OxSQL == 'new' then
        MySQL.ready(function()
            MySQL.Async.execute("CREATE TABLE IF NOT EXISTS 710_boost (tbxid VARCHAR(255) PRIMARY KEY, boosthrs INT(11), redeemed INT(11))")
        end)
    else 
        exports.oxmysql:ready(function()
            exports.oxmysql:execute("CREATE TABLE IF NOT EXISTS 710_boost (tbxid VARCHAR(255) PRIMARY KEY, boosthrs INT(11), redeemed INT(11))")
        end)
    end
end)