-- ==================================================
-- Project      : Shotguard
-- Module       : Stats
-- Description  : Helps retrieving players' skills and stats
-- License      : MIT License (See LICENSE file)
-- Repository   : https://github.com/Nico8340/shotguard
-- ==================================================

-- This table maps weapon types to their corresponding stat.
-- These stats are used to retrieve a player's skill for a specific weapon type.
local shotguardStats = {
    [22] = 69,  -- WEAPONTYPE_PISTOL_SKILL
    [23] = 70,  -- WEAPONTYPE_PISTOL_SILENCED_SKILL
    [24] = 71,  -- WEAPONTYPE_DESERT_EAGLE_SKILL
    [25] = 72,  -- WEAPONTYPE_SHOTGUN_SKILL
    [26] = 73,  -- WEAPONTYPE_SAWNOFF_SHOTGUN_SKILL
    [27] = 74,  -- WEAPONTYPE_SPAS12_SHOTGUN_SKILL
    [28] = 75,  -- WEAPONTYPE_MICRO_UZI_SKILL
    [29] = 76,  -- WEAPONTYPE_MP5_SKILL
    [30] = 77,  -- WEAPONTYPE_AK47_SKILL
    [31] = 78,  -- WEAPONTYPE_M4_SKILL
    [32] = 75,  -- WEAPONTYPE_MICRO_UZI_SKILL
    [33] = 79,  -- WEAPONTYPE_SNIPERRIFLE_SKILL
    [34] = 79   -- WEAPONTYPE_SNIPERRIFLE_SKILL
}

-- The table defines the stat threshold values for weapon proficiency levels.
-- These thresholds help determine if a player is "poor", "std" (Gangster), or "pro" (Hitman) with a specific weapon.
-- The value `999` is used as the threshold for the "pro" level (Hitman).
local shotguardLevels = {
    [22] = 40,  -- WEAPON_PISTOL
    [23] = 500, -- WEAPON_PISTOL_SILENCED
    [24] = 200, -- WEAPON_DESERT_EAGLE
    [25] = 200, -- WEAPON_SHOTGUN
    [26] = 200, -- WEAPON_SAWNOFF_SHOTGUN
    [27] = 200, -- WEAPON_SPAS12_SHOTGUN
    [28] = 50,  -- WEAPON_MICRO_UZI
    [29] = 250, -- WEAPON_MP5
    [30] = 200, -- WEAPON_AK47
    [31] = 200, -- WEAPON_M4
    [32] = 50,  -- WEAPON_TEC9
    [33] = 300, -- WEAPON_COUNTRYRIFLE
    [34] = 300  -- WEAPON_SNIPERRIFLE
}

--- Gets the ped's stat for a particular weapon.
---
--- @param shotguardPed element The ped/player element for whom the stat is to be retrieved.
--- @param shotguardWeapon number The weapon for which the stat is to be fetched (e.g. 22).
---
--- @return number|nil shotguardStat The stat value corresponding to the weapon. Returns `nil` if invalid parameters are provided.
function shotguardGetStat(shotguardPed, shotguardWeapon)
    if not shotguardPed or not isElement(shotguardPed) then
        return
    end

    if not shotguardWeapon or type(shotguardWeapon) ~= "number" then
        return
    end

    local shotguardStat = shotguardStats[shotguardWeapon]

    if not shotguardStat then
        return
    end

    return getPedStat(shotguardPed, shotguardStat)
end

--- Gets the proficiency level for a weapon based on the ped's stat value.
---
--- @param shotguardWeapon number The weapon for which the proficiency level is to be retrieved (e.g. 22).
--- @param shotguardStat number The value to compare against the predefined thresholds for the weapon.
---
--- @return string|nil shotguardLevel The proficiency level: `"poor"`, `"std"`, or `"pro"`. Returns `nil` if invalid parameters are provided.
function shotguardGetLevel(shotguardWeapon, shotguardStat)
    if not shotguardWeapon or type(shotguardWeapon) ~= "number" then
        return
    end

    if not shotguardStat or type(shotguardStat) ~= "number" then
        return
    end

    local shotguardLevel = shotguardLevels[shotguardWeapon]

    if not shotguardLevel then
        return
    end

    if shotguardStat < shotguardLevel then
        return "poor"
    elseif shotguardStat < 999 then
        return "std"
    else
        return "pro"
    end
end
