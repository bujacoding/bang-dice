-- os.execute("clear")
-- UpdateGame(turn)
-- io.write("\n")
-- dicePrint()
-- io.write("\n")
-- print("결과 처리:")

-- print(players[turn].name .. "님 공격할 사람을 정해주세요(사거리1)")
-- local input = nil
-- repeat
--     input = key.getch()
--     os.execute("clear")
--     UpdateGame(turn)
--     io.write("\n")
--     dicePrint()
--     io.write("\n")
--     print("결과 처리:")
--     print(players[turn].name .. "님 공격할 사람을 정해주세요(사거리1)")
-- until input == keys.left or input == keys.right

-- local attackToPlayer = nil
-- if input == keys.right then
--     attackToPlayer = players[turn+1]
-- else
--     attackToPlayer = players[turn-1]
-- end
-- attackToPlayer.life = attackToPlayer.life - 1
-- os.execute("clear")
-- UpdateGame(turn)
-- io.write("\n")
-- dicePrint()
-- io.write("\n")
-- print(players[turn].name .. "님이" .. attackToPlayer.name .. "님을 공격했습니다.")
-- print(attackToPlayer.name .. "님의 체력은" ..attackToPlayer.life .. "남았습니다.")