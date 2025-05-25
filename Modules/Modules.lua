Modules = {}
Modules.ResourceName = GetCurrentResourceName()

function Modules.getEventName(eventsname)
    return ("%s:%s"):format(Modules.ResourceName,eventsname)
end

function Modules.print(...)
    local args = { ... }
    local ignore = false

    if type(args[#args]) == "boolean" then
        ignore = args[#args]
        table.remove(args)
    end

    local message = table.concat(args, " ")
    print(("[^6%s^0]: %s"):format(Modules.ResourceName,message))
end

