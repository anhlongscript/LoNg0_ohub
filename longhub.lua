-- Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

-- Character shortcut
local char = function()
    return LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
end

-- GUI setup
local gui = Instance.new("ScreenGui")
guim = gui
if syn then syn.protect_gui(gui) end


-- Add to PlayerGui
local pg = LocalPlayer:WaitForChild("PlayerGui")
gui.Name = "LongHubCat"
gui.ResetOnSpawn = false
gui.Parent = pg

-- Toggle button with image
local toggleBtn = Instance.new("ImageButton")
toggleBtn.Size = UDim2.new(0, 60, 0, 60)
toggleBtn.Position = UDim2.new(0, 10, 1, -70)
toggleBtn.BackgroundTransparency = 1
toggleBtn.Image = "rbxassetid://18798722039" -- ID của ảnh mèo cầm dao
toggleBtn.Parent = gui

-- Main frame
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 320, 0, 300)
frame.Position = UDim2.new(0.5, -160, 0.5, -150)
frame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
frame.Visible = false
frame.Active = true
frame.Draggable = true
frame.Parent = gui
Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 10)

-- Title
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 30)
title.Text = "😼 lOnG 0_o "
title.TextColor3 = Color3.new(1, 1, 1)
title.Font = Enum.Font.GothamBold
title.TextSize = 18
title.BackgroundTransparency = 1
title.Parent = frame

-- Toggle GUI visibility
toggleBtn.MouseButton1Click:Connect(function()
    frame.Visible = not frame.Visible
end)

-- Helpers
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

-- Flags
local speedOn, jumpOn, espOn = false, false, false

-- Speed
createButton("🏃‍♂️ SPEED BOOST", 40, function()
    speedOn = not speedOn
    return speedOn, speedOn and "✅ SPEED ON" or "🏃‍♂️ SPEED BOOST"
end)

RunService.RenderStepped:Connect(function()
    local h = char():FindFirstChildOfClass("Humanoid")
    if h then
        if speedOn then
            h.WalkSpeed = 100
        else
            h.WalkSpeed = 16
        end
    end
end)

-- Super Jump
createButton("🦘 SUPER JUMP", 90, function()
    jumpOn = not jumpOn
    local h = char():FindFirstChildOfClass("Humanoid")
    if h then
        h.UseJumpPower = true
        h.JumpPower = jumpOn and 140 or 50
    end
    return jumpOn, jumpOn and "✅ JUMP ON" or "🦘 SUPER JUMP"
end)

-- ESP
createButton("👀 ESP XANH TO", 140, function()
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

                        Billboard.Parent = head
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

    return espOn, espOn and "✅ ESP ON" or "👀 ESP XANH TO"
end)

-- Auto ESP for new players
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

                Billboard.Parent = head
            end
        end
    end)
end)

print("😼 Cat GUI loaded!")
