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
        print(json.encode(data.accounts))
        local pAccount = data.accounts
        local pBank = {}
        local pCash = {}
        local pDirty = {}
        for k,v in pairs(pAccount) do
            if v.name == 'bank' then
                bank = v.money
            elseif v.name == 'money' then
                cash = v.money
            elseif v.name == 'black_money' then
                black = v.money
            end
        end
       

        local Pdata = {
            Pid = data.identifier,
            Name = data.name,
            Identifier = data.identifier,
            Bank = pBank,
            Cash = pCash,
            Dirty = pDirty,
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


function Framework.DrawText(action, text)
    if Config.CustomDrawText_CL == false then 
        if action == 'open' then
            if Config.Framework == 'qbcore' then
                QBCore.Functions.DrawText(action, text)
            elseif Config.Framework == 'esx' then
                Custom.DrawTextUI('open', text) 
                
            end
        else
            if Config.Framework == 'qbcore' then
                QBCore.Functions.DrawText(action, text)
            elseif Config.Framework == 'esx' then
                Custom.DrawTextUI('close') 
                
            end 
        end 
    else 
        if action == 'open' then
            print('hihihihihihihihih')
            Custom.DrawTextUI('open', text) 
        else
            Custom.DrawTextUI('close') 
        end
    end 
end

function Framework.NotiC(message, type, time)
    if Config.CustomNotifications then
        Custom.NotiC(message, type, time)
    else
        if time == nil then time = 3000 end
        if Config.Framework == 'qbcore' then
            if type == 'info' then type = 'primary' end
            QBCore.Functions.Notify(message, type, time)
        elseif Config.Framework == 'esx' then
            ESX.ShowNotification(message, time, type)
        end
    end 
end 

if Config.Framework == 'qbcore' then
    AddEventHandler('QBCore:Client:OnPlayerLoaded', function()
        TriggerEvent('710-lib:PlayerLoaded')
    end)
elseif Config.Framework == 'esx' then
    RegisterNetEvent('esx:playerLoaded')
    AddEventHandler('esx:playerLoaded', function()
        TriggerEvent('710-lib:PlayerLoaded')
    end) 
end

RegisterNetEvent('710-lib:PlayerLoaded')
AddEventHandler('710-lib:PlayerLoaded', function()
    -- Do nothing this is just to trigger things within scripts with 
    -- AddEventHandler('710-lib:PlayerLoaded', function()
    --- Code you want to execute here when the player loads
    -- end)
end)

function Framework.CreateContextMenu(menu)
    print('Creating context menu')
    if Config.Framework == 'qbcore' then
        if menu.txt == nil then menu.txt = menu.context end
        if menu.params == nil then menu.params = {event=menu.event, isServer=menu.server, args=menu.args} end
        exports[Config.QB_prefix..'menu']:openMenu(menu)
    else 
        TriggerEvent('nh-context:createMenu', menu)
    end 
end    



exports('GetFrameworkObject', function()
    return Framework
end)