ESX = nil
CreateThread(function ()
    while ESX == nil do
        Wait(500)
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
    end
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
	ESX.PlayerData = xPlayer
	ESX.PlayerLoaded = true
end)

RegisterNetEvent('esx:onPlayerLogout')
AddEventHandler('esx:onPlayerLogout', function()
	ESX.PlayerLoaded = false
	ESX.PlayerData = {}
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	ESX.PlayerData.job = job
end)

local inMarker = false

CreateThread(function ()
    if Config.dutyJobs then
        while ESX == nil do
            Wait(500)
        end
        for k,v in pairs(Config.dutyJobs) do
            local d = Config.dutyJobs
            for i=1, #d[k].coords do
                local po = lib.points.new(d[k].coords[i], 2, {})
                function po:onEnter()
                    inMarker = true
                    if (ESX.PlayerData.job.name == Config.dutyJobs[k].onDuty or ESX.PlayerData.job.name == Config.dutyJobs[k].offDuty) then
                        lib.showTextUI("[E] - On/Off Duty")
                    end
                end
                function po:nearby()
                    if self.currentDistance < 2.0 and IsControlJustReleased(0, 38) then
                        if ESX.PlayerData.job.name == Config.dutyJobs[k].onDuty or ESX.PlayerData.job.name == Config.dutyJobs[k].offDuty then
                            local swaps = lib.callback.await('op-duty:swapDuty', false)
                                
                            if swaps.status then
    
                                local desc, type
                                if swaps.was == Config.dutyJobs[k].onDuty then
                                    desc = "You are now off duty" 
                                    type = 'error'
                                elseif swaps.was == Config.dutyJobs[k].offDuty then
                                    desc = "You are now on duty"
                                    type = 'success'
                                end
    
                                if desc and type then
                                    lib.notify({
                                        title = "Duty",
                                        description = desc,
                                        type = type
                                    })
                                end
                            else
                                lib.notify({
                                    title = "Duty",
                                    description = "Error during change",
                                    type = 'error'
                                })
                            end
                        end
                    end
                end
                function po:onExit()
                    inMarker = false
                    lib.hideTextUI()
                end
            end
        end
    else
        print('No Config values found')
    end
end)
