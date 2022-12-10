local key = require("lib/key")
local dump = require("lib/dump")
local heroes = require("lib/heroes")

-- 인원수 정하기
io.write("몇명? ")
local playerCount = tonumber(io.read())
io.write("\n")

io.write(playerCount, "인용 게임을 시작합니다.\n")

local players = {}

-- 이름 정하기
for i = 1, playerCount do
  io.write(i, "번 이름은? ")
  local name = io.read()
  local player = { index = i, name = name }
  table.insert(players, player)
end

-- 참가자 목록 보여주기
io.write("\n")
for i, v in pairs(players) do
  io.write("player ", v.index, " ", v.name, "\n")
end
io.write("\n")

local jobs = { "보안관", "배신자", "무법자", "무법자", "부관", "무법자", "부관", "배신자" }
local jobsFor3 = { "부관", "배신자", "무법자" }


if playerCount == 3 then
  jobs = jobsFor3
end


-- jobs 준비
print("before ", dump(jobs))
while playerCount < #jobs do
  table.remove(jobs, #jobs)
  print("after ", dump(jobs))
end

local function shuffle(tbl)
  for i = #tbl, 2, -1 do
    local j = math.random(i)
    tbl[i], tbl[j] = tbl[j], tbl[i]
  end
  return tbl
end

jobs = shuffle(jobs)
heroes = shuffle(heroes)

-- 직업 정하기
io.write("직업을 결정합니다...\n")
for i, v in pairs(players) do
  io.write(v.name, " 님을 제외한 나머지는 눈을 감아 주세요.\n")
  io.write("준비가 되면 엔터를 눌러 주세요...")
  io.read()
  local job = jobs[i]
  io.write("당신의 직업은 [", job, "] 입니다.\n")
  io.write("확인이 끝났으면 엔터를 눌러 주세요...")
  io.read();

  os.execute("clear")
end


io.write("끝났당")

-- io.write("key 1Input: ")
-- -- local r = io.read(1)
-- local r = key.getch()

-- io.write('\n')
-- io.write("your input is ", r, "\n")
