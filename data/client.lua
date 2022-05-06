if Config.Framework == 'qbcore' then
    QBCore = exports[Config.QB_prefix..'core']:GetCoreObject()
end 

Framework = {}

function Framework.PlayerDataC()
    if Config.Framework == 'qbcore' then 
        local data = QBCore.Functions.GetPlayerData()
        local Pdata = {
            Pid = data.citizenid,
            Name = data.charinfo.firstname..' '..data.charinfo.lastname,
            Identifier = data.identifier,
            Bank = data.bank,
            Cash = data.money,
            Source = data.source,
            Job = data.job,            
        }
        return Pdata
    elseif Config.Framework == 'esx' then 
        local data = ESX.GetPlayerData()
        local Pdata = {
            Pid = data.identifier,
            Name = data.name,
            Identifier = data.identifier,
            Bank = data.getAccount('bank').money,
            Cash = data.getMoney(),
            Dirty = data.getAccount('black_money').money,
            Source = data.playerId,
            Job = data.job,            
        }
        return Pdata 
    end
end  

function Framework.TriggerServerCallback(name, callback, ...)
    if Config.Framework == 'qbcore' then
        QBCore.Functions.TriggerCallback(name, callback, ...)
    elseif Config.Framework == 'esx' then
        ESX.TriggerServerCallback(name, callback, ...)
    end
end



if Config.Framework == 'qbcore' then
    AddEventHandler('QBCore:Client:OnPlayerLoaded', function()
        TriggerEvent('710-lib:PlayerLoaded')
    end)
elseif Config.Framework == 'esx' then
    AddEventHandler('esx:playerLoaded', function()
        print('ESX Player Loaded Triggered')
        TriggerEvent('710-lib:PlayerLoaded')
    end) 
end

RegisterNetEvent('710-lib:PlayerLoaded')
AddEventHandler('710-lib:PlayerLoaded', function()
    print('Player Loaded worked but didnt?')
    -- Do nothing this is just to trigger things within scripts with 
    -- AddEventHandler('710-lib:PlayerLoaded', function()
    --- Code you want to execute here when the player loads
    -- end)
end)

RegisterNetEvent('Framework:CreateContextMenu', function(menu) 
    if Config.Important['MenuResource'] == 'qb-menu' then 
        exports[Config.Important['iChangedQBnamesCauseImCool']..'menu']:openMenu(menu)
    elseif Config.Important['MenuResource'] == 'nh-context' then 
        TriggerEvent('nh-context:createMenu', menu)
    end 
end)

exports('GetFrameworkObject', function()
    return Framework
end)