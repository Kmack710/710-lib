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
## Server Boosts
### To use the serverboost functions you first have to either add codes manually to the database table (710_boost) OR link your database to your tebex make a package and add something like this into the "game server actions" directly to the product
```sql
INSERT INTO `710_boost` VALUES ('{transaction}', '1', '0');
```
### This sql statement means thats their code to redeem will be their tebex transaction ID, the 1 is the amount of hours the boost will be for, and the 0 means it hasnt been redeemed yet so for example if you wanted 3 hours it would be like this:
```sql
INSERT INTO `710_boost` VALUES ('{transaction}', '3', '0');
```
### and so on, Then in resources you can use it like so with exports
```lua
local rewardOrWhateverYouWantToBeEffectedByTheServerBoost = 1000 --- 1000 reward normally without boost
local isBoostActive = exports['710-lib']:isBoostActive()
if isBoostActive then
    rewardOrWhateverYouWantToBeEffectedByTheServerBoost = rewardOrWhateverYouWantToBeEffectedByTheServerBoost * 2 --- Double the reward if boost is active
end
Player.AddMoney(rewardOrWhateverYouWantToBeEffectedByTheServerBoost) --- if boost is active gives 2x if not gives default value.
```


### Will be adding more docs soon if others want to use the lib for their resources!
