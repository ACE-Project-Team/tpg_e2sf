--[[
    The Proving Ground - Expression 2 functions

    Team-scoped intel: every function only ever returns data about the chip
    owner's OWN team. If you're on Green you get nothing about Red, and vice
    versa. Spectators/unassigned get empty results.

    Lives in an addon rather than the gamemode because Wire only scans
    core/custom on the Lua search path, which a gamemode's own lua/ folder
    is not. Being an addon also makes it load in plain sandbox; see the stub
    in lua/autorun/server for what it does there.
]]

E2Lib.RegisterExtension("tpg", true,
    "Team-scoped info for The Proving Ground (you only ever see your own team).")

-- ── Helpers ────────────────────────────────────────────────────────────────
local function ownerTeam(self)
    local ply = self.player
    return (IsValid(ply) and ply:IsPlayer()) and ply:Team() or 0
end

local function onTeam(t)
    return t == TEAM_GREEN or t == TEAM_RED
end

-- True only when `ent` is a player on the SAME team as the chip owner.
local function isTeammate(self, ent)
    if not (IsValid(ent) and ent:IsPlayer()) then return false end
    local t = ownerTeam(self)
    return onTeam(t) and ent:Team() == t
end

local function armorName(ply)
    local id = tonumber(ply:GetPData("TPG_Armor", 1)) or 1
    local a  = TPG.Armor and TPG.Armor[id]
    return a and a.name or "Unknown"
end

local function pdataStr(ply, key)
    return tostring(ply:GetPData("TPG_" .. key, "") or "")
end

-- ── Team-wide queries ───────────────────────────────────────────────────────
__e2setcost(5)

-- Number of players on your team.
e2function number tpgTeamCount()
    local t = ownerTeam(self)
    if not onTeam(t) then return 0 end
    return team.NumPlayers(t)
end

-- Your team's display name ("" if you aren't on a team).
e2function string tpgTeamName()
    local t = ownerTeam(self)
    if not onTeam(t) then return "" end
    return (TPG.GetTeamData(t) or {}).name or ""
end

-- Array of player entities on your team. Combine with :pos(), :name() etc.
e2function array tpgTeammates()
    local out = {}
    local t = ownerTeam(self)
    if not onTeam(t) then return out end
    for _, ply in ipairs(team.GetPlayers(t)) do
        out[#out + 1] = ply
    end
    return out
end

-- Array of the names of everyone on your team.
e2function array tpgTeammateNames()
    local out = {}
    local t = ownerTeam(self)
    if not onTeam(t) then return out end
    for _, ply in ipairs(team.GetPlayers(t)) do
        out[#out + 1] = ply:Nick()
    end
    return out
end

-- ── Per-player getters (teammates only) ─────────────────────────────────────
__e2setcost(3)

-- 1 if this player is on your team, else 0.
e2function number entity:tpgIsTeammate()
    return isTeammate(self, this) and 1 or 0
end

-- Equipment of a teammate. Empty string for non-teammates / enemies.
e2function string entity:tpgArmor()
    if not isTeammate(self, this) then return "" end
    return armorName(this)
end

e2function string entity:tpgPrimary()
    if not isTeammate(self, this) then return "" end
    return pdataStr(this, "Primary")
end

e2function string entity:tpgSecondary()
    if not isTeammate(self, this) then return "" end
    return pdataStr(this, "Secondary")
end

e2function string entity:tpgSpecial()
    if not isTeammate(self, this) then return "" end
    return pdataStr(this, "Special")
end

-- ── Bot seats ──────────────────────────────────────────────────────────────
-- Bots ride in marked seats through gamemode/bots/sv_vehicles.lua. These only
-- forward to it, so without the gamemode (plain sandbox) they do nothing.
local function botVehicles()
    return TPG and TPG.Bots and TPG.Bots.Vehicles
end

__e2setcost(5)

-- Marks this vehicle's seat as a bot seat (n ~= 0), or unmarks it (n == 0).
-- Only your own vehicle, and only while you are on a team. Returns 1 if it worked, else 0.
e2function number entity:tpgSetBotSeat(number n)
    local bv = botVehicles()
    if not bv then return 0 end
    return bv.SetSeat(self.player, this, n ~= 0) and 1 or 0
end

-- Sets where a bot gets out of this seat, as an offset from the seat.
-- Clamped to 250 units. Returns 1 if it worked, else 0.
e2function number entity:tpgSetBotExit(vector v)
    local bv = botVehicles()
    if not bv then return 0 end
    return bv.SetExit(self.player, this, Vector(v[1], v[2], v[3])) and 1 or 0
end

__e2setcost(3)

-- 1 if this vehicle's seat is marked as a bot seat, else 0.
e2function number entity:tpgIsBotSeat()
    if not IsValid(this) or this.TPG_BotSeat ~= true then return 0 end
    return 1
end

-- The bot riding in this seat, or nil if there is none.
e2function entity entity:tpgBotInSeat()
    if not IsValid(this) then return nil end
    local rider = this.TPG_Rider
    if IsValid(rider) then return rider end
    return nil
end
