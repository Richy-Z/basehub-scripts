local TweenService = game:GetService("TweenService")
local PlayerService = game:GetService("Players")
local VirtualUser = game:GetService("VirtualUser")

local LocalPlayer = PlayerService.LocalPlayer

local ScreenSize = game.Workspace.CurrentCamera.ViewportSize
local AbsoluteMiddle = Vector2.new(ScreenSize.X / 2, ScreenSize.Y / 2)

local function collectMoneyDrops()
    for i,v in pairs(workspace.Ignored.Drop:GetChildren()) do
        if v.ClassName == "Part" then
            local maxDistance = 35
            local distance = (LocalPlayer.Character.HumanoidRootPart.Position - v.Position).Magnitude

            if distance <= maxDistance then
                if v:FindFirstChildOfClass("ClickDetector") then
                    local click = v:FindFirstChildOfClass("ClickDetector")
                    fireclickdetector(click)
                    wait(0.75)
                end
            end
        end
    end
end

if not LocalPlayer.Character:FindFirstChild("Combat") then
    LocalPlayer.Backpack.Combat.Parent = LocalPlayer.Character
end

VirtualUser:CaptureController()

for i,v in pairs(game.workspace.Cashiers:GetChildren()) do
    local partRotation = v.Head.CFrame - v.Head.Position
    local offset = CFrame.new(0, 0, 2.5)
    local offsetPosition = v.Head.CFrame * offset

    local tp_tween = TweenService:Create(LocalPlayer.Character.HumanoidRootPart, TweenInfo.new(2), {CFrame = offsetPosition})
    tp_tween:Play()
    repeat wait() until tp_tween.PlaybackState == Enum.PlaybackState.Completed
    
    local before = os.time()
    for i = 1, 200 do
        VirtualUser:ClickButton1(AbsoluteMiddle)
        wait(0.01)
    end
    local after = os.time()
    print(after-before)
    collectMoneyDrops()
end
