--[[
    Revision Unknown
    Author iirzd

    Updated Thursday 29th December 2023 at 00:13 GMT
]]
local VirtualUserService = game:GetService("VirtualUser")
local PlayerService = game:GetService("Players")

PlayerService.LocalPlayer.Idled:Connect(function()
    VirtualUserService:CaptureController()
    VirtualUserService:ClickButton2(Vector2.new())
end)
