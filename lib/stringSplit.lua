-- "12345"
-- "a,b,c"

-- print(string.find("a,b,c", ",", 1)) -- 2, 2
-- print(string.find("a,b,c", ",b", 1)) -- 2, 3
-- print(string.find("a,b,c", "d", 1)) -- nil

function string:split(delimiter)
    local result = {}
    local from = 1
    local delim_from, delim_to = string.find(self, delimiter, from)
    while delim_from do
        table.insert(result, string.sub(self, from, delim_from - 1))
        from = delim_to + 1
        delim_from, delim_to = string.find(self, delimiter, from)
    end
    table.insert(result, string.sub(self, from))
    return result
end

return string.split
