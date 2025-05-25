ESX = exports['es_extended']:getSharedObject()

XD = {
    JobList = {},
    JobIndexToName = {},
    JobNameToIndex = {}
}

function UpdateJobCount(jobName, count)
    local index = XD.JobNameToIndex[jobName]
    if index then
        XD.JobList[index] = math.max(0, (XD.JobList[index] or 0) + count)
    end
end

AddEventHandler("esx:setJob", function(source, job, lastJob)
    if job and job.name then
        if not lastJob or (lastJob.name ~= job.name) then
            UpdateJobCount(job.name, 1)
        end
    end
    if lastJob and lastJob.name and lastJob.name ~= job.name then
        UpdateJobCount(lastJob.name, -1)
    end

    TriggerClientEvent(Modules.getEventName("JobUpdate"), -1, XD.JobList, GetNumPlayerIndices())
end)


AddEventHandler('esx:playerLoaded', function(playerData, isNew)
    local xPlayer = ESX.GetPlayerFromId(source)
    if not xPlayer then return end

    local job = xPlayer.getJob()
    if job and job.name then
        UpdateJobCount(job.name, 1)
    end

    TriggerClientEvent(Modules.getEventName("JobUpdate"), source, XD.JobList, GetNumPlayerIndices())
end)


AddEventHandler('playerDropped', function(reason)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    if not xPlayer then return end

    local job = xPlayer.getJob()
    if job and job.name then
        UpdateJobCount(job.name, -1)
    end
end)


AddEventHandler('onResourceStart', function(resource)
    if resource == GetCurrentResourceName() then

        for i, jobName in ipairs(config.service) do
            XD.JobList[i] = 0
            XD.JobIndexToName[i] = jobName
            XD.JobNameToIndex[jobName] = i
            if config.debug then
                Modules.print("^2Loaded ^7(^6"..jobName.."^7) ^7Service", true)
            end
        end
        
        for _, playerId in ipairs(GetPlayers()) do
            local xPlayer = ESX.GetPlayerFromId(tonumber(playerId))
            if xPlayer then
                local job = xPlayer.getJob()
                if job and job.name then
                    UpdateJobCount(job.name, 1)
                    Wait(50)
                end
            end
        end

        TriggerClientEvent(Modules.getEventName("JobUpdate"), -1, XD.JobList, GetNumPlayerIndices())
    end
end)

exports('check', function(jobName)
    local index = XD.JobNameToIndex[jobName]
    if index then
        return XD.JobList[index] or 0
    else
        return 0
    end
end)
