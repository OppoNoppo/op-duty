lib.callback.register('op-duty:swapDuty', function()
    
    local xPlayer = ESX.GetPlayerFromId(source)
    local jobdata = xPlayer.getJob()
    local ok = {
        status = false,
        was = jobdata.name
    }
    
    for k,v in pairs(Config.dutyJobs) do
        if jobdata.name == Config.dutyJobs[k].onDuty then
            xPlayer.setJob(Config.dutyJobs[k].offDuty, jobdata.grade)
            ok.status = true
        end

        if jobdata.name == Config.dutyJobs[k].offDuty then
            xPlayer.setJob(Config.dutyJobs[k].onDuty, jobdata.grade)
            ok.status = true     
        end
    end
    return ok
end)