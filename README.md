# 710-Lib is A Multi-Framework Wrapper, Basically a Framework bridge for resources to work on multiple frameworks with little to no edits!
## Currently fully works on QBCore, QBox and ESX -- More coming maybe soon? 
### Any Scripts made with 710-lib Calls and exports will work on Any framework(ESX, Qbox and QBCore out of the box and any other one with some edits!)
## PR Changes if updates happen to frameworks or if you want to add another popular one like VRP, ox_core, ND-core! 

### To Install just paste this into your resources folder, add it under your framework, ox_lib and inventory on your server.cfg then add any resources that use it below. The SQL will install itself on first start up, and the config should auto-detect what resources and Framework you are using!


# Written to be SIMPLE to write in for Newer devs to get their creativity out there! 


## EXPORT that must be used at the top of any script using 710-lib 
```lua
-- Works on both server and client 
local Framework = exports['710-lib']:GetFrameworkObject()
```
### Will be adding more docs soon if others want to use the lib for their resources!
