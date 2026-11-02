-- ESP.lua
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")

local ESP = {}

function ESP:Init(Config, Player)
    local function applyESP()
        for _, plr in ipairs(Players:GetPlayers()) do
            if plr ~= Player and plr.Character then
                local char = plr.Character
                local highlight = char:FindFirstChild("ESP_Highlight")

                if Config.ESPEnabled then
                    local isEnemy = true
                    if not Config.ShowTeam and plr.Team and Player.Team and plr.Team == Player.Team then
                        isEnemy = false
                    end

                    if isEnemy then
                        if not highlight then
                            highlight = Instance.new("Highlight")
                            highlight.Name = "ESP_Highlight"
                            highlight.FillColor = Config.ESPColor or Color3.fromRGB(255, 55, 65)
                            highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
                            highlight.FillTransparency = 0.5
                            highlight.OutlineTransparency = 0.2
                            highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                            highlight.Parent = char
                        end
                    elseif highlight then
                        highlight:Destroy()
                    end
                elseif highlight then
                    highlight:Destroy()
                end
            end
        end
    end

    RunService.Heartbeat:Connect(function()
        applyESP()
    end)

    print("[ESP] Initialized successfully.")
end

return ESP
