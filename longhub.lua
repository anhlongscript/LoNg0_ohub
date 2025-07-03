--[[
LONGHUB V7 - VIP PRO MAX
Chức năng mặc định:
✅ GUI Toggle bằng ảnh mèo
✅ Speed Boost (di chuyển nhanh)
✅ Super Jump (nhảy cao)
✅ ESP (màu xanh, viền trắng, hiện cooldown)
✅ Teleport to Shop
✅ Float (lơ lửng)
--]]

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer

local function char() return LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait() end

-- GUI
local gui = Instance.new("ScreenGui", LocalPlayer:WaitForChild("PlayerGui"))
gui.Name = "LongHubV7"
gui.ResetOnSpawn = false

-- Toggle GUI bằng ảnh mèo
local toggleBtn = Instance.new("ImageButton", gui)
toggleBtn.Size = UDim2.new(0, 60, 0, 60)
toggleBtn.Position = UDim2.new(0, 10, 1, -70)
toggleBtn.BackgroundTransparency = 1
toggleBtn.Image = "rbxassetid://15832995734" -- mèo cầm dao

-- HUD chính
local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 320, 0, 260)
frame.Position = UDim2.new(0.5, -160, 0.5, -130)
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
title.Text = "🧠 lOnG 0_o | V7"
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

-- Jump
createButton("🦘 SUPER JUMP", 40, function()
    jumpOn = not jumpOn
    local h = char():FindFirstChildOfClass("Humanoid")
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

RunService.RenderStepped:Connect(function()
    local h = char():FindFirstChildOfClass("Humanoid")
    if h then
        h.WalkSpeed = speedOn and 80 or 16
    end
    if floatOn then
        char():FindFirstChild("HumanoidRootPart").Velocity = Vector3.new(0, 50, 0)
    end
end)

-- ESP
createButton("👁️ ESP ON/OFF", 140, function()
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
                        txt.TextColor3 = Color3.fromRGB(255, 255, 255)
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
                                txt.Text = p.Name .. (cooldown and (" ("..cooldown.."s)") or "")
                            end
                        end)

                        txt.Parent = Billboard
                        Billboard.Parent = head
                    end
                end
            end
            if espOn then
                setupESP()
            else
                if p.Character then
                    local head = p.Character:FindFirstChild("Head") or p.Character:FindFirstChildWhichIsA("BasePart")
                    local esp = head and head:FindFirstChild("ESPLabel")
                    if esp then esp:Destroy() end
                end
            end
        end
    end
    return espOn, espOn and "✅ ESP ON" or "👁️ ESP ON/OFF"
end)

-- Float
createButton("🪄 FLOAT MODE", 190, function()
    floatOn = not floatOn
    return floatOn, floatOn and "✅ FLOAT ON" or "🪄 FLOAT MODE"
end)

-- Teleport to Shop
createButton("🛍️ TELE TO SHOP", 240, function()
    local pos = Vector3.new(-376.8, -6.2, 60.9)
    local root = char():FindFirstChild("HumanoidRootPart")
    if root then
        root.CFrame = CFrame.new(pos)
    end
    return false, "🛍️ TELE TO SHOP"
end)
