local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

local function getChar()
	return LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
end

local function getHumanoid()
	return getChar():WaitForChild("Humanoid")
end

-- Tọa độ shop
local SHOP_POSITION = Vector3.new(-376.8, -6.2, 60.9)

-- GUI setup
local gui = Instance.new("ScreenGui", game.CoreGui)
gui.Name = "LoNg0_o|betabeta"

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
frame.Size = UDim2.new(0, 300, 0, 240)
frame.Position = UDim2.new(0.5, -150, 0.5, -120)
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

-- Jump
local JUMP_ON = false
createBtn("🦘 SUPER JUMP", 0.05, function()
	JUMP_ON = not JUMP_ON
	local h = getHumanoid()
	if h then
		h.UseJumpPower = true
		h.JumpPower = JUMP_ON and 140 or 50
	end
	return JUMP_ON, JUMP_ON and "✅ JUMP ON" or "🦘 SUPER JUMP"
end)

-- Speed
local SPEED_ON = false
createBtn("🏃 SPEED BOOST", 0.25, function()
	SPEED_ON = not SPEED_ON
	return SPEED_ON, SPEED_ON and "✅ SPEED ON" or "🏃 SPEED BOOST"
end)

RunService.Stepped:Connect(function()
	local h = getHumanoid()
	if SPEED_ON and h then
		h.WalkSpeed = 80
	elseif h then
		h.WalkSpeed = 16
	end
end)

-- ESP
local ESP_ON = false
createBtn("🔍 ESP TO + XANH", 0.45, function()
	ESP_ON = not ESP_ON

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

						txt.Parent = Billboard
						Billboard.Parent = head
					end
				end
			end

			if ESP_ON then
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

	return ESP_ON, ESP_ON and "✅ ESP ON" or "🔍 ESP TO + XANH"
end)

-- Auto ESP for new player
Players.PlayerAdded:Connect(function(p)
	p.CharacterAdded:Connect(function()
		wait(1)
		if ESP_ON then
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

				txt.Parent = Billboard
