---
--- Main entry point (should be supplied to mame as the autoboot file)
---
common = require "remix.game.common"
local INPUT_FILE = "luainput.txt"
local OUTPUT_FILE = "luaoutput.txt"

print("autoboot starting")

--- see if the file exists
function file_exists(file)
    local f = io.open(file, "rb")
    if f then f:close() end
    return f ~= nil
end

--- get all lines from a file, returns an empty
-- list/table if the file does not exist
local function lines_from(file)
    if not file_exists(file) then return {} end
    local lines = {}
    for line in io.lines(file) do
        lines[#lines + 1] = line
    end
    return lines
end

-- determine which game and minigame we are supposed to be on by reading it from the file
local input_lines = lines_from(INPUT_FILE)

local game_name = input_lines[1]
local minigame = input_lines[2]

-- require in the game and retrieve the minigame callback
local game = require("remix\\game." .. game_name)
print(game)
minigame = game[minigame]
print(minigame)

local last_tick_time = -10

--- Invoked when the minigame is over. Logs the result and exits mame.
--- @param status common.MINIGAME_STATE indicating success / fail.
local function finish(status)
    file = io.open(OUTPUT_FILE, "w")
    if (status == common.MINIGAME_STATE.SUCCESS) then
        file:write("1")
    else
        file:write("-1")
    end
    file:close()
    manager:machine():exit()
end

--- Invoked on each frame of MAME. Checks if minigame is completed. If so, logs the result to OUTPUT_FILE and
--- exits mame.
--- @param minigame function function which should evaluate game state and return one of common.MINIGAME_STATE
local function tick()
    -- Sometimes tick is called by mame multiple times before the game state actually updates
    if emu.time() < last_tick_time + 1 then
        return
    end
    last_tick_time = emu.time()

    local status = minigame()
    print("minigame done ")

    if (status == common.MINIGAME_STATE.FAIL or status == common.MINIGAME_STATE.SUCCESS) then
        finish(status)
    end
end

emu.register_frame(tick)