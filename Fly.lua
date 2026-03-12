-- Ultra Smooth FE Fly
-- by tubles93

local player = game.Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local humanoid = char:WaitForChild("Humanoid")
local hrp = char:WaitForChild("HumanoidRootPart")

local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local flying = false
local speed = 80

-- GUI
local gui = Instance.new("ScreenGui", game.CoreGui)

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0,160,0,100)
frame.Position = UDim2.new(0.4,0,0.35,0)
frame.BackgroundColor3 = Color3.fromRGB(30,30,30)

local fly = Instance.new("TextButton", frame)
fly.Size = UDim2.new(0,130,0,30)
fly.Position = UDim2.new(0,15,0,10)
fly.Text = "FLY OFF"

local plus = Instance.new("TextButton", frame)
plus.Size = UDim2.new(0,60,0,25)
plus.Position = UDim2.new(0,15,0,60)
plus.Text = "+"

local minus = Instance.new("TextButton", frame)
minus.Size = UDim2.new(0,60,0,25)
minus.Position = UDim2.new(0,85,0,60)
minus.Text = "-"

-- Drag GUI
local dragging=false
local startPos
local startFrame

frame.InputBegan:Connect(function(input)
	if input.UserInputType==Enum.UserInputType.Touch or input.UserInputType==Enum.UserInputType.MouseButton1 then
		dragging=true
		startPos=input.Position
		startFrame=frame.Position
	end
end)

frame.InputEnded:Connect(function(input)
	if input.UserInputType==Enum.UserInputType.Touch or input.UserInputType==Enum.UserInputType.MouseButton1 then
		dragging=false
	end
end)

UIS.InputChanged:Connect(function(input)
	if dragging then
		local delta=input.Position-startPos
		frame.Position=UDim2.new(
			startFrame.X.Scale,
			startFrame.X.Offset+delta.X,
			startFrame.Y.Scale,
			startFrame.Y.Offset+delta.Y
		)
	end
end)

-- Fly system
local att
local alignPos
local alignOri

fly.MouseButton1Click:Connect(function()

	flying = not flying
	fly.Text = flying and "FLY ON" or "FLY OFF"

	if flying then

		humanoid:ChangeState(Enum.HumanoidStateType.Physics)

		att = Instance.new("Attachment", hrp)

		alignPos = Instance.new("AlignPosition")
		alignPos.Attachment0 = att
		alignPos.MaxForce = 100000
		alignPos.Responsiveness = 50
		alignPos.Parent = hrp

		alignOri = Instance.new("AlignOrientation")
		alignOri.Attachment0 = att
		alignOri.MaxTorque = 100000
		alignOri.Responsiveness = 50
		alignOri.Parent = hrp

		RunService.RenderStepped:Connect(function()

			if flying then

				local cam = workspace.CurrentCamera
				local move = humanoid.MoveDirection

				alignOri.CFrame = cam.CFrame
				alignPos.Position = hrp.Position + (cam.CFrame.LookVector * move.Z + cam.CFrame.RightVector * move.X) * (speed/10)

			end

		end)

	else

		if att then att:Destroy() end
		if alignPos then alignPos:Destroy() end
		if alignOri then alignOri:Destroy() end

		humanoid:ChangeState(Enum.HumanoidStateType.GettingUp)

	end
end)

plus.MouseButton1Click:Connect(function()
	speed = speed + 20
end)

minus.MouseButton1Click:Connect(function()
	speed = math.max(20, speed - 20)
end)
