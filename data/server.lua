if Config.Framework == 'qbcore' then
    QBCore = exports[Config.QB_prefix..'core']:GetCoreObject()
end 

Framework = {}

function Framework.PlayerDataS(source)
    if Config.Framework == 'qbcore' then
        local data = QBCore.Functions.GetPlayer(source)
        local Pdata = {
            Pid = data.PlayerData.citizenid,
            Name = data.PlayerData.charinfo.firstname..' '..data.PlayerData.charinfo.lastname,
            Identifier = data.PlayerData.identifier,
            Bank = data.Functions.GetMoney('bank'),
            Cash = data.Functions.GetMoney('cash'),
            Source = source, 
            AddMoney = data.Functions.AddMoney, 
            RemoveMoney = data.Functions.RemoveMoney,
            Job = data.PlayerData.job,
            
        }
        return Pdata
    elseif Config.Framework == 'esx' then
        local data = ESX.GetPlayerFromId(source)
        --print(json.encode(data))
        local Pdata = {
            Pid = data.identifier,
            Name = data.name,
            Identifier = data.identifier,
            Bank = data.getAccount('bank').money,
            Cash = data.getMoney(),
            Dirty = data.getAccount('black_money').money, -- ESX only since QBCore uses Items. 
            Source = source,
            AddMoney = data.addAccountMoney,
            RemoveMoney = data.removeAccountMoney,
            Job = data.job,            
        }
        return Pdata
    end
end

function Framework.GetPlayerFromPidS(pid)
    if Config.Framework == 'esx' then
        local data = ESX.GetPlayerFromIdentifier(pid)
        local source = data.source
        local result = Framework.PlayerDataS(source)
        return result
    elseif Config.Framework == 'qbcore' then
        local data = QBCore.Functions.GetPlayer(pid)
        local source = data.source
        local result = Framework.PlayerDataS(source)
        return result
    end
end

function Framework.NotiS(source, message, type, time) --- type = 'info', 'success', 'error'
    if Config.CustomNotifications then
        Custom.NotiS(source, message, type, time)
    else 
        if Config.Framework == 'qbcore' then
            QBCore.Functions.Notify(source, message, type, time)
        elseif Config.Framework == 'esx' then
            local Player = ESX.GetPlayerFromId(source)
            Player.showNotification(message)
        end
    end
end

function Framework.RegisterServerCallback(name, callback)
    if Config.Framework == 'qbcore' then
        QBCore.Functions.RegisterCallback(name, callback)
    elseif Config.Framework == 'esx' then
        ESX.RegisterServerCallback(name, callback)
    end
end

exports('GetFrameworkObject', function()
    return Framework
end)