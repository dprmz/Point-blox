-- [[ ADI PROJECT - UNIVERSAL LOADER ]] --
local ProjectName = "UniversalH4x"

local folders = {ProjectName, ProjectName.."/Settings", ProjectName.."/Logs"}
for _, v in pairs(folders) do
    if not isfolder(v) then 
        makefolder(v) 
    end
end

-- URL Disesuaikan dengan Repo Point-blox
local MAIN_SCRIPT_URL = "https://raw.githubusercontent.com/dprmz/Point-blox/main/Main.lua"

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
