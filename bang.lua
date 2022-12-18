local key = require("lib/key")
local dump = require("lib/dump")
local heroes = require("lib/heroes")
local shuffle = require("lib/shuffle")
local find = require("lib/find")
local concatTable = require("lib.concatTable")
local keys = {right = ".", left = ","}
require("lib.stringSplit")

-- 인원수 정하기
io.write("몇명? ")
local playerCount = tonumber(io.read())
io.write("\n")

io.write(playerCount, "인용 게임을 시작합니다.\n")

local players = {}
local maxArrowCount = 9
local arrowCount = maxArrowCount
local gameOver = false
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

  player.init = function(player)
    player.maxLife = player.hero.life
    if player.job == "보안관" then
      player.maxLife = player.maxLife + 2
    end
    player.life = player.maxLife
    player.arrowCount = 0
  end

end

for i, player in pairs(players) do
  player:init()
end
-- 알아야 할 것
-- 보안관의 인덱스

local function emojiWithCount(emoji, count)
  local result = ""
  for i = 1, count do
    result = result .. emoji
  end
  return result
end

--turn
local turn = 1
local function UpdateArrowCount()
  local result = 0
  for i, player in pairs(players) do
    result = result + player.arrowCount
  end
  if maxArrowCount < result then
    return maxArrowCount
  end
  return result
end

local function UpdateGame(turn)
  os.execute("clear")
  arrowCount = maxArrowCount - UpdateArrowCount()
  print(UpdateArrowCount())
  print("현재 플레이어수:", playerCount)
  print("인디언 위험도:" .. math.floor((maxArrowCount - arrowCount) / maxArrowCount * 100) .. "%")
  print("플레이어들: ")
  io.write("\n")
  for i, player in pairs(players) do
    local myturn = ""
    if turn == i then
      myturn = "<<"
    end
    print(player.name ..
      "(" ..
      player.hero.name ..
      ")" ..
      ":" ..
      emojiWithCount("🧡", player.life) ..
      "[" .. player.life .. "]" .. emojiWithCount(" =->", player.arrowCount) .. "[" .. player.arrowCount .. "]", myturn)

  end
  io.write("\n")
  print(players[turn].name .. "님 차례입니다.")

end

local diceIcon = { dynamite = "🧨", beer = "🍺", gun = "︻╤──", arrow = "«-=", bullsEye1 = "🎯1",
  bullsEye2 = "🎯2", usedarrow = "«-=" }
local diceList = { "dynamite", "beer", "gun", "arrow", "bullsEye1", "bullsEye2" }

repeat

  
  local dicePool = {}
  UpdateGame(turn)

  local function dicePrint()
    print("[" ..
    diceIcon[dicePool[1]] ..
    "]" ..
    "[" ..
    diceIcon[dicePool[2]] ..
    "]" ..
    "[" .. diceIcon[dicePool[3]] .. "]" .. "[" .. diceIcon[dicePool[4]] .. "]" .. "[" .. diceIcon[dicePool[5]] .. "]")
  end

  local function DiceResultExecution()
    for i, dice in pairs(dicePool) do
      if dice == "bullsEye2" then
        
      elseif dice == "bullsEye1" then
        
      elseif dice == "gun" then

      elseif dice == "beer" then

      end
    end
  end

  print("주사위를 던져주세요")
  print("엔터:")
  io.read()
  for i = 1, 5 do
    table.insert(dicePool, diceList[math.random(1, 6)])
  end
  UpdateGame(turn)
  print("결과")
  io.write("\n")
  dicePrint()

  local diceturn = 1
  local dynamite = 0
  repeat
    
    io.write("\n")
    print("다시 던지실려면 숫자키를 입력." .. tostring(3 - diceturn) .. "번 남았습니다.")
    print("결과를 확정 하실려면 엔터.")

    local input = io.read()

    
    for i, dice in pairs(dicePool) do
      if dice == "arrow" then
        players[turn].arrowCount = players[turn].arrowCount + 1
        dicePool[i] = "usedarrow"
        UpdateGame(turn)
      elseif dice == "dynamite" then
        dynamite = dynamite + 1
      end
    end
    if dynamite > 2 then
      players[turn].life = players[turn].life - 1
      break
    end
    
    if arrowCount < 1 then
      
      for i, player in pairs(players) do
        player.life = player.life - player.arrowCount
        player.arrowCount = 0
      end
      UpdateGame(turn)
      dicePrint()
      print("인디언의 공격도가 100% 됐습니다 곳 인디언이 공격합니다.")
      print("모든 사람의 HP가 화살토큰의 개수 만큼 깍입니다.")
      io.read()
      
    end

    if input ~= "" then
      local newdicePool = {}
      input:gsub(".", function(c) table.insert(newdicePool, c) end)
      -- print(dump(newdicePool))
      -- io.read()
      for i = #newdicePool, 1, -1 do
        if dicePool[tonumber(newdicePool[i])] == "dynamite" then
          -- print(dicePool[tonumber(newdicePool[i])], tonumber(newdicePool[i]), dump(dicePool))
          -- io.read()
          table.remove(newdicePool, i)
        elseif tonumber(newdicePool[i]) > 5 then
          table.remove(newdicePool, i)
        end
      end
      -- print(dump(newdicePool))
      -- io.read()
      for i = 1, #newdicePool do
        dicePool[tonumber(newdicePool[i])] = diceList[math.random(1, 6)]
      end
    else
      break
    end


    UpdateGame(turn)
    dicePrint()
    
    diceturn = diceturn + 1
  until diceturn > 2
  if dynamite > 2 then
    UpdateGame(turn)
    dicePrint()
    print("붐!")
    print("오 이런 다이너 마이트가 3개가 됬군요 다이너마이트가 터졌습니다!")
    print("당신의 피를 1 깍았습니다.")
    
  else
  
      DiceResultExecution()
  end
  print(players[turn].name .. "님 차례는 끝났습니다.")

  io.read()
  turn = turn + 1
  if turn > playerCount then
    turn = 1
  end
until gameOver

io.write("끝났당")