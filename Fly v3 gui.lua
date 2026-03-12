-- FE Fly GUI Script
-- by tubles93

local player = game.Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()

local flying = false
local speed = 60

-- GUI
local gui = Instance.new("ScreenGui", game.CoreGui)
local frame = Instance.new("Frame", gui)
local button = Instance.new("TextButton", frame)

frame.Size = UDim2.new(0,200,0,100)
frame.Position = UDim2.new(0.4,0,0.3,0)
frame.BackgroundColor3 = Color3.fromRGB(25,25,25)
frame.Active = true
frame.Draggable = true

button.Size = UDim2.new(1,0,1,0)
button.Text = "FLY OFF"
button.BackgroundColor3 = Color3.fromRGB(40,40,40)
button.TextColor3 = Color3.new(1,1,1)

local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local BV
local BG
local control = {F=0,B=0,L=0,R=0}

button.MouseButton1Click:Connect(function()
    flying = not flying
    button.Text = flying and "FLY ON" or "FLY OFF"

    if flying then
        local hrp = char:WaitForChild("HumanoidRootPart")

        BV = Instance.new("BodyVelocity")
        BV.MaxForce = Vector3.new(9e9,9e9,9e9)
        BV.Parent = hrp

        BG = Instance.new("BodyGyro")
        BG.MaxTorque = Vector3.new(9e9,9e9,9e9)
        BG.P = 9e4
        BG.Parent = hrp

        RunService.RenderStepped:Connect(function()
            if flying then
                local cam = workspace.CurrentCamera
                BG.CFrame = cam.CFrame
                BV.Velocity =
                    (cam.CFrame.LookVector * (control.F + control.B) +
                    cam.CFrame.RightVector * (control.R + control.L)) * speed
            end
        end)
    else
        if BV then BV:Destroy() end
        if BG then BG:Destroy() end
    end
end)

-- WASD control
UIS.InputBegan:Connect(function(key)
    if key.KeyCode == Enum.KeyCode.W then control.F = 1 end
    if key.KeyCode == Enum.KeyCode.S then control.B = -1 end
    if key.KeyCode == Enum.KeyCode.A then control.L = -1 end
    if key.KeyCode == Enum.KeyCode.D then control.R = 1 end
end)

UIS.InputEnded:Connect(function(key)
    if key.KeyCode == Enum.KeyCode.W then control.F = 0 end
    if key.KeyCode == Enum.KeyCode.S then control.B = 0 end
    if key.KeyCode == Enum.KeyCode.A then control.L = 0 end
    if key.KeyCode == Enum.KeyCode.D then control.R = 0 end
end)
