local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

-- ⚙️ Cấu hình
local SPEED = 80
local JUMP = 160
local SHOP_POS = Vector3.new(-376.8, -6.2, 60.9)

-- 🧍 Lấy humanoid
local function getHumanoid()
	local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
	return char:FindFirstChildOfClass("Humanoid")
end

-- GUI
local gui = Instance.new("ScreenGui", game:GetService("CoreGui"))
gui.Name = "LongHub_GUI"

-- Toggle nút
local toggleBtn = Instance.new("TextButton", gui)
toggleBtn.Size = UDim2.new(0, 40, 0, 40)
toggleBtn.Position = UDim2.new(0, 10, 1, -50)
toggleBtn.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
toggleBtn.Text = "🧠"
toggleBtn.TextColor3 = Color3.new(1, 1, 1)
toggleBtn.Font = Enum.Font.GothamBold
toggleBtn.TextSize = 20
Instance.new("UICorner", toggleBtn).CornerRadius = UDim.new(1, 0)

-- Frame
local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 300, 0, 230)
frame.Position = UDim2.new(0.5, -150, 0.5, -100)
frame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
frame.Active = true
frame.Draggable = true
frame.Visible = true
Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 12)

toggleBtn.MouseButton1Click:Connect(function()
	frame.Visible = not frame.Visible
end)

-- Tiêu đề
local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1, 0, 0, 30)
title.Text = "🧠 lOnG 0_o | PRO MAX V7"
title.TextColor3 = Color3.new(1, 1, 1)
title.Font = Enum.Font.GothamBold
title.TextSize = 18
title.BackgroundTransparency = 1

-- Nút
local function createButton(text, y, callback)
	local btn = Instance.new("TextButton", frame)
	btn.Size = UDim2.new(0.85, 0, 0, 40)
	btn.Position = UDim2.new(0.075, 0, 0, y)
	btn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
	btn.Text = text
	btn.TextColor3 = Color3.new(1, 1, 1)
	btn.Font = Enum.Font.GothamBold
	btn.TextSize = 15
	Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 8)
	btn.MouseButton1Click:Connect(function()
		local active, label = callback()
		btn.Text = label
		btn.BackgroundColor3 = active and Color3.fromRGB(40, 200, 80) or Color3.fromRGB(60, 60, 60)
	end)
end

-- 🦘 Jump
local jumpOn = false
createButton("🦘 SUPER JUMP", 0.15, function()
	jumpOn = not jumpOn
	local h = getHumanoid()
	if h then
		h.UseJumpPower = true
		h.JumpPower = jumpOn and JUMP or 50
	end
	return jumpOn, jumpOn and "✅ JUMP ON" or "🦘 SUPER JUMP"
end)

-- 🏃 Speed
local speedOn = false
createButton("🏃 SPEED BOOST", 0.35, function()
	speedOn = not speedOn
	return speedOn, speedOn and "✅ SPEED ON" or "🏃 SPEED BOOST"
end)

RunService.Stepped:Connect(function()
	local h = getHumanoid()
	if h then
		h.WalkSpeed = speedOn and SPEED or 16
	end
end)

-- 🔍 ESP
local espOn = false
function applyESP()
	for _, p in pairs(Players:GetPlayers()) do
		if p ~= LocalPlayer and p.Character then
			local head = p.Character:FindFirstChild("Head")
			if head and not head:FindFirstChild("ESP_Label") then
				local bill = Instance.new("BillboardGui")
				bill.Name = "ESP_Label"
				bill.Size = UDim2.new(0, 200, 0, 50)
				bill.Adornee = head
				bill.AlwaysOnTop = true

				local txt = Instance.new("TextLabel", bill)
				txt.Size = UDim2.new(1, 0, 1, 0)
				txt.BackgroundTransparency = 1
				txt.Text = p.Name
				txt.TextColor3 = Color3.fromRGB(0, 0, 0)
				txt.TextStrokeTransparency = 0
				txt.TextStrokeColor3 = Color3.new(1, 1, 1)
				txt.Font = Enum.Font.GothamBold
				txt.TextSize = 20
				txt.Parent = bill

				bill.Parent = head
			end
		end
	end
end

function clearESP()
	for _, p in pairs(Players:GetPlayers()) do
		if p.Character then
			local head = p.Character:FindFirstChild("Head")
			if head and head:FindFirstChild("ESP_Label") then
				head:FindFirstChild("ESP_Label"):Destroy()
			end
		end
	end
end

createButton("🔍 TOGGLE ESP", 0.55, function()
	espOn = not espOn
	if espOn then applyESP() else clearESP() end
	return espOn, espOn and "✅ ESP ON" or "🔍 TOGGLE ESP"
end)

Players.PlayerAdded:Connect(function(p)
	p.CharacterAdded:Connect(function()
		wait(1)
		if espOn then applyESP() end
	end)
end)

-- 📍 TELE TO SHOP
local shopBtn = Instance.new("TextButton", frame)
shopBtn.Size = UDim2.new(0.85, 0, 0, 40)
shopBtn.Position = UDim2.new(0.075, 0, 0.75, 0)
shopBtn.BackgroundColor3 = Color3.fromRGB(200, 80, 80)
shopBtn.Text = "🛒 TELEPORT TO SHOP"
shopBtn.TextColor3 = Color3.new(1, 1, 1)
shopBtn.Font = Enum.Font.GothamBold
shopBtn.TextSize = 15
Instance.new("UICorner", shopBtn).CornerRadius = UDim.new(0, 8)

shopBtn.MouseButton1Click:Connect(function()
	local char = LocalPlayer.Character
	if char and char:FindFirstChild("HumanoidRootPart") then
		char.HumanoidRootPart.CFrame = CFrame.new(SHOP_POS)
		wait(5) -- Đứng 5 giây tránh bị rollback ngay
	end
end)
