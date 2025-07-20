--[[
    Revision Unknown
    Author iirzd

    Updated Thursday 28th December 2023 at 23:19 GMT
]]
local PlayerService = game:GetService("Players")

local remote
local orderNumber = 0
local workstations = {}

local function getOrder(workstation)
    local orderValue = workstation.Occupied.Value:WaitForChild("Order")

    return {
        orderValue.Style.Value,
        orderValue.Color.Value
    }
end

local function doWork(workstation)
    local workEvent
    local inUseEvent
    
    workstations[workstation] = true

    workEvent = workstation.Occupied.Changed:Connect(function(value)
        if not value then return end

        remote:FireServer({
            Type = "FinishHair",
            Workstation = workstation,
            Order = getOrder(workstation)
        })

        orderNumber = orderNumber + 1
        local date   = os.date("*t", now)
        print("Finished order ".. orderNumber .." at ".. date["hour"] ..":".. date["min"])
    end)

    inUseEvent = workstation.InUse.Changed:Connect(function(value)
        if value ~= PlayerService.LocalPlayer and workEvent ~= nil then
            warn("You have changed your workstation. Stopping the old workEvent and resetting metamethod.")
            workstations = {}
            workEvent:Disconnect()
            inUseEvent:Disconnect()
        end
    end)
end

-- Actual Processing --
warn("Setting up metamethods")

local metatable = getrawmetatable(game)
local backupNamecall = metatable.__namecall

-- make the metatable writeable
local setreadonly = make_writeable or setreadonly -- some executors have different function names so we have to check if they exist
setreadonly(metatable, false)

-- overwrite namecall metamethod
metatable.__namecall = function(...)
    local args = {...}
    if args[#args] == "FireServer" then
        if args[2] and type(args[2]) == "table" and args[2]["Order"] and not workstations[args[2]["Workstation"]] then
            warn("The remote and the workstation have been found!")
            remote = args[1]
            doWork(args[2]["Workstation"])
        end
    end
    return backupNamecall(...)
end
