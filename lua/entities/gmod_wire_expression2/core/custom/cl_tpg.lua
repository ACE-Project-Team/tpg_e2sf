-- E2Helper descriptions for the functions in tpg.lua. Wire loads cl_ files in
-- core/custom on the client only.

local desc = E2Helper.Descriptions

desc["tpgTeamCount()"] = "Returns the number of players on your team. 0 if you are not on a team"
desc["tpgTeamName()"] = "Returns your team's name, or an empty string if you are not on a team"
desc["tpgTeammates()"] = "Returns an array of the players on your team, you included"
desc["tpgTeammateNames()"] = "Returns an array of the names of the players on your team, you included"

desc["tpgIsTeammate(e:)"] = "Returns 1 if the player is on your team, otherwise 0"
desc["tpgArmor(e:)"] = "Returns a teammate's armor name. Empty string for anyone not on your team"
desc["tpgPrimary(e:)"] = "Returns a teammate's primary weapon. Empty string for anyone not on your team"
desc["tpgSecondary(e:)"] = "Returns a teammate's secondary weapon. Empty string for anyone not on your team"
desc["tpgSpecial(e:)"] = "Returns a teammate's special item. Empty string for anyone not on your team"

desc["tpgSetBotSeat(e:n)"] = "Marks this vehicle's seat as a bot seat if n is not 0, or unmarks it if n is 0. Only your own vehicle, while you are on a team. Returns 1 if it worked, else 0"
desc["tpgSetBotExit(e:v)"] = "Sets where a bot gets out of this seat, as an offset from the seat, clamped to 250 units. Returns 1 if it worked, else 0"
desc["tpgIsBotSeat(e:)"] = "Returns 1 if this vehicle's seat is marked as a bot seat, otherwise 0"
desc["tpgBotInSeat(e:)"] = "Returns the bot riding in this seat, or nil if there is none"
