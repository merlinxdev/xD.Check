ESX = exports['es_extended']:getSharedObject()

XD = {
    JobList = {},
    Players = {}
}

RegisterNetEvent(Modules.getEventName("JobUpdate"))
AddEventHandler(Modules.getEventName("JobUpdate"), function(jobList, playerCount)
    XD.JobList = jobList or {}
    XD.Players = playerCount or 0
    if config.debug then
        for k,v in pairs(XD.JobList) do
                Modules.print(("^3[JobUpdate] ^7Job (^6%s^7) = ^3%d"):format(getNamebyindex(k), v), true)
        end
    end
end)

function getJobIndex(jobName)
    for index, job in pairs(config.service) do
        if jobName == job then
            return XD.JobList[index] or 0
        end
    end
    return 0
end

function getNamebyindex(index_items)
    for index, job in pairs(config.service) do
        if index == index_items then
            return job
        end
    end
end

exports('check', function(jobName)
    return getJobIndex(jobName)
end)

exports('players', function()
    return XD.Players or 0
end)