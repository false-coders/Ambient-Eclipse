

function tp(pID, xi, yi, zi)

    player.set_pos(pID, xi, yi, zi)

end

function setrotation(pID, x2, y2, z2)

    player.set_rot(pID, x2, y2, z2)

end

function setworldtime(time)

    world.set_day_time(time)

end

function setblock(x3, y3, z3, block, state)

    block.set(x3, y3, z3, block, state)

end

function getseed()

    local seed = world.get_seed()
    return seed
end

function getplayerpos(pID)

    x,y,z = player.get_pos(pID)
    return x, y, z
end

function getitem(inv_id, slot, item_id, count)

    inventory.set(inv_id, slot, item_id, count)
end

function openhud(hudname)

    hud.open_permanent('Ambient-Eclipse:' .. hudname)

end