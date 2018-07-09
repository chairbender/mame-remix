--- Various utility functions related to extracting info about game states from memory and checking things.
--- @module common
local common = {}

--- possible return values from a task callback
common.MINIGAME_STATE = {
    SUCCESS = 1, -- task completed successfully
    FAIL = -1, -- task failed
    INCOMPLETE = 0 -- task not yet finished (continue playing)
}

--- Retrieves a BCD value from memory.
--- @param addr_space sol.lua_engine.addr_space addr_space within which to retrieve the value
--- @param width Integer number of bytes the BCD value occupies
--- @param address hex address within addr space, indicating the address where the BCD value starts. Optional,
---         if missing, will assume maincpu program memory
--- @return integer the integer value represented by the BCD.
common.bcd2dec = function(width, address, addr_space)
    if (addr_space == nil) then
        addr_space = common.memory()
    end
    bytes = {}
    for byte_address = address, address + (width - 1) do
        byte = addr_space:read_u8(byte_address)
        bytes[#bytes + 1] = byte & 0x0F
        bytes[#bytes + 1] = (byte & 0xF0) >> 4
    end

    total = 0
    for index, value in ipairs(bytes) do
        total = total + (value * math.floor(10 ^ (index - 1)))
    end

    return total
end

---
-- @return the addr_space which most commonly contains the stuff we care about in mame remix - main cpu program memory
common.memory = function()
    return manager:machine().devices[":maincpu"].spaces["program"]
end

return common

