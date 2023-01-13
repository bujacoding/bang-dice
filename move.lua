local key = nil
local w, h = 168, 40
local display = {}
local objects = {}
local getkey = require("lib.key")


local function creatBox(Size, Position, text, name)
    table.insert(objects, {Size = Size, Position = Position, text = text, name = name})
end





local index = 1
local function update()
    
    --프린트 높이만큼 나눠서하기
    
    for i=0, h-1 do
        local result = ""
        for k=1, w do
            result = result .. display[i*w+k]
        end
        io.write(result.."\n")
    end
end

local fps = 60


local waitTimes = {}
local function main()
    table.insert(waitTimes, {func = function()
        display = {}
        for i=1, w * h do
            table.insert(display, " ")
        end

        index = index + 1
        table.remove(objects, 1)
        creatBox({w=10,h=5}, {x=index, y=0}, ":", "TestBox")
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
    end
    })

    waitTimes[1].func()
end


local beffor = os.clock() - 1/fps
while true do
    main()
    if os.clock() - beffor >= 1/fps then
        os.execute("clear")
        update()
        beffor = os.clock()
    end
end
