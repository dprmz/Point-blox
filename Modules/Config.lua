-- Config.lua
return {
    -- Aimbot Settings
    AimbotEnabled = false,
    AimPart = "Head",          -- "Head" atau "HumanoidRootPart"
    Smoothness = 0.15,         -- Nilai semakin kecil semakin smooth (0.05 - 0.5)
    
    -- FOV Circle Settings
    ShowFOV = true,
    FOVRadius = 120,
    FOVColor = Color3.fromRGB(255, 55, 65),

    -- ESP Settings
    ESPEnabled = false,
    ShowTeam = false,          -- False = Hanya musuh
    ESPColor = Color3.fromRGB(255, 55, 65),

    -- Weapon Settings (Point Blox / FPS Games)
    NoRecoil = false,
    NoSpread = false
}

