local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

local function getChar()
	return LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
end

local function getHumanoid()
	return getChar():WaitForChild("Humanoid")
end

local SPEED_ON, JUMP_ON = false, false
local SPEED = 80
local JUMP = 140

-- GUI setup
local gui = Instance.new("ScreenGui", game.CoreGui)
gui.Name = "LoNg0_ohub"

local toggleBtn = Instance.new("TextButton", gui)
toggleBtn.Size = UDim2.new(0, 40, 0, 40)
toggleBtn.Position = UDim2.new(0, 10, 1, -50)
toggleBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
toggleBtn.Text = "🧠"
toggleBtn.TextColor3 = Color3.new(1, 1, 1)
toggleBtn.Font = Enum.Font.GothamBold
toggleBtn.TextSize = 20
Instance.new("UICorner", toggleBtn).CornerRadius = UDim.new(1, 0)

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 300, 0, 180)
frame.Position = UDim2.new(0.5, -150, 0.5, -90)
frame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
frame.Visible = true
frame.Draggable = true
frame.Active = true
Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 10)

toggleBtn.MouseButton1Click:Connect(function()
	frame.Visible = not frame.Visible
end)

local function createBtn(text, y, callback)
	local btn = Instance.new("TextButton", frame)
	btn.Size = UDim2.new(0.85, 0, 0, 40)
	btn.Position = UDim2.new(0.075, 0, 0, y)
	btn.BackgroundColor3 = Color3.fromRGB(70, 120, 220)
	btn.Text = text
	btn.TextColor3 = Color3.new(1, 1, 1)
	btn.Font = Enum.Font.GothamBold
	btn.TextSize = 16
	Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 8)

	btn.MouseButton1Click:Connect(function()
		local active, label = callback()
		btn.Text = label
		btn.BackgroundColor3 = active and Color3.fromRGB(40, 200, 80) or Color3.fromRGB(70, 120, 220)
	end)
end

-- Super Jump
createBtn("🦘 SUPER JUMP", 0.1, function()
	JUMP_ON = not JUMP_ON
	local h = getHumanoid()
	if h then
		h.UseJumpPower = true
		h.JumpPower = JUMP_ON and JUMP or 50
	end
	return JUMP_ON, JUMP_ON and "✅ JUMP ON" or "🦘 SUPER JUMP"
end)

-- Speed Hack
createBtn("🏃 SPEED BOOST", 0.35, function()
	SPEED_ON = not SPEED_ON
	return SPEED_ON, SPEED_ON and "✅ SPEED ON" or "🏃 SPEED BOOST"
end)

-- Luôn giữ tốc độ
RunService.Stepped:Connect(function()
	local h = getHumanoid()
	if SPEED_ON and h then
		h.WalkSpeed = SPEED
	elseif h then
		h.WalkSpeed = 16
	end
end)
