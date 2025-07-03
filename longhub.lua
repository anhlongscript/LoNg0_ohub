local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local char = function() return LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait() end

-- GUI
local gui = Instance.new("ScreenGui", LocalPlayer:WaitForChild("PlayerGui"))
gui.Name = "LongHubV9"
gui.ResetOnSpawn = false

-- Toggle nút
local toggleBtn = Instance.new("TextButton", gui)
toggleBtn.Size = UDim2.new(0, 40, 0, 40)
toggleBtn.Position = UDim2.new(0, 10, 1, -50)
toggleBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
toggleBtn.Text = "🧠"
toggleBtn.TextColor3 = Color3.new(1, 1, 1)
toggleBtn.Font = Enum.Font.GothamBold
toggleBtn.TextSize = 20
Instance.new("UICorner", toggleBtn).CornerRadius = UDim.new(1, 0)

-- HUD chính
local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 300, 0, 240)
frame.Position = UDim2.new(0.5, -150, 0.5, -100)
frame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
frame.Active = true
frame.Draggable = true
frame.Visible = true
Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 10)

toggleBtn.MouseButton1Click:Connect(function()
	frame.Visible = not frame.Visible
end)

-- Tiêu đề
local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1, 0, 0, 30)
title.Text = "🌟 lOnG 0_o | PRO MAX V9"
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
		h.JumpPower = jumpOn and 140 or 50
	end
	return jumpOn, jumpOn and "✅ JUMP ON" or "🦘 SUPER JUMP"
end)

-- Speed
createButton("🏃‍♂️ SPEED BOOST", 90, function()
	speedOn = not speedOn
	return speedOn, speedOn and "✅ SPEED ON" or "🏃‍♂️ SPEED BOOST"
end)

-- Float Mode
createButton("☁️ FLOAT MODE", 140, function()
	floatOn = not floatOn
	return floatOn, floatOn and "✅ FLOAT ON" or "☁️ FLOAT MODE"
end)

-- Teleport to Shop
createButton("🛒 TELE TO SHOP", 190, function()
	local root = char():FindFirstChild("HumanoidRootPart")
	if root then
		root.CFrame = CFrame.new(-376.8, -6.2, 60.9)
	end
	return false, "✅ ĐÃ TELE"
end)

-- Speed/Float Handler
RunService.RenderStepped:Connect(function()
	local h = char():FindFirstChildOfClass("Humanoid")
	local root = char():FindFirstChild("HumanoidRootPart")
	if h then
		h.WalkSpeed = speedOn and 100 or 16
	end
	if root and floatOn then
		root.Velocity = Vector3.new(0, 10, 0)
	end
end)

-- ESP
createButton("🔍 ESP ĐEN VIỀN XANH", 240, function()
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
						txt.TextColor3 = Color3.fromRGB(0, 255, 0)
						txt.TextStrokeTransparency = 0
						txt.TextStrokeColor3 = Color3.new(0, 0, 0)
						txt.Font = Enum.Font.GothamBlack
						txt.TextSize = 20
						txt.Text = p.Name
						txt.Parent = Billboard
						Billboard.Parent = head
						
						RunService.RenderStepped:Connect(function()
							if txt and txt.Parent and p.Character then
								local cooldown = nil
								for _, obj in pairs(p.Character:GetDescendants()) do
									if obj:IsA("NumberValue") and obj.Name:lower():find("cooldown") then
										cooldown = math.floor(obj.Value)
										break
									end
								end
								txt.Text = p.Name .. (cooldown and (" (🔒"..cooldown.."s)") or "")
							end
						end)
					end
				end
			end

			if espOn then
				setupESP()
			else
				if p.Character then
					local head = p.Character:FindFirstChild("Head") or p.Character:FindFirstChildWhichIsA("BasePart")
					if head then
						local esp = head:FindFirstChild("ESPLabel")
						if esp then esp:Destroy() end
					end
				end
			end
		end
	end
	return espOn, espOn and "✅ ESP ON" or "🔍 ESP ĐEN VIỀN XANH"
end)

-- Auto ESP người mới
Players.PlayerAdded:Connect(function(p)
	p.CharacterAdded:Connect(function()
		wait(1)
		if espOn then
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
				txt.TextColor3 = Color3.fromRGB(0, 255, 0)
				txt.TextStrokeTransparency = 0
				txt.TextStrokeColor3 = Color3.new(0, 0, 0)
				txt.Font = Enum.Font.GothamBlack
				txt.TextSize = 20
				txt.Text = p.Name
				txt.Parent = Billboard
				Billboard.Parent = head
			end
		end
	end)
end)
