if Config.Framework == 'qbcore' then
    QBCore = exports[Config.QB_prefix..'core']:GetCoreObject()
end

local groupSystem = 'none' --- leave as none unless using a different group system if it doesnt detect any below it will use the built in group functions

--- These were the only group systems I could think of by default if you have different ones you can adapt them below.
if GetResourceState('ps-playergroups') == 'started' then groupSystem = 'ps' end
if GetResourceState('yseries') == 'started' then groupSystem = 'yflip' end


if groupSystem == 'ps' then
    print('710-lib: Detected PS-PlayerGroups')

    RegisterNetEvent('710-lib:Groups:PS:AddItem', function(item, count)
        local source = source
        local Player = Framework.PlayerDataS(source)
        Player.AddItem(item, count)
    end)

    RegisterNetEvent('710-lib:Groups:PS:SendNoti', function(message)
        local source = source
        local Player = Framework.PlayerDataS(source)
        Player.Notify(message)
    end)

    RegisterNetEvent('710-lib:Groups:PS:AddMoney', function(type, amount)
        local source = source
        local Player = Framework.PlayerDataS(source)
        if type == 'cash' or type == 'money' then
            Player.AddCash(amount)
        elseif type == 'bank' then
            Player.AddBank(amount)
        elseif type == 'dirty' then
            Player.AddDirty(amount)
        elseif type == 'crypto' then
            ---- Add your crypto functions here if not using 710-crypto
            Player.AddCrypto('GNE', amount)
        else
            print('710-lib: Invalid money type '..type..' for group money add event.')
        end
    end)

elseif groupSystem == 'yflip' then
    ---- Copied same events from ps since they both use events for rewards
    print('710-lib: Detected yseries')
    RegisterNetEvent('710-lib:Groups:PS:AddItem', function(item, count)
        local source = source
        local Player = Framework.PlayerDataS(source)
        Player.AddItem(item, count)
    end)
    RegisterNetEvent('710-lib:Groups:PS:AddMoney', function(type, amount)
        local source = source
        local Player = Framework.PlayerDataS(source)
        if type == 'cash' or type == 'money' then
            Player.AddCash(amount)
        elseif type == 'bank' then
            Player.AddBank(amount)
        elseif type == 'dirty' then
            Player.AddDirty(amount)
        elseif type == 'crypto' then
            ---- Add your crypto functions here if not using 710-crypto
            Player.AddCrypto('GNE', amount)
        else
            print('710-lib: Invalid money type '..type..' for group money add event.')
        end
    end)
else
    print('710-lib: No group system detected, using built in group functions')
    local Groups = {}
    function checkIfInGroup(source)
        local source = source
        local Player = Framework.PlayerDataS(source)
        local Pid = Player.Pid
        if Groups ~= nil then
            if Groups[Pid] == nil then
                    for k,v in pairs(Groups) do
                        for i = 1, 6 do
                            if v.members[i] == Pid then
                                return true
                            end
                        end
                    end
                return false
            else
                return true
            end
        else
            return false
        end
    end
    --- Manage / View existing group -- Leaders will be able to add/remove people others can view / leave group.
    function manageExistingGroup(source, Pid, isLeader)
        TriggerClientEvent('710-group:manageExistingGroup', source, Pid, isLeader)
    end

    --- Create Group -- Create a group and add yourself as the leader.
    --- If you want to add more then 5  people per group you can add more to the table. put them all as false then when there is no slots will false it will say group is full

     function CreateGroup(Pid)
        Groups[Pid] = {}
        Groups[Pid] = {
            members = {
                [1] = Pid,
                [2] = false,
                [3] = false,
                [4] = false,
                [5] = false,
               -- [6] = false,
            }
        }
    end

    RegisterCommand('groups', function(source, args, rawCommand)
        TriggerEvent('710-groups:Group', source)
    end, false)

    --- Check / Create Group -- Give options to open group menu to invite players or start your own group.
    RegisterNetEvent('710-groups:Group', function(source)
        local source = source
        local Player = Framework.PlayerDataS(source)
        local Pid = Player.Pid
        local isInGroup = checkIfInGroup(source)
        if not isInGroup then
            Player.Notify('Group has been created!')
            CreateGroup(Pid)
        else
            if Groups[Pid] ~= nil then
                manageExistingGroup(source, Pid, true)
            else
                manageExistingGroup(source, Pid, false)
            end
        end
    end)

    RegisterNetEvent('710-groups:Groups', function()
        local source = source
        local Player = Framework.PlayerDataS(source)
        local Pid = Player.Pid
        local isInGroup = checkIfInGroup(source)
        if not isInGroup then
            Player.Notify('Group has been created!')
            CreateGroup(Pid)
        else
            if Groups[Pid] ~= nil then
                manageExistingGroup(source, Pid, true)
            else
                manageExistingGroup(source, Pid, false)
            end
        end
    end)

    function groupMembers(Pid)
        if Groups[Pid] ~= nil then
            return Groups[Pid].members
        else
            for k,v in pairs(Groups) do
                for i = 1, 6 do
                    if v.members[i] == Pid then
                        return v.members
                    end
                end
            end
        end
    end

    lib.callback.register('710-groups:getGroupInfo', function(source)
        local source = source
        local Player = Framework.PlayerDataS(source)
        local Pid = Player.Pid
        if Groups[Pid] ~= nil then
            return Groups[Pid].members
        else
            return false
        end
    end)

    function NotifyGroup(Pid, message, type)
        local PCheck = Framework.GetPlayerFromPidS(Pid)
        if PCheck then
            for k,v in pairs(Groups[Pid].members) do
                if v ~= false then
                    local pPlayer = Framework.GetPlayerFromPidS(v)
                    if pPlayer then
                        local PSource = pPlayer.Source
                        local Player = Framework.PlayerDataS(PSource)
                        if type == 'error' then
                            Player.Notify(message, 'error')
                        elseif type == 'success' then
                            Player.Notify(message, 'success')
                        elseif type == 'info' then
                            Player.Notify(message, 'info')
                        else
                            Player.Notify(message, 'info')
                        end
                    end
                end
            end
        else
            print('Group leader is no longer online')
        end
    end

    function GiveGroupReward(Pid, type, amount, reward)
        local PCheck = Framework.GetPlayerFromPidS(Pid)
        if PCheck then
            for k,v in pairs(Groups[Pid].members) do
                Wait(25)
                --print(v)
                if v ~= false then
                    local pPlayer = Framework.GetPlayerFromPidS(v)
                    local PSource = tonumber(pPlayer.Source)
                -- print(json.encode(pPlayer))
                -- print(PSource)
                    local Player = Framework.PlayerDataS(PSource)
                    if type == 'cash' then
                        Player.AddCash(amount)
                    elseif type == 'bank' then
                        Player.AddBank(amount)
                    elseif type == 'item' then
                        Player.AddItem(reward, amount)
                    elseif type == 'crypto' then
                        Player.AddMoney('usdc', amount)
                        --exports["lb-phone"]:AddCrypto(PSource, 'usd-coin', amount)
                    -- Player.AddCrypto(reward, amount)
                    elseif type == 'crimrep' then
                        exports['710-stuff']:AddCrimRep(Player.Pid, amount)
                    elseif type == 'dirty' then
                        Player.AddDirtyMoney(amount)
                    elseif type == 'avlaptop' then
                        exports['av_laptop']:addMoney(PSource, "pepe", amount)
                    else
                        print('Invalid reward type was provided Change this in the GiveGroupReward event if you want to add different types')
                    end
                end
            end
        else
            print('Group leader is no longer online')
        end
    end

    local function deleteGroup(Pid)
        if Groups[Pid] ~= nil then
            Groups[Pid] = nil
        end
    end

    exports('deleteGroup', deleteGroup)


    RegisterNetEvent('710-groups:removeMember', function(gPid)
        local source = source
        local Player = Framework.PlayerDataS(source)
        local Pid = Player.Pid
        if Groups[Pid] ~= nil then
            for k,v in pairs(Groups[Pid].members) do
                if v == gPid then
                    Groups[Pid].members[k] = false
                end
            end
        end
    end)

    lib.callback.register('710-groups:getPlayerName', function(source, Pid)
        local PCheck = Framework.GetPlayerFromPidS(Pid)
        if PCheck then
            return PCheck.Name
        else
            return 'No Name Found'
        end
    end)

    RegisterNetEvent('710-groups:leaveGroup', function()
        local source = source
        local Player = Framework.PlayerDataS(source)
        local Pid = Player.Pid
        if Groups[Pid] ~= nil then
            --Groups[Pid] = nil
            deleteGroup(Pid)
        else
            for k,v in pairs(Groups) do
                for i = 1, 6 do
                    if v.members[i] == Pid then
                        v.members[i] = false
                    end
                end
            end
        end
    end)

    RegisterNetEvent('710-groups:acceptInviteToGroup', function(data)
        local source = source
        local Player = Framework.PlayerDataS(source)
        local Pid = Player.Pid
        print(data)
        local LeaderPid = data
        if Groups[Pid] ~= nil then
            deleteGroup(Pid)
        end
        --print(json.encode(Groups[LeaderPid].members))
        for k,v in pairs(Groups[LeaderPid].members) do
            if v == false then
                if Pid ~= LeaderPid then
                    Groups[LeaderPid].members[k] = Pid
                break
                end
            end
        end
    end)

    RegisterNetEvent('710-groups:InviteNewPlayerToGroup', function(Psource)
        local source = source
        local Player = Framework.PlayerDataS(source)
        local PlayerName = Player.Name
        TriggerClientEvent('710-groups:InvitedToGroup', Psource, PlayerName, Player.Pid)
    end)

end



--- Group functions
Framework.Group = {}

--- Create a group and add leader
Framework.Group.CreateGroup = function(source)
    if groupSystem == 'ps' then
        exports["ps-playergroups"]:CreateGroup(source)
    elseif groupSystem == 'yflip' then
        exports["yseries"]:CreateGroup(source)
    else
        --- No group system detected so we use 710-lib's built in group system
        local Player = Framework.PlayerDataS(source)
        local Pid = Player.Pid
        local isInGroup = checkIfInGroup(source)
        if not isInGroup then
            Player.Notify('Group has been created!')
            CreateGroup(Pid)
        else
            if Groups[Pid] ~= nil then
                manageExistingGroup(source, Pid, true)
            else
                manageExistingGroup(source, Pid, false)
            end
        end
    end
end

--- Add item to everyone in group
Framework.Group.AddItem = function(groupid, item, count)
    if groupSystem == 'ps' then
        exports["ps-playergroups"]:GroupEvent(groupid, '710-lib:Groups:PS:AddItem', {item = item, count = count})
    elseif groupSystem == 'yflip' then
        exports["yseries"]:SendGroupEvent(groupid, '710-lib:Groups:PS:AddItem', {item = item, count = count})
    else
        GiveGroupReward(groupid, 'item', count, item)
    end
--- exports["ps-playergroups"]:GroupEvent(groupID, eventname, args) 
end

--- Check if player is in group, if so return groupid, else return false
Framework.Group.CheckIfInGroup = function(source)
    if groupSystem == 'yflip' then
        return exports["yseries"]:FindGroupByMember(source)
    elseif groupSystem == 'ps' then
        local groupid = exports["ps-playergroups"]:FindGroupByMember(source)
        if groupid ~= 0 then
            return groupid
        else
            return false
        end
    else
        --- No group system detected so we use 710-lib's built in group system
        local Player = Framework.PlayerDataS(source)
        local Pid = Player.Pid
        local group = groupMembers(Pid)
        if group then
            local leader = group[1]
            return leader
        else
            return false
        end
    end

end
--- return group memebers
Framework.Group.GetGroupMembers = function(groupid)
    if groupSystem == 'ps' then
        return exports["ps-playergroups"]:GetGroupMembers(groupid)
    elseif groupSystem == 'yflip' then
        return exports["yseries"]:GetGroupMembers(groupid)
    else
        --- No group system detected so we use 710-lib's built in group system
        return groupMembers(groupid)
    end
end
--- get amount of members in the group
Framework.Group.GetGroupMemberCount = function(groupid)
    if groupSystem == 'ps' then
        return exports["ps-playergroups"]:GetGroupMemberCount(groupid)
    elseif groupSystem == 'yflip' then
        return exports["yseries"]:GetGroupMemberCount(groupid)
    else
        --- No group system detected so we use 710-lib's built in group system
        local members = groupMembers(groupid)
        local count = 0
        for k,v in pairs(members) do
            if v ~= false then
                count = count + 1
            end
        end
        return count
    end
end
--- Send notification to everyone in the group
Framework.Group.SendNoti = function(groupid, message)
    if groupSystem == 'ps' then
        exports["ps-playergroups"]:GroupEvent(groupid, '710-lib:Groups:PS:SendNoti', {message = message})
    elseif groupSystem == 'yflip' then
        exports["yseries"]:NotifyGroup(groupid, message, 10000)
    else    
        NotifyGroup(groupid, message, 'info')
        --- No group system detected so we use 710-lib's built in group system
    end
end

--- Support for adding crypto, dirty, bank or cash by default.
Framework.Group.AddMoney = function(groupid, type, amount)
    if groupSystem == 'ps' then
    exports["ps-playergroups"]:GroupEvent(groupid, '710-lib:Groups:PS:AddMoney', {type = type, amount = amount})
    elseif groupSystem == 'yflip' then
        exports["yseries"]:SendGroupEvent(groupid, '710-lib:Groups:PS:AddMoney', {type = type, amount = amount})
    else
        --- No group system detected so we use 710-lib's built in group system
        GiveGroupReward(groupid, type, amount)
    end
end
RegisterNetEvent('710-lib:server:groups:makeGPS', function(coords, label)
    local source = source
    TriggerClientEvent('ps-markgps:client:CreateMarker', source, coords, label)
end)

Framework.Group.MarkGPS = function(groupid, coords, label)
    if groupSystem == 'ps' then
        exports["ps-playergroups"]:GroupEvent(groupid, '710-lib:server:groups:makeGPS', {coords = coords, label = label})
    elseif groupSystem == 'yflip' then
        exports["yseries"]:SendGroupEvent(groupid, '710-lib:server:groups:makeGPS', {coords = coords, label = label})
    else
        --- No group system detected so we use 710-lib's built in group system
        for k,v in pairs(groupMembers(groupid)) do
            if not v then return end
            local pPlayer = Framework.GetPlayerFromPidS(v)
            if pPlayer then
                local PSource = pPlayer.Source
                TriggerClientEvent('ps-markgps:client:CreateMarker', PSource, coords, label)
            end
        end
    end
end