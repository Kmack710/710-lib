if Config.Framework == 'qbcore' then
    QBCore = exports[Config.QB_prefix..'core']:GetCoreObject()
end

RegisterNetEvent('710-group:manageExistingGroup', function(Pid, isLeader)
    local Player = Framework.PlayerDataC()
    local groupInfo = lib.callback.await('710-groups:getGroupInfo', false)
    print(isLeader) 
    print(Pid)
    if isLeader then
        --- create menu for leader
        --- 710-groups:getPlayerName -- servercb 
        print(json.encode(groupInfo))
        local menuOptions = {}
        for k,v in pairs(groupInfo) do
            Wait(25)
            print(v)
            if v ~= false then
                local name = lib.callback.await('710-groups:getPlayerName', false, v)
                local desc = 'Remove from group'
                if name == Player.Name then 
                    name = name .. ' (You)'
                    desc = 'Disband Group'
                end
                table.insert(menuOptions, {
                    title = name,
                    description = desc,
                    arrow = true,
                    event = '710-groups:removeFromGroup',
                    args = {Pid = v}
                })
            else
                table.insert(menuOptions, {
                    title = 'Empty spot',
                    description = 'Invite Someone',
                    arrow = true,
                    event = '710-groups:inviteToGroup',
                })
            end
        end
            print('making menu for leader')
            lib.registerContext({
                id = 'groupMenu',
                title = 'Your group',
                options = menuOptions,
            })

            lib.showContext('groupMenu')
    else
        -- Create leave menu for non leader
        local menuOptions2 = {
            {
                title = 'Leave Group',
                description = 'Leave your group',
                arrow = true,
                event = '710-groups:leaveGroupC',
            }
        }

            lib.registerContext({
                id = 'leaveGroupMenu',
                title = 'Group Options',
                options = menuOptions2,
            })
        lib.showContext('leaveGroupMenu')

    end


end)

RegisterNetEvent('710-groups:removeFromGroup', function(data)
    local Pid = data.Pid
    --print(Pid)
    TriggerServerEvent('710-groups:removeMember', Pid)
end)

RegisterNetEvent('710-groups:leaveGroupC', function()
    TriggerServerEvent('710-groups:leaveGroup')
end)

RegisterNetEvent('710-groups:inviteToGroup', function()
    local input = lib.inputDialog('Invite Someone to group', {'State ID'})

    if not input then return end
    local personToInvite = input[1]

    --print(personToInvite)
    TriggerServerEvent('710-groups:InviteNewPlayerToGroup', tonumber(personToInvite))

end)

RegisterNetEvent('710-groups:InvitedToGroup', function(PlayerName, Lpid)
    local alert = lib.alertDialog({
        header = 'You have been invited to a group!',
        content = PlayerName..'\n has invited you to a group! \n Would you like to join?',
        centered = true,
        cancel = true,
        size = 'sm'
    })
    if alert == 'confirm' then
        TriggerServerEvent('710-groups:acceptInviteToGroup', Lpid)
    end
end)

RegisterNetEvent('ps-markgps:client:CreateMarker', function(coords, label)
    local marker = AddBlipForCoord(coords.x, coords.y, coords.z)
    SetBlipSprite(marker, 1)
    SetBlipDisplay(marker, 4)
    SetBlipScale(marker, 0.8)
    SetBlipColour(marker, 5)
    SetBlipAsShortRange(marker, true)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString(label)
    EndTextCommandSetBlipName(marker)
end)

AddEventHandler('710-lib:PlayerLoaded', function()
	Wait(3000)
	TriggerEvent('chat:addSuggestion', '/groups',  "Check your group")
end)