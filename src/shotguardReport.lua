-- ==================================================
-- Project      : Shotguard
-- Module       : Report
-- Description  : Handles reports, logs and sanctions
-- License      : MIT License (See LICENSE file)
-- Repository   : https://github.com/Nico8340/shotguard
-- ==================================================
---@diagnostic disable: cast-local-type
---@diagnostic disable: param-type-mismatch

--- Logs and bans cheaters who commit violations.
---
--- @param shotguardSource element The player to be banned.
--- @param shotguardWeapon number|nil The weapon used by the player. If not specified, it will be replaced with "Unknown".
--- @param shotguardDifference number|nil The difference between tolerated and player value. If not specified, it will be replaced with "Unknown".
---
--- @return nil #This function does not return any value.
function shotguardReport(shotguardSource, shotguardWeapon, shotguardDifference)
    if not shotguardSource or not isElement(shotguardSource) then
        return
    end

    if not shotguardWeapon or type(shotguardWeapon) ~= "number" then
        shotguardWeapon = "Unknown"
    end

    if shotguardWeapon ~= "Unknown" then
        shotguardWeapon = getWeaponNameFromID(shotguardWeapon)
    end

    if not shotguardDifference or type(shotguardDifference) ~= "number" then
        shotguardDifference = "Unknown"
    end

    if shotguardDifference ~= "Unknown" then
        shotguardDifference = math.floor(shotguardDifference)
    end

    local shotguardName = getPlayerName(shotguardSource)
    local shotguardIP = getPlayerIP(shotguardSource)
    local shotguardSerial = getPlayerSerial(shotguardSource)
    local shotguardCase = md5(shotguardSerial)

    shotguardCase = string.sub(shotguardCase, 1, 6)
    shotguardCase = string.upper(shotguardCase)
    shotguardCase = string.format("0x%s", shotguardCase)

    banPlayer(shotguardSource, false, false, true, "Shotguard", shotguardCase)

    local shotguardLog = string.format(
        [[
            [Shotguard]: A new case has been registered.
            [Shotguard]: All details can be found on the banlist or here:
                - Name: %s
                - IP: %s
                - Serial: %s

                - Case : %s
                - Weapon: %s
                - Difference: %d
        ]], shotguardName, shotguardIP, shotguardSerial, shotguardCase, shotguardWeapon, shotguardDifference
    )

    outputServerLog(shotguardLog)
end
