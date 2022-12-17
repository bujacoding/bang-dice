local key = nil
local w, h = 168, 10
local display = {}
local objects = {}
local getkey = require("lib.key")

local function waitForGraphic(sec)
    os.execute("sleep " .. tonumber(sec))
end
local function creatBox(Size, Position, text, name)
    table.insert(objects, {Size = Size, Position = Position, text = text, name = name})
end





local index = 1
local function update()
    display = {}
    for i=1, w * h do
        table.insert(display, "=")
    end
    index = index + 1
    table.remove(objects, 1)
    creatBox({w=10,h=40}, {x=index, y=0}, "0", "TestBox")
    if index > w then
        index = 1
    end
    
    for i, obj in pairs(objects) do
        for k=1, obj.Size.h do
            for v=1, obj.Size.w do
                display[k * w + obj.Position.y * w - (w - (obj.Position.x + v))] = obj.text
            end
        end
    end
    --프린트 높이만큼 나눠서하기
    local result = ""
    for i=1, w * h  do
        result = result .. display[i]
    end
    
    io.write(result.."\n")
end

local fps = 10


local main = coroutine.create(function ()
   
end)

coroutine.resume(main)
while true do
    os.execute("clear")
    update()
   
    waitForGraphic(1/fps)
end
