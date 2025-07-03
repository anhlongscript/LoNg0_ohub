--[🧠 lOnG 0_o | PRO MAX GUI FINAL FIX 🧠]--

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local char = function() return LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait() end

-- GUI
local gui = Instance.new("ScreenGui", LocalPlayer:WaitForChild("PlayerGui"))
gui.Name = "LongHubVFinal"
gui.ResetOnSpawn = false

-- Toggle bằng hình con mèo
local toggleBtn = Instance.new("ImageButton", gui)
toggleBtn.Size = UDim2.new(0, 50, 0, 50)
toggleBtn.Position = UDim2.new(0, 10, 1, -60)
toggleBtn.BackgroundTransparency = 1
toggleBtn.Image = "rbxassetid://16649844097" -- ID ảnh con mèo (hoặc đại ca đổi)

-- HUD chính
local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 350, 0, 280)
frame.Position = UDim2.new(0.5, -175, 0.5, -140)
frame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
frame.Active = true
frame.Draggable = true
frame.Visible = false
Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 10)

toggleBtn.MouseButton1Click:Connect(function()
	frame.Visible = not frame.Visible
end)

-- Tiêu đề
local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1, 0, 0, 30)
title.Text = "🐾 lOnG 0_o | PRO GUI VFinal"
title.TextColor3 = Color3.new(1, 1, 1)
title.Font = Enum.Font.GothamBold
title.TextSize = 18
title.BackgroundTransparency = 1

-- Trạng thái
local jumpOn, speedOn, espOn, floatOn = false, false, false, false

-- Tạo nút
local function createButton(text, yPos, callback)
	local btn = Instance.new("TextButton", frame)
	btn.Size = UDim2.new(0.85, 0, 0, 40)
	btn.Position = UDim2.new(0.075, 0, 0, yPos)
	btn.BackgroundColor3 = Color3.fromRGB(70, 120, 220)
	btn.Text = text
	btn.TextColor3 = Color3.new(1, 1, 1)
	btn.Font = Enum.Font.GothamBold
	btn.TextSize = 15
	Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 8)

	btn.MouseButton1Click:Connect(function()
		local active, label = callback()
		btn.Text = label
		btn.BackgroundColor3 = active and Color3.fromRGB(40, 200, 80) or Color3.fromRGB(70, 120, 220)
	end)
end

-- Super Jump
createButton("🦘 SUPER JUMP", 40, function()
	local h = char():FindFirstChildOfClass("Humanoid")
	jumpOn = not jumpOn
	if h then
		h.UseJumpPower = true
		h.JumpPower = jumpOn and 150 or 50
	end
	return jumpOn, jumpOn and "✅ JUMP ON" or "🦘 SUPER JUMP"
end)

-- Speed Boost
createButton("🏃 SPEED BOOST", 90, function()
	speedOn = not speedOn
	return speedOn, speedOn and "✅ SPEED ON" or "🏃 SPEED BOOST"
end)

RunService.RenderStepped:Connect(function()
	local h = char():FindFirstChildOfClass("Humanoid")
	if h then
		if speedOn then
			h.WalkSpeed = 50 -- fix: đặt tốc độ cao nhưng vẫn tự nhiên
		else
			h.WalkSpeed = 16
		end
	end
end)

-- ESP
createButton("👀 ESP BLACK", 140, function()
	espOn = not espOn
	for _, p in pairs(Players:GetPlayers()) do
		if p ~= LocalPlayer then
			local function setupESP()
				if p.Character then
					local head = p.Character:FindFirstChild("Head") or p.Character:FindFirstChildWhichIsA("BasePart")
					if head and not head:FindFirstChild("ESPLabel") then
						local Billboard = Instance.new("BillboardGui")
						Billboard.Name = "ESPLabel"
						Billboard.Size = UDim2.new(0, 200, 0, 60)
						Billboard.AlwaysOnTop = true
						Billboard.Adornee = head

						local txt = Instance.new("TextLabel", Billboard)
						txt.Size = UDim2.new(1, 0, 1, 0)
						txt.BackgroundTransparency = 1
						txt.TextColor3 = Color3.new(0, 0, 0)
						txt.TextStrokeColor3 = Color3.new(1, 1, 1)
						txt.TextStrokeTransparency = 0
						txt.Text = p.Name
						txt.Font = Enum.Font.GothamBlack
						txt.TextSize = 22

						txt.Parent = Billboard
						Billboard.Parent = head
					end
			end
		end
		if espOn then setupESP() else
			if p.Character then
				local head = p.Character:FindFirstChild("Head") or p.Character:FindFirstChildWhichIsA("BasePart")
				if head then
					local esp = head:FindFirstChild("ESPLabel")
					if esp then esp:Destroy() end
				end
			end
		end
	end
	return espOn, espOn and "✅ ESP ON" or "👀 ESP BLACK"
end)

-- Float Mode
createButton("🎈 FLOAT MODE", 190, function()
	floatOn = not floatOn
	return floatOn, floatOn and "✅ FLOAT ON" or "🎈 FLOAT MODE"
end)

RunService.Stepped:Connect(function(_, dt)
	if floatOn and char():FindFirstChild("HumanoidRootPart") then
		char():FindFirstChild("HumanoidRootPart").CFrame = char():FindFirstChild("HumanoidRootPart").CFrame + Vector3.new(0, dt * 30, 0)
	end
end)

-- Tele to Shop
createButton("🛒 TELE TO SHOP", 240, function()
	local pos = Vector3.new(-376.8, -6.2, 60.9)
	local root = char():FindFirstChild("HumanoidRootPart")
	if root then
		root.CFrame = CFrame.new(pos)
	end
	return false, "🛒 TELE TO SHOP"
end)
