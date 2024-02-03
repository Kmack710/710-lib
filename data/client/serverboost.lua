
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