# Project : Pig the dice game
# Date    : 2017/10/31
# Author : Gal Zsolt (~ CalmoSoft ~)
# Email   : <calmosoft@gmail.com>

numPlayers = 2
maxScore = 100
safescore = list(numPlayers)

while true
         rolling = ""
         for player = 1 to numPlayers
              score = 0
              while safeScore[player] < maxScore
                       see "Player " + player + " Rolling? (Y) "
                       give rolling
                       if upper(rolling) = "Y"
                          rolled = random(5)  + 1
                          see "Player " + player + " rolled " + rolled + nl
                          if rolled = 1
                             see "Bust! you lose player " + player + " but still keep your previous score of " + safeScore[player] + nl
                             exit
                          ok
                          score = score + rolled
                       else
                          safeScore[player] = safeScore[player] + score
                      ok
              end
         next
end
see "Player " + player + " wins with a score of " + safeScore[player]
