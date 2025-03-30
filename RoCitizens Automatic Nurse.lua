for i = 1, 10 do
    print(string.rep("-", 10))
end

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local PlayerService = game:GetService("Players")
local TweenService = game:GetService("TweenService")

local localplayer = PlayerService.LocalPlayer

local relays = ReplicatedStorage.Modules.Jobs.Nurse.Relays
local claimPatient = relays.ClaimPatient
local takeSupply = relays.TakeSupply
local fulfillPatient = relays.FulfillPatient

local nurse = workspace.WorkEnvironments.Hospital_Nurse
local stations = nurse.Stations
local supplies = nurse.Supplies

local VirtualUserService = game:GetService("VirtualUser")
localplayer.Idled:Connect(function()
    VirtualUserService:CaptureController()
    VirtualUserService:ClickButton1(Vector2.new())
end)

local function p(samfing)
    if type(samfing) == "table" then
        for i, v in pairs(samfing) do
            print("(PrettyPrint)", tostring(i) .. ": " .. tostring(v))
        end
    end
end

local function ilementation_of_teleportik_hehe(whereto)
    -- not really great but oh well add proper checks later
    local character = localplayer.Character or localplayer.CharacterAdded:Wait()

    -- its also not great to just mention HumanoidRootPart like that but yeah add checks later
    local tween = TweenService:Create(character.HumanoidRootPart, TweenInfo.new(1), { CFrame = whereto })
    tween:Play()
    tween.Completed:Wait()

    --character:PivotTo(whereto)
end

local function findSupply(name)
    for _, category in pairs(supplies:GetChildren()) do
        if category.Name ~= "Laundry" then
            for _, supply in pairs(category:GetChildren()) do
                -- add safety checks here, were always assuming that the "Item" StringValue exists
                if supply.Item.Value == name then
                    return supply, supply
                end
            end
        else -- handling for laundry supply items, skip ilementation for now
            for _, supply in pairs(category:GetChildren()) do
                if supply.Name == name then
                    return supply:FindFirstChild(supply.Name) or (supply:FindFirstChild("MeshPart") and supply.MeshPart),
                        supply
                end
            end
        end
    end
end

-- temporarily get first child and just see what the remotefunction returns
local patientsServed = 0

getgenv().autofarmEnabled = true
while getgenv().autofarmEnabled do
    for _, station in pairs(stations:GetChildren()) do
        if not station:FindFirstChild("Patient") then continue end

        -- remember that we can only claim and process two patients at a time
        -- but because me no want hassle i process only 1 patient at a time

        -- claim patient
        local success = claimPatient:InvokeServer(station.Patient)
        if not success then
            print("idk some issue plis:", success)
            continue
        end

        local items = {}
        for _, item in pairs(station.Patient.StatusPart.ChartDisplay.Bubble.Frame:GetChildren()) do
            table.insert(items, item.Name)
        end

        -- retrieve all required items
        for i, v in pairs(items) do
            local supply, supplyForRemote = findSupply(v)

            --ilementation_of_teleportik_hehe(supply.CFrame)
            takeSupply:InvokeServer(supplyForRemote)

            task.wait(0.25)
        end

        -- fulfill patient
        --ilementation_of_teleportik_hehe(station.Patient.StatusPart.CFrame)
        fulfillPatient:InvokeServer(station.Patient)
        patientsServed = patientsServed + 1
        task.wait(0.1)

        print("Served " .. tostring(patientsServed) .. " patient so far.")
    end

    task.wait(1)
end

print("Served " .. tostring(patientsServed) .. " patients!")
