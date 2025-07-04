-- Load Kinlei's Material UI
local Material = loadstring(game:HttpGet("https://raw.githubusercontent.com/Kinlei/MaterialLua/master/Module.lua"))()

-- Variables
local player = game.Players.LocalPlayer
local targetPlayerName = ""
local robuxAmount = 0

-- Create main screen GUI
local screenGui = Instance.new("ScreenGui", player.PlayerGui)
screenGui.Name = "ForceDonateUI"
screenGui.ResetOnSpawn = false

-- Create icon button (draggable)
local icon = Instance.new("ImageButton")
icon.Name = "OpenGUIIcon"
icon.Size = UDim2.new(0, 60, 0, 60)
icon.Position = UDim2.new(0, 20, 0.5, -30)
icon.BackgroundTransparency = 1
icon.Image = "rbxassetid://17316405375" -- You must upload this image to Roblox and use the uploaded asset ID
icon.Parent = screenGui
icon.Draggable = true

-- Create GUI window (starts hidden)
local UI = Material.Load({
    Title = "Prxgx Hub",
    Style = 3,
    SizeX = 300,
    SizeY = 250,
    Theme = "Dark"
})

local MainTab = UI.New({ Title = "Main" })
local guiFrame = UI.Base
guiFrame.Visible = false

-- X Button
local closeButton = Instance.new("TextButton")
closeButton.Text = "X"
closeButton.Size = UDim2.new(0, 30, 0, 30)
closeButton.Position = UDim2.new(1, -35, 0, 5)
closeButton.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
closeButton.TextColor3 = Color3.new(1,1,1)
closeButton.Parent = guiFrame

closeButton.MouseButton1Click:Connect(function()
    guiFrame.Visible = false
    targetPlayerName = ""
    robuxAmount = 0
end)

-- Open GUI on icon click
icon.MouseButton1Click:Connect(function()
    guiFrame.Visible = not guiFrame.Visible
end)

-- Input: Target Username
MainTab.TextField({
    Text = "Target Username",
    Placeholder = "Enter player's username",
    Callback = function(value)
        targetPlayerName = value
    end
})

-- Input: Robux Amount
MainTab.TextField({
    Text = "Robux Amount",
    Placeholder = "Enter Robux (e.g. 100)",
    Callback = function(value)
        local num = tonumber(value)
        if num then robuxAmount = num end
    end
})

-- Button: Force Donate
MainTab.Button({
    Text = "Force Donate Robux",
    Callback = function()
        local function formatNumber(n)
            local str = tostring(n)
            local k = str
            while true do
                k, str = str:gsub("^(-?%d+)(%d%d%d)", "%1,%2")
                if str == 0 then break end
            end
            return k
        end

        local donationText = targetPlayerName .. " DONATED " .. formatNumber(robuxAmount) .. " TO YOU!"

        -- Clone popup template if exists
        if player.PlayerGui:FindFirstChild("UITemplates") and player.PlayerGui.UITemplates:FindFirstChild("donationPopup") then
            local clone = player.PlayerGui.UITemplates.donationPopup:Clone()
            clone.Message.Text = donationText
            clone.Parent = player.PlayerGui:FindFirstChild("ScreenGui") or Instance.new("ScreenGui", player.PlayerGui)
            clone.Transparency = 1
            clone.UIScale.Scale = 0

            if player:FindFirstChild("leaderstats") and player.leaderstats:FindFirstChild("Raised") then
                player.leaderstats.Raised.Value += robuxAmount
            end

            local TweenService = game:GetService("TweenService")
            TweenService:Create(clone, TweenInfo.new(0.5), { Transparency = 0 }):Play()
            TweenService:Create(clone.UIScale, TweenInfo.new(0.3, Enum.EasingStyle.Back), { Scale = 1 }):Play()
            TweenService:Create(clone.Message, TweenInfo.new(1), {
                MaxVisibleGraphemes = #donationText
            }):Play()

            task.delay(4, function()
                TweenService:Create(clone, TweenInfo.new(0.3), { Transparency = 1 }):Play()
                TweenService:Create(clone.UIScale, TweenInfo.new(0.3), { Scale = 0 }):Play()
                task.delay(0.5, function()
                    clone:Destroy()
                end)
            end)
        end
    end
})
