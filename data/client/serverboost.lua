
local function isBoostActive()
    local Player = Framework.PlayerDataC()
    local serverBoost = lib.callback.await('710-lib:isBoostActive')
    if serverBoost then
        return true
    else
        return false
    end
end

Framework.BoostActive = function()
    return isBoostActive()
end

exports('isBoostActive', isBoostActive)

AddEventHandler('710-lib:PlayerLoaded', function()
   CreateThread(function()
        Wait(120 * 1000)
        local isBoostActivec = isBoostActive()
        if isBoostActivec then
            exports["lb-phone"]:SendNotification({
                title = "Economy Boost", -- the title of the notification
                content = "An Economy Boost is Active!", -- the description of the notification
            })
        end
   end)
end)

--- TriggerClientEvent('710-lib:serverboost:alertAllOfBoost', -1, multi, boostTimeRemaining)

RegisterNetEvent('710-lib:serverboost:alertAllOfBoost', function(multi, boostTimeRemaining)
    exports["lb-phone"]:SendNotification({
        title = "Economy Boost", -- the title of the notification
        content = "An Economy Boost is Active! For " .. boostTimeRemaining .. " minutes!", -- the description of the notification
    })
end)