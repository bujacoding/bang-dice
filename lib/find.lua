local function find(tbl, item) 
  for i, v in pairs(tbl) do
    if v == item then
      return i
    end
  end
  return -1
end

return find