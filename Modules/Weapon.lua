-- Weapon.lua
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")

local Weapon = {}

function Weapon:Init(Config, Player)
    local Camera = workspace.CurrentCamera
    local lastCamCF = Camera.CFrame

    RunService.RenderStepped:Connect(function()
        -- No Recoil Camera Stabilization
        if Config.NoRecoil then
            local currentCF = Camera.CFrame
            -- Restrict upward pitch bounce
            if currentCF.LookVector.Y > lastCamCF.LookVector.Y then
                Camera.CFrame = CFrame.new(currentCF.Position, currentCF.Position + Vector3.new(currentCF.LookVector.X, lastCamCF.LookVector.Y, currentCF.LookVector.Z))
            end
        end
        lastCamCF = Camera.CFrame
    end)

    -- Point Blox / Raycast Spread Modification
    local oldNamecall
    oldNamecall = hookmetamethod(game, "__namecall", function(self, ...)
        local method = getnamecallmethod()
        local args = {...}

        if Config.NoSpread and (method == "FireServer" or method == "InvokeServer") then
            -- Bypassing spread angles inside remote tables
            for i, arg in ipairs(args) do
                if type(arg) == "table" then
                    if rawget(arg, "Spread") then rawset(arg, "Spread", 0) end
                    if rawget(arg, "Recoil") then rawset(arg, "Recoil", 0) end
                elseif type(arg) == "Vector3" and method == "FireServer" then
                    -- Straight Vector Direct Target Raycast
                    args[i] = Camera.CFrame.LookVector * 1000
                end
            end
        end
        return oldNamecall(self, unpack(args))
    end)

    print("[Weapon Mod] Initialized successfully.")
end

return Weapon
