local function concatTable(tbl1, tbl2)
  local result = { table.unpack(tbl1) }
  for i, v in pairs(tbl2) do
    table.insert(result, v)
  end
  return result
end

return concatTable
