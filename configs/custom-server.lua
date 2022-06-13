Custom = {} 
if Config.Framework == 'qbcore' then
    QBCore = exports[Config.QB_prefix..'core']:GetCoreObject()
end 

function Custom.NotiS(source, message, type, time) --- type = 'info', 'success', 'error'
    if time == nil then time = 3000 end
    --- if type == 'info' then type = 'primary' end --- example if your notis dont use options above 
    TriggerClientEvent('okokNotify:Alert', source, "", message, time, type)
end

---- For /job command to work with 710-PoliceJob or even without it works on both frameworks.
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

--[[function Custom.CompanyAccount(action, company, amount)
    local companyOK = "society_"..company --- since okok adds a prefix to the company name
    local compaccount = MySQL.query.await('SELECT * FROM okokBanking_societies WHERE society = @company', {['@company'] = companyOK})
    if action == 'add' then 
        MySQL.update('UPDATE okokBanking_societies SET amount = ? WHERE society = ?', { compaccount[1].value + amount, companyOK })
    elseif action == 'remove' then
        if compaccount[1].value >= amount then
            MySQL.update('UPDATE okokBanking_societies SET amount = ? WHERE society = ?', { compaccount[1].value - amount, companyOK })
        else
            return false
        end
    elseif action == 'balance' then
        if compaccount then
            return compaccount[1].value
        else
            return false
        end
    end]]