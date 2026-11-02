-- [[ ADI PROJECT - UNIVERSAL LOADER ]] --
local ProjectName = "UniversalH4x"

-- Buat folder lokal untuk menyimpan settings/logs
local folders = {ProjectName, ProjectName.."/Settings", ProjectName.."/Logs"}
for _, v in pairs(folders) do
    if not isfolder(v) then 
        makefolder(v) 
    end
end

-- URL Raw GitHub untuk Main.lua
local MAIN_SCRIPT_URL = "https://raw.githubusercontent.com/dprmz/Universal-Script/main/Main.lua"

print("[" .. ProjectName .. "] Initializing Loader...")

local success, err = pcall(function()
    local scriptUrl = MAIN_SCRIPT_URL .. "?t=" .. tick()
    loadstring(game:HttpGet(scriptUrl))()
end)

if success then
    print("[" .. ProjectName .. "] Main script loaded successfully!")
else
    warn("[" .. ProjectName .. "] Load error: " .. tostring(err))
end
