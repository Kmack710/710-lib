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


if Config.Framework == 'qbcore' then
    Framework.Playerloaded = 'QBCore:Client:OnPlayerLoaded'
elseif Config.Framework == 'esx' then
    Framework.Playerloaded = 'esx:playerLoaded'
end


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