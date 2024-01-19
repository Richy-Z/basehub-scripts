-- the _G.explode function is intended to be used in the roblox console to explode a player whenever you want.
-- e.g.:
-- _G.explode(game.Player.iirzd, 100, 10)
_G.explode = function(player, power, volume)
    if not volume then volume = 10 end
    if not power then power = 10 end
    local explodesound = Instance.new("Sound", player.Character.HumanoidRootPart)
    explodesound.SoundId = "rbxassetid://2648563122"
    explodesound.Volume = volume

    explodesound:Play()
    local explosion = Instance.new("Explosion")
    explosion.BlastRadius = power
    explosion.ExplosionType = Enum.ExplosionType.Craters -- damages terrain
    explosion.Position = player.Character.HumanoidRootPart.Position
    explosion.Parent = workspace
end

local counter = 0
repeat
    wait()
    for i,v in pairs(game:GetDescendants()) do
        if v.ClassName == "Part" or v.ClassName == "MeshPart"  or v.ClassName == "Union" then
            wait(0.1)
            local explodesound = Instance.new("Sound", v)
            explodesound.SoundId = "rbxassetid://2648563122"
            explodesound.Volume = 10
    
            explodesound:Play()
            local explosion = Instance.new("Explosion")
            explosion.BlastRadius = 10
            explosion.ExplosionType = Enum.ExplosionType.Craters -- damages terrain
            explosion.Position = v.Position
            explosion.Parent = workspace
        end
    end
    counter = counter + 1
until counter >= 100

--[[
    for i,v in pairs(game.Players:GetChildren()) do
    v.Character.HumanoidRootPart.Anchored = false
    v.Character.HumanoidRootPart.CFrame = CFrame.new(Vector3.new(math.huge, math.huge, math.huge))
end
]]
