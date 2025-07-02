local Material = loadstring(game:HttpGet("https://raw.githubusercontent.com/Kinlei/MaterialLua/master/Module.lua"))()

local UI = Material.Load({
    Title = "Force Robux Donate",
    Style = 3,
    SizeX = 300,
    SizeY = 250,
    Theme = "Dark"
})

local targetPlayerName = ""
local robuxAmount = 0

local MainTab = UI.New({
    Title = "Main"
})

MainTab.TextField({
    Text = "Target Username",
    Placeholder = "Enter player's username",
    Callback = function(value)
        if value ~= "" then
            targetPlayerName = value
        else
            UI.Banner("Please enter a valid username")
        end
    end,
    Menu = {
        Information = function()
            UI.Banner("Enter the username of the player you want to fake donate to")
        end
    }
})

MainTab.TextField({
    Text = "Robux Amount",
    Placeholder = "Enter Robux (e.g. 100)",
    Callback = function(value)
        local num = tonumber(value)
        if num then
            robuxAmount = num
        else
            UI.Banner("Please enter a valid number")
        end
    end,
    Menu = {
        Information = function()
            UI.Banner("Enter how much Robux to show in the donation popup")
        end
    }
})

MainTab.Button({
    Text = "Force Donate Robux",
    Callback = function()
        local function formatNumber(number)
            local formatted = tostring(number)
            while true do
                local formatted2 = formatted:gsub("^(-?%d+)(%d%d%d)", "%1,%2")
                if formatted2 == formatted then break end
                formatted = formatted2
            end
            return formatted
        end

        local Players = game:GetService("Players")
        local TweenService = game:GetService("TweenService")
        local localPlayer = Players.LocalPlayer

        if localPlayer.PlayerGui:FindFirstChild("UITemplates") and localPlayer.PlayerGui.UITemplates:FindFirstChild("donationPopup") then
            local donationText = targetPlayerName .. " DONATED " .. formatNumber(robuxAmount) .. " TO YOU!"

            local ScreenGui = localPlayer.PlayerGui:FindFirstChild("ScreenGui")
            if not ScreenGui then
                ScreenGui = Instance.new("ScreenGui")
                ScreenGui.Name = "ScreenGui"
                ScreenGui.Parent = localPlayer.PlayerGui

                local popups = Instance.new("Frame")
                popups.Name = "Popups"
                popups.BackgroundTransparency = 1
                popups.Size = UDim2.new(1, 0, 1, 0)
                popups.Parent = ScreenGui
            end

            local clone = localPlayer.PlayerGui.UITemplates.donationPopup:Clone()
            clone.Message.Text = donationText
            clone.Transparency = 1
            clone.UIScale.Scale = 0
            clone.Parent = ScreenGui.Popups

            if localPlayer:FindFirstChild("leaderstats") and localPlayer.leaderstats:FindFirstChild("Raised") then
                localPlayer.leaderstats.Raised.Value = localPlayer.leaderstats.Raised.Value + robuxAmount
            end

            TweenService:Create(clone, TweenInfo.new(0.5, Enum.EasingStyle.Quint), {
                Transparency = 0
            }):Play()

            local easeStyle = Enum.EasingStyle.Back or Enum.EasingStyle.Quint

            TweenService:Create(clone.UIScale, TweenInfo.new(0.3, easeStyle), {
                Scale = 1
            }):Play()

            TweenService:Create(clone.Message, TweenInfo.new(1, Enum.EasingStyle.Quint), {
                MaxVisibleGraphemes = #donationText
            }):Play()

            task.delay(4, function()
                TweenService:Create(clone, TweenInfo.new(0.25, Enum.EasingStyle.Quint), {
                    Transparency = 1
                }):Play()

                TweenService:Create(clone.UIScale, TweenInfo.new(0.5, easeStyle), {
                    Scale = 0
                }):Play()

                task.delay(0.5, function()
                    clone:Destroy()
                end)
            end)
        end
    end
})
