
taskHandler = {}

local tasks = nil

function taskHandler.init()
    tasks = {}
    tasks[1] = Task("Build base for colonists", 
                    "Get a sample from one of the crystals",
                    function()  end,
                    function()  end)
    tasks[2] = Task("Acquire crystal sample", 
                    "Get a sample from one of the crystals",
                    function() return probe.sample end,
                    function() taskHandler.activate(3) end)
    tasks[3] = Task("Do science on sample", 
                    "Analyze a crystal sample in the lander",
                    function() return #lander.samples > 0 end,
                    function() taskHandler.activate(4) end)
    tasks[4] = Task(" ??? ", 
                    "Get a sample from one of the crystals and bring it to the lander for analyzation",
                    function() return #lander.samples > 0 end,
                    function()  end)
                    
    tasks[1].active = true
    tasks[2].active = true
end

-- get list of all visible tasks
function taskHandler.getTasklist()
    local list = {}
    for i,task in ipairs(tasks) do
        if task.active and task.dt > 0 then table.insert(list, task) end
    end
    return list
end

-- evaluate all tasks
function taskHandler.update(dt)
    for i,task in ipairs(tasks) do
        if task.active and not task.finished then 
            if task.eval() then 
                task.finished = true
                task.payoff()
            end
        end
        if task.finished and task.dt > 0 then task.dt = task.dt - dt end
    end
end

function taskHandler.activate(id)
    if tasks[id] and not tasks[id].finished then tasks[id].active = true end
end
