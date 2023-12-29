--[[
    Revision Unknown
    Author iirzd
    Numelon Softworks

    Updated Thursday 29th December 2023 at 00:13 GMT
]]
--[[
    Latest update:
    - Rewritten the script fully to align with Numelon's Code Specification
    - Variable Names align with NC Spec
    - Function Definitions align with NC Spec
    - etc.
]]
local VirtualUserService = game:GetService("VirtualUser")
local PlayerService = game:GetService("Players")

PlayerService.LocalPlayer.Idled:Connect(function()
    VirtualUserService:CaptureController()
    VirtualUserService:ClickButton2(Vector2.new())
end)
