local PlayerService = game:GetService("Players")

local SIZE_MULTIPLIER = 5

local function resize(character)
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    if not humanoid then return end

    humanoid.AutomaticScalingEnabled = true

    -- were assuming R15 here

    -- yet another bad implementation, assuming bodyscale exists
    if not humanoid:FindFirstChild("HeadScale") then return end

    local scales = {
        humanoid.HeadScale,
        humanoid.BodyDepthScale,
        humanoid.BodyWidthScale,
        humanoid.BodyHeightScale
    }

    for i, v in pairs(scales) do
        v.Value = v.Value * SIZE_MULTIPLIER
    end
end

PlayerService.PlayerAdded:Connect(function(player)
    player.CharactedAdded:Connect(resize) -- yeah
end)

-- do existing characters
for i, v in pairs(PlayerService:GetPlayers()) do
    if not v.Character then return end

    resize(v.Character)
end
