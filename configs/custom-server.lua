Custom = {} 
if Config.Framework == 'qbcore' then
    QBCore = exports[Config.QB_prefix..'core']:GetCoreObject()
end 

function Custom.NotiS(source, message, type, time) --- type = 'info', 'success', 'error'
    if time == nil then time = 3000 end
    --- if type == 'info' then type = 'primary' end --- example if your notis dont use options above 
    TriggerClientEvent('okokNotify:Alert', source, "", message, time, type)
end