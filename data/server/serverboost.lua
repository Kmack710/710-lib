

local boostActive = false
local boostTimeRemaining = 0 -- minutes 
local function isBoostActive()
    return boostActive
end

Framework.BoostActive = function()
    return boostActive
end

RegisterCommand('econboosttime', function(source, args, rawCommand)
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

local function sendWebhooktoDiscord(hours)
    local Webhook = 'https://discord.com/api/webhooks/1227672862710566922/2Dw14GW6q1UYDw7x5WW1OKScOPJiMoaGdYHKeRBSGKVfjv6iZQWom2QyF603BT08bHjI'
        --- send discord webhook for normal server
        local embed = {
            {
                ["color"] = 3447003,
                ["title"] = "A Econ boost has been activated for " .. hours .. " hours!",
                ["description"] = "This will boost \n - Fishing \n- Mining  \n- Robbery Rewards (Banks, Drug runs, Carboosting, etc) \n- Drug sales (selling) \n- Drug Collection and Processing (amount) \n-Job Salaries (All 2x Police & EMS are 3x) \n-Other Jobs (Repo, Delivery, Garbage, Gruppe6, etc)",
                ["footer"] = {
                    ["text"] = "Econ Boost",
                },
            }
        }
        ---  <@&1056345924575694869>
        PerformHttpRequest(Webhook, function(err, text, headers) end, 'POST', json.encode({username = "Xposed RP", content = '<@&1227664928001884200>'}), {['Content-Type'] = 'application/json'})
        PerformHttpRequest(Webhook, function(err, text, headers) end, 'POST', json.encode({username = "Xposed RP", embeds = embed}), {['Content-Type'] = 'application/json'})
        --- send the post webhook 
end

RegisterCommand('econboost', function(source, args, rawCommand)
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
                sendWebhooktoDiscord(tbxcode[1].boosthrs)
                startBoostTimer()
                local multi = "2x"
                Wait(1000)
                -- Example -- Removes stress for 30 seconds and removes 10 units every 5 seconds
               -- local buffTime = boostTimeRemaining * 60000
               -- TriggerClientEvent('710-stuff:ServerBoostBuffs', -1, buffTime)
                TriggerClientEvent('710-lib:serverboost:alertAllOfBoost', -1, multi, boostTimeRemaining)
                --Player.Notify('ECON BOOST ACTIVE! This will boost alot of things by '..multi..'!! This boost will last for '..boostTimeRemaining..' Minutes!')
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