Config = {}
--- IMPORTANT MAKE SURE TO CHECK EVERY OPTION before use. 
Config.Framework = 'qbcore' -- 'auto', 'qbcore' or 'esx'
Config.QB_prefix = 'qb-' -- If you change your resource names 
Config.Inventory = 'ox_inventory' -- 'ox_inventory', 'qb/aj/lj-inventory' or 'custom' -- IF custom goto custom-client and custom-server! 
Config.UseJobCommand = false -- true or false -- This is a /Job command built in it works with 710-PoliceJob automatically to so dept and rank. Works for all other jobs too! 




ShConfig = { --- THIS IS A SHARED CONFIG -- Is what this means is you can call this config in any resource with Framework.Config then whatever option you are looking for 
    Framework = Config.Framework, --- Change this above dont change it here. 
    QbPre = Config.QB_prefix, --- Change this above dont change it here. 
    OxSQL = 'new', -- 'new' or 'old' -- New means most up to date version old means anything 1.9.0 or older
    MenuResource = 'qb-menu', -- OLD - ONLY OX_LIB NOW 
    InventoryResource = Config.Inventory, --- Change this above dont change it here. 
    InputResource = 'qb-input', -- ONLY OX LIB NOW 
    InputTarget = 'qtarget', -- qb-target or ox_target

}
----- Auto detect resources ---- Dont touch anything below unless you know what your doing.
if Config.Framework == 'auto' then 
    if GetResourceState('qb-core') == 'started' then 
        Config.Framework = 'qbcore'
    elseif GetResourceState('es_extended') == 'started' then 
        Config.Framework = 'esx'
    elseif GetResourceState('qbx-core') == 'started' then 
        Config.Framework = 'qbcore' --- turn on compatibility for qbcore on your server.cfg for now, I will make an update soon that will use it all directly.
    end
end

if Config.Inventory == 'auto' then 
    if GetResourceState('ox_inventory') == 'started' then 
        Config.Inventory = 'ox_inventory'
    elseif GetResourceState('qb-inventory') == 'started' or GetResourceState('aj-inventory') == 'started' or GetResourceState('lj-inventory') == 'started' or GetResourceState('ps-inventory') then
        Config.Inventory = 'qb-inventory' --- All inventories above use the same events so we just mark as qb-inventory
    elseif GetResourceState('qs-inventory') == 'started' then
        Config.Inventory = 'qs-inventory'
    end
end

if ShConfig.InputTarget == 'auto' then
    if GetResourceState('qb-target') == 'started' then
        ShConfig.InputTarget = 'qb-target'
    elseif GetResourceState('qtarget') == 'started' then
        ShConfig.InputTarget = 'qtarget'
    elseif GetResourceState('ox_target') == 'started' then
        ShConfig.InputTarget = 'ox_target'
    end
end


