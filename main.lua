-- Fake Donate GUI by Prxgx Hub

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer

-- GUI setup
local screenGui = Instance.new("ScreenGui", LocalPlayer:WaitForChild("PlayerGui"))
screenGui.Name = "FakeDonateGui"

local frame = Instance.new("Frame", screenGui)
frame.Position = UDim2.new(0.3, 0, 0.3, 0)
frame.Size = UDim2.new(0, 300, 0, 220)
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
frame.BorderSizePixel = 0

-- Heading label
local heading = Instance.new("TextLabel", frame)
heading.Text = "Prxgx Hub"
heading.Size = UDim2.new(1, 0, 0, 30)
heading.BackgroundTransparency = 1
heading.TextColor3 = Color3.new(1, 1, 1)
heading.Font = Enum.Font.GothamBold
heading.TextSize = 24

local usernameBox = Instance.new("TextBox", frame)
usernameBox.PlaceholderText = "Username"
usernameBox.Size = UDim2.new(1, -20, 0, 40)
usernameBox.Position = UDim2.new(0, 10, 0, 40)
usernameBox.TextSize = 18
usernameBox.TextColor3 = Color3.new(1,1,1)
usernameBox.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
usernameBox.ClearTextOnFocus = false

local robuxBox = Instance.new("TextBox", frame)
robuxBox.PlaceholderText = "Robux Amount"
robuxBox.Size = UDim2.new(1, -20, 0, 40)
robuxBox.Position = UDim2.new(0, 10, 0, 90)
robuxBox.TextSize = 18
robuxBox.TextColor3 = Color3.new(1,1,1)
robuxBox.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
robuxBox.ClearTextOnFocus = false

local donateButton = Instance.new("TextButton", frame)
donateButton.Text = "Fake Donate"
donateButton.Size = UDim2.new(1, -20, 0, 40)
donateButton.Position = UDim2.new(0, 10, 0, 140)
donateButton.TextSize = 20
donateButton.TextColor3 = Color3.new(1,1,1)
donateButton.BackgroundColor3 = Color3.fromRGB(0, 170, 0)

-- Donation popup
local popup = Instance.new("TextLabel", screenGui)
popup.Size = UDim2.new(0, 400, 0, 50)
popup.Position = UDim2.new(0.5, -200, 0.05, 0)
popup.TextScaled = true
popup.TextColor3 = Color3.new(1, 1, 0)
popup.BackgroundTransparency = 1
popup.Visible = false

donateButton.MouseButton1Click:Connect(function()
	local username = usernameBox.Text
	local robux = tonumber(robuxBox.Text)

	if username ~= "" and robux then
		local formatted = tostring(robux):reverse():gsub("(%d%d%d)", "%1,"):reverse():gsub("^,", "")
		popup.Text = username .. " DONATED " .. formatted .. " ROBUX TO YOU!"
		popup.Visible = true
		popup.TextTransparency = 1
		TweenService:Create(popup, TweenInfo.new(0.5), {TextTransparency = 0}):Play()
		
		task.delay(4, function()
			TweenService:Create(popup, TweenInfo.new(0.5), {TextTransparency = 1}):Play()
		end)
	end
end)
