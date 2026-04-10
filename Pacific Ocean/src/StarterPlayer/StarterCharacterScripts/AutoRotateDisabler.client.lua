-- script.Parent = the character model cuz were inside the character this is not a player script
local char = script.Parent

-- Humanoid controls movement, animations, rotation
local humanoid = char:WaitForChild("Humanoid")

-- Roblox rotates the character automatically by default
-- We disable this so WE control rotation later
humanoid.AutoRotate = false
