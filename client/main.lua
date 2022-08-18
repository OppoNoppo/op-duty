local ESX = nil
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

CreateThread(function ()
    if Config.dutyJobs then
        for k,v in pairs(Config.dutyJobs) do
            local d = Config.dutyJobs
            local po = lib.points.new(d[k].coords, 2, {})
            while true do
                Wait(100)
                if (ESX.PlayerData.job.name == Config.dutyJobs[k].onDuty) then
                    function po:onEnter()
                        lib.showTextUI("[E] - On/Off Duty")
                    end

                    function po:nearby()
                        if self.currentDistance < 2 and IsControlJustReleased(0, 38) then
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
                
                    function po:onExit()
                        lib.hideTextUI()
                    end
                end
            end
        end
    else
        print('No Config values found')
    end
end)