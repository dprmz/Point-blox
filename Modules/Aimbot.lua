-- Aimbot.lua
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")

local Aimbot = {}

function Aimbot:Init(Config, Player)
    local Camera = workspace.CurrentCamera

    -- Drawing FOV Circle
    local fovCircle = Drawing.new("Circle")
    fovCircle.Thickness = 1.5
    fovCircle.NumSides = 36
    fovCircle.Filled = false
    fovCircle.Transparency = 0.8

    local function isAiming()
        if UserInputService.TouchEnabled then
            return _G.MobileAimHolding == true
        else
            return UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton2)
        end
    end

    local function getTarget()
        local nearestTarget = nil
        local shortestDist = Config.FOVRadius or 120
        local mousePos = UserInputService:GetMouseLocation()

        for _, plr in ipairs(Players:GetPlayers()) do
            if plr ~= Player and plr.Character and plr.Character:FindFirstChild("Humanoid") and plr.Character.Humanoid.Health > 0 then
                -- Check Team Filter
                if not Config.ShowTeam and plr.Team and Player.Team and plr.Team == Player.Team then
                    continue
                end

                local targetPart = plr.Character:FindFirstChild(Config.AimPart or "Head")
                if targetPart then
                    local screenPos, onScreen = Camera:WorldToViewportPoint(targetPart.Position)
                    if onScreen then
                        local dist = (Vector2.new(screenPos.X, screenPos.Y) - mousePos).Magnitude
                        if dist < shortestDist then
                            shortestDist = dist
                            nearestTarget = targetPart
                        end
                    end
                end
            end
        end
        return nearestTarget
    end

    RunService.RenderStepped:Connect(function()
        -- FOV Circle Sync
        local mousePos = UserInputService:GetMouseLocation()
        fovCircle.Position = mousePos
        fovCircle.Radius = Config.FOVRadius or 120
        fovCircle.Color = Config.FOVColor or Color3.fromRGB(255, 55, 65)
        fovCircle.Visible = Config.AimbotEnabled and Config.ShowFOV

        -- Smooth Aimbot Execution
        if Config.AimbotEnabled and isAiming() then
            local target = getTarget()
            if target then
                local currentCF = Camera.CFrame
                local targetCF = CFrame.new(currentCF.Position, target.Position)
                local smoothness = math.clamp(Config.Smoothness or 0.15, 0.01, 1)
                
                Camera.CFrame = currentCF:Lerp(targetCF, smoothness)
            end
        end
    end)

    print("[Aimbot] Initialized successfully.")
end

return Aimbot
