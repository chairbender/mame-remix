-- memory mapping
-- Score 60B1 (3 bytes)
-- Lives 6040 (byte)
common = require 'remix.game.common'

local game = {}

local score = function()
    return common.bcd2dec(3, 0x60B2)
end

local lives = function()
    return common.memory():read_u8(0x6040)
end

--- Earn 500 points without dying.
game.jump5 = function()
    if (lives() < 3) then
        return common.MINIGAME_STATE.FAIL
    elseif (score() >= 500) then
        return common.MINIGAME_STATE.SUCCESS
    else
        return common.MINIGAME_STATE.INCOMPLETE
    end
end

return game