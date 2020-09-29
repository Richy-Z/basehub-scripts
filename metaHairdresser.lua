-- Variables -- 
local remote = nil
local orderInc = 0
local workstationTable = {}

-- Metatable --
function setupMetatable()
	warn("[?] Setting up the Metamethods.")
	
	-- Metatable and Metamethods --
	local metatable = getrawmetatable(game)
	local backupNamecall = metatable.__namecall
	
	-- Make metatable writeable --
	local setreadonly = make_writeable or setreadonly
	setreadonly(metatable, false)
	
	-- Overwrite __namecall metamethod --
	metatable.__namecall = function(...)
		local args = {...}
		if(args[#args] == "FireServer") then
			if(args[2] and type(args[2]) == "table" and args[2]["Order"] and not workstationTable[args[2]["Workstation"]]) then
				warn("[!] Remote and Workstation have been found.")
				remote = args[1]
				
				doWork(args[2]["Workstation"])
			end
		end
		return backupNamecall(...)
	end
end

-- Get Order --
function getOrder(workstation)
	local orderValue = workstation.Occupied.Value:WaitForChild("Order")
	
	return {
		orderValue.Style.Value,
		orderValue.Color.Value
	}
end

-- Main --
setupMetatable()

function doWork(workstation)
	local workEvent = nil
	local inUseEvent = nil
	workstationTable[workstation] = true
	
	workEvent = workstation.Occupied.Changed:Connect(function(value)
		if(value == nil) then return end
		
		local order = getOrder(workstation)
		remote:FireServer({
			Type = "FinishHair",
			Workstation = workstation,
			Order = order
		})
		
		orderInc = orderInc + 1
		local date = os.date("*t", now)
		warn("[!] Finished Order => " .. orderInc .. " => " .. date["hour"] .. ":" .. date["min"])
	end)
	
	inUseEvent = workstation.InUse.Changed:Connect(function(value)
		if(value ~= game:GetService("Players").LocalPlayer and workEvent ~= nil) then
			warn("[?] You have changed your workstation, stopping old workEvent and resetting metamethod.")
			workstationTable = {}
			workEvent:Disconnect() 
			inUseEvent:Disconnect()
		end
	end)
end
