local char = script.Parent
local humanoid = char:WaitForChild("Humanoid")

-- Prevent Roblox from controlling movement
humanoid:ChangeState(Enum.HumanoidStateType.Physics)
humanoid.WalkSpeed = 0
humanoid.JumpPower = 0

local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local root = char:WaitForChild("HumanoidRootPart")
local camera = workspace.CurrentCamera

local MOVE_SPEED = 20 -- studs per second (tweak later)
local moveInput = Vector3.zero

UserInputService.InputBegan:Connect(function(input, processed)
	if processed then return end -- UI ate the input

	if input.KeyCode == Enum.KeyCode.W then
		moveInput += Vector3.new(0, 0, 1)
	elseif input.KeyCode == Enum.KeyCode.S then
		moveInput += Vector3.new(0, 0, -1)
	elseif input.KeyCode == Enum.KeyCode.A then
		moveInput += Vector3.new(-1, 0, 0)
	elseif input.KeyCode == Enum.KeyCode.D then
		moveInput += Vector3.new(1, 0, 0)
	end
end)

UserInputService.InputEnded:Connect(function(input)
	if input.KeyCode == Enum.KeyCode.W then
		moveInput -= Vector3.new(0, 0, 1)
	elseif input.KeyCode == Enum.KeyCode.S then
		moveInput -= Vector3.new(0, 0, -1)
	elseif input.KeyCode == Enum.KeyCode.A then
		moveInput -= Vector3.new(-1, 0, 0)
	elseif input.KeyCode == Enum.KeyCode.D then
		moveInput -= Vector3.new(1, 0, 0)
	end
end)


RunService.RenderStepped:Connect(function(deltaTime)
	if moveInput.Magnitude == 0 then return end
	
	-- Get camera directions
	local camForward = camera.CFrame.LookVector
	local camRight = camera.CFrame.RightVector
	
	-- Flatten them (remove Y so we don’t fly)
	camForward = Vector3.new(camForward.X, 0, camForward.Z).Unit
	camRight = Vector3.new(camRight.X, 0, camRight.Z).Unit
	
	-- Combine input with camera direction
	local moveDir =
		camRight * moveInput.X +
		camForward * moveInput.Z
	
	-- Normalize so diagonals aren’t faster
	if moveDir.Magnitude > 0 then
		moveDir = moveDir.Unit
	end
	-- Apply movement
	root.CFrame += moveDir * MOVE_SPEED * deltaTime
	
	local lookDirection = moveDir
	if lookDirection.Magnitude > 0 then
		root.CFrame = CFrame.new(
			root.Position,
			root.Position + lookDirection
		)
	end
end)