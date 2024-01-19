local PlayerService = game:GetService("Players")
local LocalPlayer = PlayerService.LocalPlayer
local lclChar = LocalPlayer.Character

local mouse = LocalPlayer:GetMouse()

local prev_pos = lclChar.HumanoidRootPart.CFrame
local at_home = true
mouse.KeyDown:Connect(function(key)
    if key == "r" then
        if at_home then
            prev_pos = lclChar.HumanoidRootPart.CFrame
            lclChar.HumanoidRootPart.CFrame = CFrame.new(workspace.Delivery.PromptPart.Position + Vector3.new(0,3,0))
            at_home = false

            workspace.Delivery.PromptPart.ProximityPrompt.HoldDuration = 0
            fireproximityprompt(workspace.Delivery.PromptPart.ProximityPrompt)
        elseif at_home == false then
            lclChar.HumanoidRootPart.CFrame = prev_pos
            at_home = true
        end
    end
end)
