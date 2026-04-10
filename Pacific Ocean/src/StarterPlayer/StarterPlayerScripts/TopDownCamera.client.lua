local Players = game:GetService("Players") -- player manager
local RunService = game:GetService("RunService") -- runs code every frame


-- CAMERA CODE

-- LocalPlayer = the player using THIS device
-- Only exists in LocalScripts
local player = Players.LocalPlayer

-- CurrentCamera = the camera the player is looking through
local camera = workspace.CurrentCamera

-- Scriptable means Roblox will STOP controlling the camera
-- We take full control manually
camera.CameraType = Enum.CameraType.Scriptable

local HEIGHT = 25        -- How high above the player the camera is
local DISTANCE = 18      -- How far forward the camera is
local SMOOTHNESS = 0.15  -- How "floaty" the camera movement feels

-- RenderStepped fires EVERY frame
-- Perfect for camera code because it runs before rendering
RunService.RenderStepped:Connect(function()
	
-- these checks roblox loads characters asynchronically and the camera breaks
	-- Character may not exist yet (player still loading), player.character is used when its outside the character
	local char = player.Character
	if not char then return end

	-- HumanoidRootPart = the character's center point
	-- Almost everything in Roblox movement is based on this part
	local hrp = char:FindFirstChild("HumanoidRootPart")
	if not hrp then return end
	
	-- Camera position:
	-- Start at the player
	-- Move UP by HEIGHT
	-- Move FORWARD by DISTANCE
	local cameraPosition =
		hrp.Position
		+ Vector3.new(0, HEIGHT, DISTANCE)

	-- The point the camera looks at
	-- We want it to look at the player
	local lookAt = hrp.Position
	
	-- CFrame = Position + Rotation
	-- CFrame.new(position, lookAtPosition)
	local targetCFrame = CFrame.new(cameraPosition, lookAt)
	
	-- Lerp = Linear Interpolation
	-- Smoothly moves from current CFrame to target CFrame
	camera.CFrame = camera.CFrame:Lerp(targetCFrame, SMOOTHNESS)
end)
