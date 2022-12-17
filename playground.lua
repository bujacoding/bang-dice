local key = require("lib/key")
local dump = require("lib/dump")
local heroes = require("lib/heroes")
local shuffle = require("lib/shuffle")
local find = require("lib/find")
local concatTable = require("lib.concatTable")
require("lib.stringSplit")


local input = "12345"

local split = string.split(input, "3")
print(dump(split))

local newdicePool = {}
input:gsub(".", function (c) table.insert(newdicePool, c) end)

print(dump(newdicePool))