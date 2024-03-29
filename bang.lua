local key = require("lib/key")
local dump = require("lib/dump")
local heroes = require("lib/heroes")
local shuffle = require("lib/shuffle")
local find = require("lib/find")
local concatTable = require("lib.concatTable")
local console = require("lib/console")
local keys = { right = ".", left = "," }
require("lib.stringSplit")

-- 인원수 정하기
io.write("몇명? ")
local playerCount = tonumber(io.read())
io.write("\n")

io.write(playerCount, "인용 게임을 시작합니다.\n")

local players = {}
local maxArrowCount = 9
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
  console.clear()
  io.write(v.name, " 님을 제외한 나머지는 눈을 감아 주세요.\n")
  io.write("준비가 되면 엔터를 눌러 주세요...")
  io.read()
  local job = jobs[i]
  v.job = job
  io.write("당신의 직업은 [", job, "] 입니다.\n")
  io.write("확인이 끝났으면 엔터를 눌러 주세요...")
  io.read();

  console.clear()
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
    player.displayName = player.name .. "(" .. player.hero.name .. ")"
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
local function getArrowCountRemaining()
  local consumed = 0
  for i, player in pairs(players) do
    consumed = consumed + player.arrowCount
  end

  local result = maxArrowCount - consumed

  if result < 0 then
    return 0
  end

  return result
end

local function renderPlayers(players, turn)

  for i, player in pairs(players) do

    local nameText = player.displayName
    if turn == i then
      nameText = " 🎲 " .. nameText .. " 🎲 "
    else
      nameText = "   " .. nameText
    end
    print(nameText)

    local lifeText = emojiWithCount("🧡", player.life) .. "[" .. player.life .. "]"
    local arrowText = emojiWithCount(" =->", player.arrowCount) .. "[" .. player.arrowCount .. "]"

    print(lifeText .. arrowText)
    print()

  end

  io.write("\n")
end

local function renderGameStatus(turn)

  console.clear()

  print("현재 플레이어수: " .. playerCount)
  print("인디언 위험도: " .. math.floor((maxArrowCount - getArrowCountRemaining()) / maxArrowCount * 100) .. "%")
  io.write("\n")

  renderPlayers(players, turn)

  -- print(players[turn].name .. "님 차례입니다.")

end

local Dice = {
  dynamite = {
    name = "dynamite",
    icon = "🧨",
  },
  beer = {
    name = "beer",
    icon = "🍺",
  },
  gun = {
    name = "gun",
    icon = "︻╤──"
  },
  arrow = {
    name = "arrow",
    icon = "«-="
  },
  bullsEye1 = {
    name = "bullsEye1",
    icon = "🎯1"
  },
  bullsEye2 = {
    name = "bullsEye2",
    icon = "🎯2"
  },
  usedArrow = {
    name = "usedArrow",
    icon = "«-="
  },
}
local diceTypes = { Dice.dynamite, Dice.beer, Dice.gun, Dice.arrow, Dice.bullsEye1, Dice.bullsEye2, Dice.usedArrow }

local function renderDices(dicePool)
  print(
    "[" .. dicePool[1].icon .. "]",
    "[" .. dicePool[2].icon .. "]",
    "[" .. dicePool[3].icon .. "]",
    "[" .. dicePool[4].icon .. "]",
    "[" .. dicePool[5].icon .. "]"
  )
  print("(1)", "(2)", "(3)", "(4)", "(5)")
end

local function getCountOfGuns(dicePool) 
  local result = 0
  
  for i, dice in pairs(dicePool) do
    if dice == Dice.gun then
      result = result + 1
    end
  end

  return result
end

local function applyDicesResult(dicePool, player)

  if 3 <= getCountOfGuns(dicePool) then
    print('전체 공격 개시')
    print('나를 제외한 모두가 피해를 입습니다.')
    io.read()
  end

  for i, dice in pairs(dicePool) do
    if dice == Dice.bullsEye2 then
      print('두방짜리 공격 개시')
      print('공격 대상 플레이어를 선택하세요.')
      io.read()

    elseif dice == Dice.bullsEye1 then
      print('1방짜리 공격 개시')
      print('공격 대상 플레이어를 선택하세요.')
      io.read()

    elseif dice == Dice.beer then
      print('꿀꺽 개시')
      print('HP 를 채울 플레이어를 선택하세요.', '('..player.name..')')
      io.read()

    end
  end

end

local function dynamiteCheck(dicePool)
  local dynamite = 0
  for i, dice in pairs(dicePool) do
    if dice.name == Dice.dynamite.name then
      dynamite = dynamite + 1
    end
  end

  return dynamite >= 3
end

local function updateArrow(dicePool)
  for i, dice in pairs(dicePool) do
    if dice.name == Dice.arrow.name then
      players[turn].arrowCount = players[turn].arrowCount + 1
      dicePool[i] = Dice.usedArrow
    end
  end

  if getArrowCountRemaining() <= 0 then
    for i, player in pairs(players) do
      player.life = player.life - player.arrowCount
      player.arrowCount = 0
    end
    renderGameStatus(turn)
    renderDices(dicePool)
    print("인디언의 공격도가 100% 됐습니다 곳 인디언이 공격합니다.")
    print("모든 사람의 HP가 화살토큰의 개수 만큼 깍입니다.")
    io.read()
  end
end

local function reThrowDicesfiltering(input, dicePool)
  local inputArray = {}
  input:gsub(".", function(s)
    table.insert(inputArray, tonumber(s))
  end)

  local result = {}
  for i, number in pairs(inputArray) do

    local isValid = (function()
      if number == nil then return false end
      if number < 1 then return false end
      if 5 < number then return false end
      if dicePool[number] == Dice.dynamite then return false end

      return true
    end)()

    if isValid then
      table.insert(result, number)
    end
  end

  return result
end

local function throwDicesForPlayer(player)
  local dicePool = {}

  local diceturn = 1
  local input = "12345"

  print(player.name.."님")
  print("주사위를 던지려면 엔터를 눌러 주세요.")
  io.read()


  while input ~= "" do
    -- dicePool 필터링
    local reThrowDices = reThrowDicesfiltering(input, dicePool)
    --던지기
    -- input:gsub(".", function(number) table.insert(reThrowDices, number) end)
    for i = 1, #reThrowDices do
      dicePool[tonumber(reThrowDices[i])] = diceTypes[math.random(6)]
    end

    -- 주사위 던진 결과 출력
    renderGameStatus(turn)
    print("결과")
    io.write("\n")
    renderDices(dicePool)

    -- 주사위결과 반영
    if dynamiteCheck(dicePool) == true then
      print("붐!")
      print("오 이런 다이너 마이트가 3개가 됬군요 다이너마이트가 터졌습니다!")
      print("당신의 피를 1 깍았습니다.")
      io.read()

      if 0 < player.life then
        updateArrow(dicePool)
      end

      return dicePool
    end

    updateArrow(dicePool)


    if 3 <= diceturn then
      return dicePool
    end
    -- 던질 주사위 선택
    io.write("\n")
    print("다시 던지실려면 숫자키를 입력." .. tostring(3 - diceturn) .. "번 남았습니다.")
    print("결과를 확정 하실려면 엔터.")
    input = io.read()

    diceturn = diceturn + 1
  end

  return dicePool
end

local function runMain()
  repeat

    local player = players[turn]

    -- 초반 안내
    renderGameStatus(turn)

    -- 주사위 던지기
    local dicePool = throwDicesForPlayer(player)

    print(player.name .. "님 주사위 던지기가 끝났습니다.")

    -- 주사위 결과 반영 (맥주, 공격, 기관총)
    print("던진 결과를 반영하겠습니다.")
    io.read()
    applyDicesResult(dicePool, player)

    print(player.name .. "님 차례가 끝났습니다.")

    io.read()

    -- 다음 턴으로 넘기기
    turn = turn + 1
    if playerCount < turn then
      turn = 1
    end
  until gameOver
end

runMain()

io.write("끝났당")
