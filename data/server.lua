if Config.Framework == 'qbcore' then
    QBCore = exports[Config.QB_prefix..'core']:GetCoreObject()
end 

Framework = {}

function Framework.PlayerDataS(source)
    local source = tonumber(source)
    if Config.Framework == 'qbcore' then
        local data = QBCore.Functions.GetPlayer(source)
        local pJob = data.PlayerData.job
        pJob.Grade = {}
        pJob.Grade.name = pJob.grade.name
        pJob.Grade.label = pJob.grade.name
        pJob.Grade.level = pJob.grade.level
        local Pdata = {
            Pid = data.PlayerData.citizenid,
            Name = data.PlayerData.charinfo.firstname..' '..data.PlayerData.charinfo.lastname,
            Identifier = data.PlayerData.license,
            Bank = data.Functions.GetMoney('bank'),
            Cash = data.Functions.GetMoney('cash'),
            Source = data.PlayerData.source,
            RemoveItem = data.Functions.RemoveItem,
            AddItem = data.Functions.AddItem,  
            AddMoney = data.Functions.AddMoney, 
            RemoveMoney = data.Functions.RemoveMoney,
            AddBankMoney = function(amount) data.Functions.AddMoney('bank', amount) end,
            RemoveBankMoney = function(amount) data.Functions.RemoveMoney('bank', amount) end,
            AddCash = function(amount) data.Functions.AddMoney('cash', amount) end,
            RemoveCash = function(amount) data.Functions.RemoveMoney('cash', amount) end,
            AddDirtyMoney = function(amount) data.Functions.AddItem('markedbills', amount) end,
            RemoveDirtyMoney = function(amount) data.Functions.RemoveItem('markedbills', amount) end,
            Job = pJob,
            SetJob = data.Functions.SetJob,
            HasItem = function(item, amount) return QBCore.Functions.HasItem(source, item, amount) end,
            Notify = function(message, type, time) Framework.NotiS(source, message, type, time) end,
            Gang = data.PlayerData.gang,
            SetGang = data.Functions.SetGang, 
            QBDuty = data.PlayerData.job.onduty,
            SetDuty = data.Functions.SetJobDuty,
            Inventory = data.PlayerData.items,
            AddCompanyMoney = function(amount) Framework.AddCompanyMoney(data.PlayerData.job.name, amount) end,
            RemoveCompanyMoney = function(amount) Framework.RemoveCompanyMoney(data.PlayerData.job.name, amount) end,
            CompanyBalance = function() return Framework.GetCompanyBalance(pJob.job.name) end,
            onDuty = function() return Framework.GetDuty(source) end,
        }
        if GetResourceState('710-crypto') == 'started' then
            Pdata.AddCrypto = function(crypto, amount) return exports['710-crypto']:addCrypto(data.PlayerData.citizenid, crypto, amount) end
            Pdata.RemoveCrypto = function(crypto, amount) return exports['710-crypto']:removeCrypto(data.PlayerData.citizenid, crypto, amount) end
            Pdata.CryptoBalance = function(crypto) return exports['710-crypto']:getCryptoBalance(data.PlayerData.citizenid, crypto) end
        end
        return Pdata
    elseif Config.Framework == 'esx' then
        local data = ESX.GetPlayerFromId(source)
        local pJob = data.job
        pJob.Grade = {}
        pJob.Grade.name = data.job.grade_name
        pJob.Grade.label = data.job.grade_label
        pJob.Grade.level = data.job.grade
        
        local Pdata = {
            Pid = data.identifier,
            Name = data.name,
            Identifier = data.identifier,
            Bank = data.getAccount('bank').money,
            Cash = data.getMoney(),
            Dirty = data.getAccount('black_money').money, 
            Source = source,
            RemoveItem = data.removeInventoryItem,
            AddItem = data.addInventoryItem,
            AddCash = data.addMoney,
            RemoveCash = data.removeMoney,
            AddBankMoney = function(amount) data.addAccountMoney('bank', amount) end,
            RemoveBankMoney = function(amount) data.removeAccountMoney('bank', amount) end,
            AddDirtyMoney = function(amount) data.removeAccountMoney('black_money', amount) end,
            RemoveDirtyMoney = function(amount) data.removeAccountMoney('black_money', amount) end,
            Job = pJob,
            SetJob = data.setJob,
            Notify = function(message, type, time) Framework.NotiS(source, message, type, time) end,
            HasItem = data.hasItem,
            Inventory = data.getInventory(true),
            AddCompanyMoney = function(amount) Framework.AddCompanyMoney(pJob.job.name, amount) end,
            RemoveCompanyMoney = function(amount) Framework.RemoveCompanyMoney(pJob.job.name, amount) end,
            CompanyBalance = function() return Framework.GetCompanyBalance(pJob.job.name) end,
            onDuty = function() return Framework.GetDuty(source) end,
        }
        if GetResourceState('710-crypto') == 'started' then
            Pdata.AddCrypto = function(crypto, amount) return exports['710-crypto']:addCrypto(data.identifier, crypto, amount) end
            Pdata.RemoveCrypto = function(crypto, amount) return exports['710-crypto']:removeCrypto(data.identifier, crypto, amount) end
            Pdata.CryptoBalance = function(crypto) return exports['710-crypto']:getCryptoBalance(data.identifier, crypto) end
        end
        return Pdata
    else
        ---- add your own frameworks here. 
    end
end

function Framework.GetDuty(source)
    local source = tonumber(source)
    if Config.Framework == 'qbcore' then
        local data = QBCore.Functions.GetPlayer(source)
        return data.PlayerData.job.onduty
    elseif Config.Framework == 'esx' then --- dont think esx has a default way? 
        local data = ESX.GetPlayerFromId(source)
        return data.job.onduty
    else
        --- custom frameworks
    end
end

function Framework.GetCompanyBalance(company)
    if GetResourceState('qb-banking') == 'started' then
        exports['qb-banking']:GetAccountBalance(company)
    elseif GetResourceState('qb-management') == 'started' then
        return exports['qb-management']:GetAccount(company).balance
    elseif GetResourceState('qbx-management') == 'started' then
        return exports['qbx-management']:GetAccount(company).balance
    elseif GetResourceState('Renewed-Banking') == 'started' then
        return exports['Renewed-Banking']:getAccountMoney(company).balance
    elseif GetResourceState('okokBanking') == 'started' then
        return exports['okokBanking']:GetAccount(company).balance
    elseif GetResourceState('710-Management') == 'started' then
        return exports['710-Management']:GetManagementAccount(company).balance
    else
        print('^1 NO BANKING RESOURCE FOUND, to use banking features please add your banking resource to the server.lua file in Function "Framework.GetCompanyBalance". ^0')
    end
end

function Framework.AddCompanyMoney(company, amount)
    if GetResourceState('qb-banking') == 'started' then
        exports['qb-banking']:AddMoney(company, amount)
    elseif GetResourceState('qbx-management') == 'started' then
        exports['qbx-management']:AddMoney(company, amount)
    elseif GetResourceState('qb-management') == 'started' then
        exports['qb-management']:AddMoney(company, amount)
    elseif GetResourceState('Renewed-Banking') == 'started' then
        exports['Renewed-Banking']:AddAccountMoney(company, amount)
    elseif GetResourceState('okokBanking') == 'started' then
        exports['okokBanking']:AddMoney(company, amount)
    elseif GetResourceState('710-Management') == 'started' then
        exports['710-Management']:AddAccountMoney(company, amount)
    else
        print('^1 NO BANKING RESOURCE FOUND, to use banking features please add your banking resource to the server.lua file in Function "Framework.AddCompanyMoney". ^0')
    end
end

function Framework.RemoveCompanyMoney(company, amount)
    if GetResourceState('qb-banking') == 'started' then
        exports['qb-banking']:RemoveMoney(company, amount)
    elseif GetResourceState('qbx-management') == 'started' then
        exports['qbx-management']:RemoveMoney(company, amount)
    elseif GetResourceState('qb-management') == 'started' then
        exports['qb-management']:RemoveMoney(company, amount)
    elseif GetResourceState('Renewed-Banking') == 'started' then
        exports['Renewed-Banking']:RemoveAccountMoney(company, amount)
    elseif GetResourceState('okokBanking') == 'started' then
        exports['okokBanking']:RemoveMoney(company, amount)
    elseif GetResourceState('710-Management') == 'started' then
        exports['710-Management']:RemoveAccountMoney(company, amount)
    else
        print('^1 NO BANKING RESOURCE FOUND, to use banking features please add your banking resource to the server.lua file in Function "Framework.RemoveCompanyMoney". ^0')
    end
end


function Framework.GetPlayerFromPidS(pid)
    if Config.Framework == 'esx' then
        local data = ESX.GetPlayerFromIdentifier(pid)
        if data ~= nil then
            local Pdata = Framework.PlayerDataS(data.source)
            return Pdata
        else
            return false
        end

    elseif Config.Framework == 'qbcore' then
        local data = QBCore.Functions.GetPlayerByCitizenId(pid)
        if data ~= nil then
            local Pdata = Framework.PlayerDataS(data.PlayerData.source)
            return Pdata
        else
            return false
        end
    end
end



function Framework.NotiS(source, message, type, time) --- type = 'info', 'success', 'error'
    if type == nil then type = 'inform' end
    if time == nil then time = 3000 end
    if type == 'warn' then type = 'warning' end
    if type == 'info' then type = 'inform' end
    local data = {
        description = message,
        type = type,
        duration = time,
    }
    TriggerClientEvent('ox_lib:notify', source, data)
    --- Change or add your own notis here.
end
            
function Framework.AdminCheck(source)
    if Config.Framework == 'esx' then 
        local Player = ESX.GetPlayerFromId(source)
        local perms = Player.getGroup()
        if perms == 'admin' then
            return true
        else
            return false
        end
    elseif Config.Framework == 'qbcore' then 
       local perms = QBCore.Functions.GetPermission(source)
       if perms.god == true or perms.admin == true then
            return true
        else
            return false
        end
    end 
end


lib.callback.register('710-lib:GetPlayerName', function(source)
    local Pdata = Framework.PlayerDataS(source)
    if Pdata then
        return Pdata.Name
    else
        return false
    end
end)

function Framework.RegisterStash(stashid, stashlabel, stashslots, stashweightlimit, stashowner)
    if GetResourceState('ox_inventory') == 'started' then
        exports.ox_inventory:RegisterStash(stashid, stashlabel, stashslots, stashweightlimit, stashowner)
    elseif GetResourceState('qs-inventory') == 'started' then
        local source = nil
        if stashowner ~= nil then
            local pldata = Framework.GetPlayerFromPidS(stashowner)
            source = pldata.Source --- since qs uses source we have to get it first
        end
        exports['qs-inventory']:RegisterStash(source, stashid, stashslots, stashweightlimit)
    else
        -- qb does this client side. 
        --- you could add other inventories code here if they arent above to make it work with any inventory 
    end
end

function Framework.AddItemToStash(stashid, item, amount)
    if GetResourceState('ox_inventory') == 'started' then
        exports.ox_inventory:AddItem(stashid, item, amount)
    elseif GetResourceState('qs-inventory') == 'started' then
        exports['qs-inventory']:AddItemIntoStash(stashid, item, amount)
    else
        --- add other inventories 
        --- qb doesnt let you add to a stash without a slot number so ummm.... get a better inventory?
    end
end

function Framework.CreateUseableItem(item, cb)
    if Config.Framework == 'qbcore' then 
        QBCore.Functions.CreateUseableItem(item, cb) 
    elseif Config.Framework == 'esx' then
        ESX.RegisterUsableItem(item, cb)
    else
        --- other inventories or frameworks here
    end 
end 

function Framework.GetJobLabel(job)
    if tonumber(job) ~= nil then return false end 
	if Config.Framework == 'qbcore' then 
        if QBCore.Shared.Jobs[job] ~= nil then
            return QBCore.Shared.Jobs[job].label
        else
            return false
        end
	elseif Config.Framework == 'esx' then
        if ESX.GetJobs()[job] ~= nil then
            return ESX.GetJobs()[job].label
        else
            return false
        end
	end
end

function Framework.GetOnlinePlayers()
    if Config.Framework == 'qbcore' then 
        return QBCore.Functions.GetPlayers()
    elseif Config.Framework == 'esx' then
        return ESX.GetPlayers()
    end 
end

lib.callback.register('710-lib:GetJobLabel', function(source, job)
    local jobLabel = Framework.GetJobLabel(job)
    if jobLabel then
        return jobLabel
    else
        return false
    end
end)



function Framework.GetItemLabel(source, item)
    if GetResourceState('ox_inventory') == 'started' then
        local result = exports.ox_inventory:GetItem(source, item, nil, false)
        if result ~= nil then
            return result.label
        else
            return false
        end
    elseif Config.Framework == 'esx' then
        local result = MySQL.query.await("SELECT * FROM items WHERE name = @name", {['@name'] = item})
        if result ~= nil then
            return result[1].label
        else
            return false
        end
    else
        return QBCore.Shared.Items[item].label
    end
end

lib.callback.register('710-lib:getItemLabel', function(source, item)
    if GetResourceState('ox_inventory') == 'started' then
        local result = exports.ox_inventory:getItem(item)
        if result ~= nil then
            cb(result.label)
        else
            cb(false)
        end
    elseif Config.Framework == 'esx' then
        local result = MySQL.query.await("SELECT * FROM items WHERE name = @name", {['@name'] = item})
        if result ~= nil then
            return result[1].label
        else
            return false
        end
    else
        cb(QBCore.Shared.Items[item].label)
    end
end)

function Framework.Config()
    return ShConfig
end

exports('GetFrameworkObject', function()
    return Framework
end)

RegisterNetEvent('710-lib:makeNewUserInDB', function()
    local source = source
    local Player = Framework.PlayerDataS(source)
    local isInDB = false
    if ShConfig.OxSQL == 'new' then
        local result = MySQL.query.await("SELECT * FROM 710_users WHERE pid = @pid", {['@pid'] = Player.Pid})
        if result[1] ~= nil then
            isInDB = true
        end
    else 
        local result = exports.oxmysql:fetchSync("SELECT * FROM 710_users WHERE pid = @pid", {['@pid'] = Player.Pid})
        if result[1] ~= nil then
            isInDB = true
        end
    end
    if isInDB then return end
    if ShConfig.OxSQL == 'new' then
        MySQL.query("INSERT INTO 710_users (pid, name) VALUES (@pid, @name)", {['@pid'] = Player.Pid, ['@name'] = Player.Name})
    else 
        exports.oxmysql:execute("INSERT INTO 710_users (pid, name) VALUES (@pid, @name)", {['@pid'] = Player.Pid, ['@name'] = Player.Name})
    end
end)



if Config.UseJobCommand then 
    RegisterCommand('job',function(source, args, rawCommand)
        local Player = Framework.PlayerDataS(source)
        local Pid = Player.Pid
        if GetResourceState('710-PoliceJob') == 'started' then  
            if Player.Job.name == 'police' then 
                local PoliceInfo = exports['710-PoliceJob']:GetPlayerPoliceDept(Pid)
                Player.Notify('You are a '..PoliceInfo.rank..' in '..PoliceInfo.dept, 'success', 5000)
            else 
                Player.Notify('You are a '..Player.Job.Grade.label ..' in '..Player.Job.label, 'success', 5000)
            end 
        else
            Player.Notify('You are a '..Player.Job.Grade.label ..' in '..Player.Job.label, 'success', 5000)
        end
    end, false)
end


--- Phone functions, I added some of the most common phones, any others youll have to look at how these are done and add it for the phone you use.
Framework.Phone = {}
function Framework.Phone.SendMessage(to, from, message, attachments)
    if GetResourceState('lb-phone') == 'started' then
        exports["lb-phone"]:SendMessage(from, to, message, attachments)
    elseif GetResourceState('qs-phone') == 'started' or GetResourceState('qs-smartphone-pro') == 'started' then
        --- couldnt find anything in the docs for qs phone to support it for these functions. :( 
        --- Think it is coming soon tho :) 
    elseif GetResourceState('yflip-phone') == 'started' then
        exports["yflip-phone"]:SendNotification({
                app = 'messages',
                title = from,
                text = message,
                timeout = 5500, -- Default is 3000(optional).
                icon = 'https://cdn-icons-png.flaticon.com/128/10125/10125166.png', -- Default is the app icon, if you want custom don't send app(optional).
            }, 'phoneNumber', to)
    elseif GetResourceState('npwd') == 'started' then
        if not attachments then
            exports.npwd:emitMessage({
                senderNumber = from,
                targetNumber = to,
                message = message,
            })
        else
            exports.npwd:emitMessage({
                senderNumber = from,
                targetNumber = to,
                message = message,
                embed = {
                    type = "location",
                    coords = { attachments.x, attachments.y, attachments.z},
                    phoneNumber = from
                }
            })
        end
    else
        print('^1 NO PHONE RESOURCE FOUND, to use phone features please add your phone resource to the custom-server.lua file. ^0')
    end
end

function Framework.Phone.SendDarkChatMessage(from, channel, message, attachments) --- attachments is location only for dark chat, as most dont allow sending pictures
    if GetResourceState('lb-phone') == 'started' then
        exports["lb-phone"]:SendDarkChatMessage(from, channel, message)
        if attachments ~= nil then
            exports["lb-phone"]:SendDarkChatLocation(from, channel, attachments)
        end  
    elseif GetResourceState('qs-phone') == 'started' or GetResourceState('qs-smartphone-pro') == 'started' then
        --- Currently not possible with qs phone but think its coming soon :)
    elseif GetResourceState('yflip-phone') == 'started' then
        -- coming soon hopefully in their updates
    elseif GetResourceState('npwd') == 'started' then
        --- no dark chat for npwd by default? 
    else
        print('^1 NO PHONE RESOURCE FOUND, to use phone features please add your phone resource to the custom-server.lua file. ^0')
    end

end






AddEventHandler('onServerResourceStart', function(resourceName)
    if resourceName == GetCurrentResourceName() then 
        --- check if 710_users table exists, if not create it
        if ShConfig.OxSQL == 'new' then
            MySQL.ready(function()
                MySQL.Async.execute("CREATE TABLE IF NOT EXISTS 710_users (pid VARCHAR(255) PRIMARY KEY, name VARCHAR(255))")
            end)
        else 
            exports.oxmysql:ready(function()
                exports.oxmysql:execute("CREATE TABLE IF NOT EXISTS 710_users (pid VARCHAR(255) PRIMARY KEY, name VARCHAR(255))")
            end)
        end
        CreateThread(function()
            Wait(10055)
            updatePath = "/Kmack710/710-lib" -- your git user/repo path
            resourceName = GetCurrentResourceName() -- the resource name
            function checkVersion(err,responseText, headers)
                local curVersion = tonumber(1.9) -- make sure the "version" file actually exists in your resource root!
                local rresponseText = tonumber(responseText)
                if curVersion ~= rresponseText and curVersion < rresponseText then
                    print("^1################# RESOURCE OUT OF DATE ###############################")
                    print("^1"..resourceName.." is outdated, New Version: "..responseText.."Your Version: "..curVersion.." please update from https://github.com/Kmack710/710-lib")
                    print("############### Please Download the newest version ######################")
                elseif curVersion > rresponseText then
                    print("^2"..resourceName.." is up to date, have fun!")
                else
                    print("^2"..resourceName.." is up to date, have fun!")
                end
            end
            
            PerformHttpRequest("https://raw.githubusercontent.com"..updatePath.."/master/version", checkVersion, "GET")
        end)
    end
end)