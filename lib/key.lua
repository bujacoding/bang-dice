-- https://forum.cockos.com/archive/index.php/t-215860.html
local key = {}
function key.getch()
	os.execute("stty cbreak </dev/tty >/dev/tty 2>&1")
	local result = io.read(1)
	os.execute("stty -cbreak </dev/tty >/dev/tty 2>&1")
	return result
end


return key