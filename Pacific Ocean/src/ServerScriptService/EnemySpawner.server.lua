local ServerStorage = game:GetService("ServerStorage")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local enemyTemplate = ServerStorage:WaitForChild("Enemy")

local SPAWN_RADIUS = 60
local SPAWN_INTERVAL = 1.5

local function spawnEnemy()
	local players = Players:GetPlayers()
	if #players == 0 then return end

	local player = players[1]
	local char = player.Character
	if not char then return end

	local hrp = char:FindFirstChild("HumanoidRootPart")
	if not hrp then return end

	-- Random angle around player
	local angle = math.random() * math.pi * 2
	local offset = Vector3.new(
		math.cos(angle),
		0,
		math.sin(angle)
	) * SPAWN_RADIUS

	local enemy = enemyTemplate:Clone()
	enemy.Parent = workspace
	enemy:SetPrimaryPartCFrame(
		CFrame.new(hrp.Position + offset)
	)
end

task.spawn(function()
	while true do
		spawnEnemy()
		task.wait(SPAWN_INTERVAL)
	end
end)

RunService.Heartbeat:Connect(function()
	for _, enemy in ipairs(workspace:GetChildren()) do
		if enemy.Name ~= "Enemy" then continue end

		local humanoid = enemy:FindFirstChild("Humanoid")
		local root = enemy:FindFirstChild("HumanoidRootPart")
		if not humanoid or not root then continue end

		local players = Players:GetPlayers()
		if #players == 0 then continue end

		local char = players[1].Character
		if not char then continue end

		local target = char:FindFirstChild("HumanoidRootPart")
		if not target then continue end

		humanoid:MoveTo(target.Position)
	end
end)
