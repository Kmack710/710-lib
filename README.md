# Docs on http://Kmack710.info/docs
# 710-Lib is A Multi-Framework Wrapper! 
### Any Scripts made with 710-lib Framework. Calls and export will work on Any framework(ESX and QBCore out of the box and any other one with some edits!)
## PR Changes if updates happen to frameworks or if you want to add another popular one like VRP! 
### There will still be some things that you will need to do specifc in your scripts but this removes most of the frame work calls with 710-lib calls. (Examples- Inventory systems, Clothing systems and stuff like that since people change them so much its harder to keep something like that going in here)


# Written to be SIMPLE to write in for Newer devs to get their creativity out there! 

## EXPORT that must be used at the top of any script using 710-lib 
```lua
-- Works on both server and client 
local Framework = exports['710-lib']:GetFrameworkObject()
```

# Server Functions 
## PlayerData 
### Framework.PlayerDataS(source)
Available args for player data are as follows
```lua
local Framework = exports['710-lib']:GetFrameworkObject()
local Player = Framework.PlayerDataS(source) --- Notice server has S on player data to make it easier to know what one to use on what side 

local Pid = Player.Pid -- CitizenID / Lisence on ESX for tagging stuff to specific members 
local Name = Player.Name -- Returns players first and last name 
local Identifier = Player.Identifier --- Returns Player Lisence 
local Bank = Player.Bank --- Return Player Bank balance 
local Cash = Player.Cash --- Returns Player Cash Balance 
local Dirty = Player.Dirty --- Returns  dirty money Only works for ESX right now qbcore coming soon. 
local Source = Player.Source --- If you need to use or check player source for anything. 
local AddMoney = Player.AddMoney("bank", 1000) --- adds 1000 to players bank 
local AddMoney = Player.AddMoney("cash", 1000) --- adds 1000 to players cash
local RemoveMoney =  Player.RemoveMoney("bank", 1000) --- same as above but removes instead 
local RemoveMoney =  Player.RemoveMoney("cash", 1000)
local Job = Player.Job --- Returns Job Table 
```
### Framework.GetPlayerFromPidS(pid)
This takes CitizenID on QBCore or Lisence on ESX aka Framework.PlayerDataS(source).Pid 
```lua
-- Example usage 
local Framework = exports['710-lib']:GetFrameworkObject()
local policeOnline = {'SDSD232', '8769SDSD'} --- this is just an example please dont loop a table you already have variables to when its this small... lol 
    if policeOnline ~= {} then 
        for k,v in pairs(policeOnline)
            local Player = Framework.GetPlayerFromPidS(v) --- This returns The same table as PlayerDataS 
            local PlayerSource = Player.Source -- So then you can use options from above 
            TriggerEvent('Notification', PlayerSource, 'A new officer has just gone on duty')
        end 
    end 
```
## Register Server Callback 
### Framework.RegisterServerCallback(name, callback)
```lua
--- Example for the code shown below to call it on client! ---Thanks to Idris for the Promsie code found in Client.lua! 
Framework.RegisterServerCallback('710-PoliceJob:CheckIfIsPolice', function(source, cb, pid)
    local DeptCheck = checkForPlayerDeptExample(pid)
    if DeptCheck ~= false then
        cb(DeptCheck)
    else
        cb(false)
    end
end)
```
# Client Functions 
### Framework.PlayerDataC() -- Remember source isnt needed since we are on client side.
Available list of options for Client side Basically same as server minus add/remove money cause that wouldnt be safe 
```lua
local Framework = exports['710-lib']:GetFrameworkObject()
local Player = Framework.PlayerDataC()

local Pid = Player.Pid -- CitizenID / Lisence on ESX for tagging stuff to specific members 
local Name = Player.Name -- Returns players first and last name 
local Identifier = Player.Identifier --- Returns Player Lisence 
local Bank = Player.Bank --- Return Player Bank balance 
local Cash = Player.Cash --- Returns Player Cash Balance
local Dirty = Player.Dirty --- Returns  dirty money Only works for ESX right now qbcore coming soon.  
local Source = Player.Source --- If you need to use or check player source for anything. 
local Job = Player.Job --- Returns Job Table 
```

## Trigger Server Callback 
### Framework.TriggerServerCallback(name, args)
```lua
--- Huge thanks to Idris for making this really easy and secure 
--- This runs a promise within 710-lib so its not just a normal callback! :) 
local PlayerPolice = Framework.TriggerServerCallback('710-PoliceJob:CheckIfIsPolice', pid) -- args is just Pid in this case so it gets that players rank and department for police 
if PlayerPolice then 
    PlayerRank = PlayerPolice.rank
    PlayerDepartment = PlayerPolice.dept 
end 
```





# Notifications 

## Server 
### Framework.NotiS(source, message, type, time)
```lua 
-- Example usage 
local Framework = exports['710-lib']:GetFrameworkObject()
local message = 'Hi my name is Joe'
Framework.NotiS(source, message, 'info' 5000) -- Time is optional 
-- Available types 
-- 'info' 
-- 'success'
-- 'error'
```
## Client 
### Framework.NotiC(message, type, time)
```lua 
-- Example useage 
local Framework = exports['710-lib']:GetFrameworkObject()
local message = 'My name is not Joe'
Framework.NotiC(message, 'error', 5000) -- time is optional 
-- Same types as server are available. 
```