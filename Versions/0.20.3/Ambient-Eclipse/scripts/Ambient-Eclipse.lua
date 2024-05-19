local matrix = load_script('Ambient-Eclipse:scripts/a_findpath.lua')
local oper = load_script('Ambient-Eclipse:scripts/p_opera.lua')
local pID = 1
local defstate = 0


function on_world_open()

    oper.openhud(Cheat)

end
