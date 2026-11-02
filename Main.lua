-- Main.lua
local Players = game:GetService("Players")
local Player = Players.LocalPlayer

-- URL Disesuaikan dengan Repo Point-blox
local BASE_URL = "https://raw.githubusercontent.com/dprmz/Point-blox/main/Modules/"

local function LoadModule(moduleName)
    local url = BASE_URL .. moduleName .. ".lua?t=" .. tostring(tick())
    local success, code = pcall(function() return game:HttpGet(url) end)
    
    if not success or not code then
        warn("[Universal] Failed to fetch: " .. moduleName)
        return nil
    end

    local func, err = loadstring(code)
    if not func then
        warn("[Universal] Syntax Error in " .. moduleName .. ": " .. tostring(err))
        return nil
    end

    local runSuccess, moduleData = pcall(func)
    if not runSuccess then
        warn("[Universal] Execution Error in " .. moduleName .. ": " .. tostring(moduleData))
        return nil
    end

    return moduleData
end

print("[Universal] Loading Hub...")

local Config = LoadModule("Config")
local UI = LoadModule("UI")
local Aimbot = LoadModule("Aimbot")
local ESP = LoadModule("ESP")
local Weapon = LoadModule("Weapon")

if not Config or not UI then
    warn("[Universal] Critical Failure: Config or UI failed to load.")
    return
end

_G.UniversalConfig = Config

UI:CreateSidebar(Config)

if Aimbot then Aimbot:Init(Config, Player) end
if ESP then ESP:Init(Config, Player) end
if Weapon then Weapon:Init(Config, Player) end

print("[Universal] Hub Loaded 100%!")
