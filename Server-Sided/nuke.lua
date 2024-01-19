local sound = Instance.new("Sound", workspace)
sound.Name = "NEWSOUND"
sound.SoundId = "rbxassetid://1841791968"
sound.Looped = true
sound:Play()

require(4867426485):SD2("USERNAME")
-- we cannot use game.Players.LocalPlayer.Username instead of "USERNAME" because this needs to be executed from a server side console where LocalPlayer is unavailable due to it being a local client object.
