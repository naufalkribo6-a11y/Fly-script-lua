-- Mini FE Fly GUI
-- by tubles93

local player = game.Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local flying = false
local speed = 70

-- GUI
local gui = Instance.new("ScreenGui")
gui.Parent = game.CoreGui

local frame = Instance.new("Frame")
frame.Parent = gui
frame.Size = UDim2.new(0,180,0,120)
frame.Position = UDim2.new(0.4,0,0.35,0)
frame.BackgroundColor3 = Color3.fromRGB(35,35,35)

local flyButton = Instance.new("TextButton")
flyButton.Parent = frame
flyButton.Size = UDim2.new(0,150,0,35)
flyButton.Position = UDim2.new(0,15,0,10)
flyButton.Text = "FLY OFF"
flyButton.BackgroundColor3 = Color3.fromRGB(60,60,60)
flyButton.TextColor3 = Color3.new(1,1,1)

local speedText = Instance.new("TextLabel")
speedText.Parent = frame
speedText.Size = UDim2.new(0,150,0,20)
speedText.Position = UDim2.new(0,15,0,50)
speedText.Text = "Speed: "..speed
speedText.BackgroundTransparency = 1
speedText.TextColor3 = Color3.new(1,1,1)

local plus = Instance.new("TextButton")
plus.Parent = frame
plus.Size = UDim2.new(0,65,0,25)
plus.Position = UDim2.new(0,15,0,80)
plus.Text = "+"

local minus = Instance.new("TextButton")
minus.Parent = frame
minus.Size = UDim2.new(0,65,0,25)
minus.Position = UDim2.new(0,100,0,80)
minus.Text = "-"

-- Drag GUI
local dragging = false
local startPos
local startFrame

frame.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
		dragging = true
		startPos = input.Position
		startFrame = frame.Position
	end
end)

frame.InputEnded:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
		dragging = false
	end
end)

UIS.InputChanged:Connect(function(input)
	if dragging and (input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseMovement) then
		local delta = input.Position - startPos
		frame.Position = UDim2.new(
			startFrame.X.Scale,
			startFrame.X.Offset + delta.X,
			startFrame.Y.Scale,
			startFrame.Y.Offset + delta.Y
		)
	end
end)

-- Fly system
local bv
local bg

flyButton.MouseButton1Click:Connect(function()

	flying = not flying
	flyButton.Text = flying and "FLY ON" or "FLY OFF"

	local hrp = char:WaitForChild("HumanoidRootPart")

	if flying then

		bv = Instance.new("BodyVelocity")
		bv.MaxForce = Vector3.new(9e9,9e9,9e9)
		bv.Parent = hrp

		bg = Instance.new("BodyGyro")
		bg.MaxTorque = Vector3.new(9e9,9e9,9e9)
		bg.P = 100000
		bg.Parent = hrp

		RunService.RenderStepped:Connect(function()

			if flying then

				local cam = workspace.CurrentCamera
				bg.CFrame = cam.CFrame

				local move = char.Humanoid.MoveDirection
				bv.Velocity = (cam.CFrame.LookVector * move.Z + cam.CFrame.RightVector * move.X) * speed

			end

		end)

	else
		if bv then bv:Destroy() end
		if bg then bg:Destroy() end
	end
end)

-- Speed control
plus.MouseButton1Click:Connect(function()
	speed = speed + 10
	speedText.Text = "Speed: "..speed
end)

minus.MouseButton1Click:Connect(function()
	speed = math.max(10, speed - 10)
	speedText.Text = "Speed: "..speed
end)
