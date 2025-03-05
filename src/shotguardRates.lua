-- ==================================================
-- Project      : Shotguard
-- Module       : Rates
-- Description  : Retrieves and stores the fire rate of players' weapons
-- License      : MIT License (See LICENSE file)
-- Repository   : https://github.com/Nico8340/shotguard
-- ==================================================

-- The table stores the calculated fire rate for each player and weapon.
-- The structure is: `shotguardRates[shotguardPed][shotguardWeapon] = {primary, secondary}`
-- - `primary` refers to the fire rate of the main animation (e.g. shooting).
-- - `secondary` refers to the fire rate of the secondary animation (e.g. crouching).
local shotguardRates = {}

-- This table defines whether a weapon is part of bullet synchronization.
-- The index represents a weapon type (e.g. pistol, shotgun), and the boolean value indicates
-- if the weapon is handled in Shotguard.
local shotguardSync = {
    [22] = true,  -- WEAPON_PISTOL
    [23] = true,  -- WEAPON_PISTOL_SILENCED
    [24] = true,  -- WEAPON_DESERT_EAGLE
    [25] = true,  -- WEAPON_SHOTGUN
    [26] = true,  -- WEAPON_SAWNOFF_SHOTGUN
    [27] = true,  -- WEAPON_SPAS12_SHOTGUN
    [28] = true,  -- WEAPON_MICRO_UZI
    [29] = true,  -- WEAPON_MP5
    [30] = true,  -- WEAPON_AK47
    [31] = true,  -- WEAPON_M4
    [32] = true,  -- WEAPON_TEC9
    [33] = true,  -- WEAPON_COUNTRYRIFLE
    [34] = true   -- WEAPON_SNIPERRIFLE
}

--- Gets the fire rate for a specified weapon and ped.
---
--- @param shotguardPed element The ped/player element whose fire rate is being retrieved.
--- @param shotguardWeapon number The weapon for which the fire rate is being fetched (e.g. 22).
---
--- @return number|nil shotguardRate The fire rate of the weapon. Returns `nil` if any input is invalid or the fire rate is not set for the weapon.
function shotguardGetRate(shotguardPed, shotguardWeapon)
    if not shotguardPed or not isElement(shotguardPed) then
        return
    end

    if not shotguardWeapon or type(shotguardWeapon) ~= "number" then
        return
    end

    if not shotguardRates[shotguardPed] then
        return
    end

    if not shotguardRates[shotguardPed][shotguardWeapon] then
        return
    end

    return isPedDucked(shotguardPed) and shotguardRates[shotguardPed][shotguardWeapon][2] or shotguardRates[shotguardPed][shotguardWeapon][1]
end

--- Updates the fire rate for a specified player and weapon based on their stats and skill level.
---
--- @param shotguardPed element The ped/player element for whom the fire rate is being updated.
--- @param shotguardWeapon number|nil The weapon for which the fire rate should be updated. If `nil`, the player's current weapon is used.
---
--- @return nil #This function does not return any value.
function shotguardUpdateRate(shotguardPed, shotguardWeapon)
    if not shotguardPed or not isElement(shotguardPed) then
        return
    end

    if not shotguardWeapon or type(shotguardWeapon) ~= "number" then
        shotguardWeapon = getPedWeapon(shotguardPed)
    end

    if not shotguardSync[shotguardWeapon] then
        return
    end

    local shotguardStat = shotguardGetStat(shotguardPed, shotguardWeapon)

    if not shotguardStat then
        return
    end

    local shotguardLevel = shotguardGetLevel(shotguardWeapon, shotguardStat)

    if not shotguardLevel then
        return
    end

    local shotguardStart = getWeaponProperty(shotguardWeapon, shotguardLevel, "anim_loop_start")
    local shotguardStartEx = getWeaponProperty(shotguardWeapon, shotguardLevel, "anim2_loop_start")

    local shotguardStop = getWeaponProperty(shotguardWeapon, shotguardLevel, "anim_loop_stop")
    local shotguardStopEx = getWeaponProperty(shotguardWeapon, shotguardLevel, "anim2_loop_stop")

    if not shotguardStart or not shotguardStartEx then
        return
    end

    if not shotguardStop or not shotguardStopEx then
        return
    end

    local shotguardRate = (shotguardStop - shotguardStart) * 900
    local shotguardRateEx = (shotguardStopEx - shotguardStartEx) * 900

    if not shotguardRates[shotguardPed] then
        shotguardRates[shotguardPed] = {}
    end

    if not shotguardRates[shotguardPed][shotguardWeapon] then
        shotguardRates[shotguardPed][shotguardWeapon] = {}
    end

    shotguardRates[shotguardPed][shotguardWeapon][1] = shotguardRate
    shotguardRates[shotguardPed][shotguardWeapon][2] = shotguardRateEx
end

addEventHandler("onPlayerResourceStart", root,
    function(shotguardResource)
        if shotguardResource == resource then
            shotguardUpdateRate(source)
        end
    end
)

addEventHandler("onPlayerWeaponSwitch", root,
    function(_, shotguardWeapon)
        shotguardUpdateRate(source, shotguardWeapon)
    end
)

addEventHandler("onPlayerQuit", root,
    function()
        if shotguardRates[source] then
            shotguardRates[source] = nil
        end
    end
)
