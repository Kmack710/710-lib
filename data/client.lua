if Config.Framework == 'qbcore' then
    QBCore = exports[Config.QB_prefix..'core']:GetCoreObject()
end 

Framework = {}

function Framework.PlayerDataC()
    if Config.Framework == 'qbcore' then 
        local data = QBCore.Functions.GetPlayerData()
        local pJob = data.job
        pJob.Grade = {}
        pJob.Grade.name = pJob.grade.name
        pJob.Grade.label = pJob.grade.name
        pJob.Grade.level = pJob.grade.level
        local Pdata = {
            Pid = data.citizenid,
            Name = data.charinfo.firstname..' '..data.charinfo.lastname,
            Identifier = data.identifier,
            Bank = data.bank,
            Cash = data.money,
            Source = data.source,
            Job = pJob,
            Notify = function(message, type, time) Framework.NotiC(message, type, time) end,
            Gang = data.gang,            
        }
        return Pdata
    elseif Config.Framework == 'esx' then 
        local data = ESX.GetPlayerData() 
        local pAccount = data.accounts
        local pBank = {}
        local pCash = {}
        local pDirty = {}
        for k,v in pairs(pAccount) do
            if v.name == 'bank' then
                pBank = v.money
            elseif v.name == 'money' then
                pCash = v.money
            elseif v.name == 'black_money' then
                pDirty = v.money
            end
        end
        local pJob = data.job
        pJob.Grade = {}
        pJob.Grade.name = data.job.grade_name
        pJob.Grade.label = data.job.grade_label
        pJob.Grade.level = data.job.grade
        local Pdata = {
            Pid = data.identifier,
            Name = lib.callback.await('710-lib:GetPlayerName', false),
            Identifier = data.identifier,
            Bank = pBank,
            Cash = pCash,
            Dirty = pDirty,
            Source = data.playerId,
            Job = pJob, 
            Notify = function(message, type, time) Framework.NotiC(message, type, time) end,      
        
        }
        return Pdata
    end
end

function Framework.GetClosestPlayer(coords)
    return lib.getClosestPlayer(coords)
    --[[if Config.Framework == 'qbcore' then  --- depreciated, use ox_lib directly
        return QBCore.Functions.GetClosestPlayer(coords)
    elseif Config.Framework == 'esx' then 
        return ESX.Game.GetClosestPlayer(coords)
    end]]
end

function Framework.GetClosestVehicle(coords)
    return lib.getClosestVehicle(coords)
end

function Framework.GetVehicleProperties(veh)
    return lib.getVehicleProperties(veh)
end

function Framework.OpenStash(stashlabel, stashslotsweight)
    if GetResourceState('ox_inventory') == 'started' then
        TriggerServerEvent('ox:loadStashes') 
        exports.ox_inventory:openInventory('stash', {id=stashlabel})
    elseif GetResourceState('qb-inventory') == 'started' or GetResourceState('qs-inventory') == 'started' then --- qs supports same events as qb inventory, so we just use that.
        TriggerServerEvent("inventory:server:OpenInventory", "stash", stashlabel, {
            maxweight = stashslotsweight.maxweight,
            slots = stashslotsweight.slots,
        })
        TriggerEvent("inventory:client:SetCurrentStash", stashlabel)
    else
        --- add other inventories here.
    end
end 

function Framework.SpawnVehicle(vehicle, coords, networked, cb)
    if Config.Framework == 'qbcore' then
        QBCore.Functions.SpawnVehicle(vehicle, cb, coords, networked)
    elseif Config.Framework == 'esx' then
        ESX.Game.SpawnVehicle(vehicle, coords.xyz, coords.w, cb, networked)
    end
end

function Framework.GetSourceFromEntity(entity)
    local ped = entity
    local playerIndex = NetworkGetPlayerIndexFromPed(ped)
    local playerServerId = GetPlayerServerId(playerIndex)
    if playerServerId ~= nil then
        return playerServerId
    else
        return nil
    end
end

function Framework.DrawText(action, text)
    if action == 'open' then
        lib.showTextUI(text)
        ---- Change to a different Drawtext if you have/want to here
    else
        lib.hideTextUI()
        ---- Change to a different Drawtext if you have/want to here
    end
end

function Framework.NotiC(message, type, time)
    if type == nil then type = 'inform' end
    if time == nil then time = 3000 end
    if type == 'warn' then type = 'warning' end
    if type == 'info' then type = 'inform' end
    lib.notify({
        description = message,
        type = type,
        duration = time,
    })
    --- if you want to use other notis or your framework ones add them here. and remove the lib.notify above
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
local PlayerIsLoaded = false

RegisterNetEvent('710-lib:PlayerLoaded')
AddEventHandler('710-lib:PlayerLoaded', function()
    PlayerIsLoaded = true
    Wait(1000)
    TriggerServerEvent('710-lib:makeNewUserInDB') --- To double check user is in 710_users table if not add them as some of my scripts use this
    -- Do nothing this is just to trigger things within scripts with 
    -- AddEventHandler('710-lib:PlayerLoaded', function()
    --- Code you want to execute here when the player loads
    -- end)
end)

Framework.IsPlayerLoaded = function()
    return PlayerIsLoaded
end

function Framework.GetJobLabel(job)
	local JobLabel = lib.callback.await('710-lib:GetJobLabel', false, job)
    if JobLabel then 
        return JobLabel
    else
        return false
    end
    
end 

function Framework.GetItemLabel(item)
    if Config.Inventory == 'ox_inventory' then
        for k, data in pairs(exports.ox_inventory:Items()) do
            if k == item then
                return data.label
            end
        end
    elseif Config.Framework == 'qbcore' then
        return QBCore.Shared.Items[item]['label']
    else
        return lib.callback.await('710-lib:getItemLabel', false, item)
       -- return ESX.Items[item].label
    end
end





function Framework.Config()
    return ShConfig
end 


exports('GetFrameworkObject', function()
    return Framework
end)

