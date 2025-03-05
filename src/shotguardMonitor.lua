-- ==================================================
-- Project      : Shotguard
-- Module       : Monitor
-- Description  : Monitors all shots from players
-- License      : MIT License (See LICENSE file)
-- Repository   : https://github.com/Nico8340/shotguard
-- ==================================================

-- This table stores the timestamp of the last shot fired for each player and weapon.
-- The structure is: `shotguardShots[shotguardPed][shotguardWeapon] = value`
local shotguardShots = {}

-- This table stores the timestamps of violations for each player.
-- The structure is: `shotguardViolations[shotguardPed] = {a, b, ...}`
local shotguardViolations = {}

-- The variable defines the allowed tolerance (in milliseconds) for fire rate violations.
-- The time between consecutive shots is too short? (i.e. below the calculated fire rate minus tolerance) Then it's considered as a violation!
local shotguardTolerance = 250

-- The variable defines how many violations must be committed in a row for a report to be generated.
local shotguardCount = 5

-- This variable defines the time window (in milliseconds) within which violations must be committed for a report to be generated.
local shotguardWindow = 10000

addEventHandler("onPlayerWeaponFire", root,
    function(shotguardWeapon)
        if not shotguardShots[source] then
            shotguardShots[source] = {}
        end

        local shotguardTick = getTickCount()

        if shotguardShots[source][shotguardWeapon] then
            local shotguardRate = shotguardGetRate(source, shotguardWeapon)

            if not shotguardRate then
                return
            end

            local shotguardDifference = shotguardTick - shotguardShots[source][shotguardWeapon]

            if shotguardDifference < (shotguardRate - shotguardTolerance) then
                if not shotguardViolations[source] then
                    shotguardViolations[source] = {}
                end

                table.insert(shotguardViolations[source], shotguardTick)

                while #shotguardViolations[source] > 0 and (shotguardTick - shotguardViolations[source][1] > shotguardWindow) do
                    table.remove(shotguardViolations[source], 1)
                end

                if #shotguardViolations[source] >= shotguardCount then
                    shotguardReport(source, shotguardWeapon, shotguardDifference)
                    shotguardViolations[source] = {}
                end

                return
            end
        end

        shotguardShots[source][shotguardWeapon] = shotguardTick
    end
)

addEventHandler("onPlayerQuit", root,
    function()
        if shotguardShots[source] then
            shotguardShots[source] = nil
        end
        if shotguardViolations[source] then
            shotguardViolations[source] = nil
        end
    end
)
