local key = require("lib/key")
local dump = require("lib/dump")
local heroes = require("lib/heroes")
local shuffle = require("lib/shuffle")
local find = require("lib/find")
local concatTable = require("lib.concatTable")

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

jobs = shuffle(jobs)
heroes = shuffle(heroes)

-- 직업 정하기
io.write("직업을 결정합니다...\n")
key.getch()


for i, v in pairs(players) do
  os.execute("clear")
  io.write(v.name, " 님을 제외한 나머지는 눈을 감아 주세요.\n")
  io.write("준비가 되면 엔터를 눌러 주세요...")
  io.read()
  local job = jobs[i]
  v.job = job
  io.write("당신의 직업은 [", job, "] 입니다.\n")
  io.write("확인이 끝났으면 엔터를 눌러 주세요...")
  io.read();

  os.execute("clear")
end

-- 보안관이 1번 이 되도록 플레이어 재배치
-- ex) [무, 보, 배, 무]
-- 보안관앞의 모든 플레이어들을 맨 뒤로 배치한다.

local startingJob = "보안관"
if playerCount == 3 then
  startingJob = "부관"
end

io.write(startingJob, "부터 시작합니다.\n")

local startingIndex = find(jobs, startingJob)

print("첫 시작 인덱스: ", startingIndex)

if startingIndex ~= 1 then
  local front = { table.unpack(players, 1, startingIndex - 1) }
  local back = { table.unpack(players, startingIndex, #players) }
  players = concatTable(back, front)
end

-- hero 정하기
shuffle(heroes)
for i, player in pairs(players) do 
  player.hero = heroes[i]
end
--플레이어 초기화 하기
for i, player in pairs(players) do
  -- player.func = {
  --   init = function (player)
  --     player.maxLife = player.hero.life
  --     if player.job == "보안관" then
  --       player.maxLife = player.maxLife + 2
  --     end
  --     player.life = player.maxLife
  --   end
  -- }

  player.init = function (player)
    player.maxLife = player.hero.life
    if player.job == "보안관" then
      player.maxLife = player.maxLife + 2
    end
    player.life = player.maxLife
  end

end

for i, player in pairs(players) do
  player:init()
end

print(dump(players))
-- 알아야 할 것
-- 보안관의 인덱스
--turn
repeat
  
until 

io.write("끝났당")

-- io.write("key 1Input: ")
-- -- local r = io.read(1)
-- local r = key.getch()

-- io.write('\n')
-- io.write("your input is ", r, "\n")
