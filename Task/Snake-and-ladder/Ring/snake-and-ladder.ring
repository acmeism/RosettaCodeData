# Project : Snakes and Ladders Game
# Date    : 2024/11/26
# Author  : Gal Zsolt (~ CalmoSoft ~)
# Email   : <calmosoft@gmail.com>

size = 10
filetype = null
dicenr = 0
sumred = 0
sumyellow = 0
nextdic = 0
nextmod = 0
movetype = 0
ncor = 0
mcor = 0
rnd = 1
nKey = 0
movenew = 0
movedice = 0
numdice = 0
flagdice = true
oGame = null
lSpaceKey = False
discyellow = "discyellow.png"
discred = "discred.jpg"
diceyellow1 = "diceyellow1.png"
diceyellow2 = "diceyellow2.png"
diceyellow3 = "diceyellow3.png"
diceyellow4 = "diceyellow4.png"
diceyellow5 = "diceyellow5.png"
diceyellow6 = "diceyellow6.png"
dicered1 = "dicered1.jpg"
dicered2 = "dicered2.jpg"
dicered3 = "dicered3.jpg"
dicered4 = "dicered4.jpg"
dicered5 = "dicered5.jpg"
dicered6 = "dicered6.jpg"
dicesyellow = [diceyellow1,diceyellow2,diceyellow3,diceyellow4,diceyellow5,diceyellow6]
dicesred = [dicered1,dicered2,dicered3,dicered4,dicered5,dicered6]
ladder = [[6,27],[9,50],[20,39],[25,57],[53,72],[54,85],[61,82]]
snake = [[16,43],[34,55],[42,78],[48,70],[73,95],[82,96]]

Load "gameengine.ring"

func main
       oGame = New Game
       {
                      icon = "dicered6.jpg"
                      title = "Snakes And Ladders (Press SPACE to play)"
                      al_resize_display(display,650,593)
                      sprite
                      {
	               x=0 y=0 width=590 height=593
	               file = "gameimage.png"
	               transparent = false
	               Animate=false
	               Move=false
	               Scaled=true
                       }
                       sprite
                       {
	                x=600
	                y=20
	                width=30 height=30
	                file = dicered1
	                transparent = true
	                Animate=false
	                Move=false
	                Scaled=true
                        }
                        sprite
                       {
	                width=30 height=30
	                file = dicered1
	                transparent = true
	                Animate=false
	                Move=false
	                Scaled=true
                        }
                        dicenr = random(5)+1
                        nextdice(dicenr)
       }

func nextdice(dicenr)
       oGame { sprite {
	             x=600
	             y=20
	             width=40 height=40
	             transparent = true
	             Animate=false
	             Move=false
	             Scaled=true

                     nextdic = nextdic + 1
                     nextmod = nextdic%2
                     if nextmod = 1
	                file = dicesyellow[dicenr]
                        filetype = discyellow
                        sumyellow = sumyellow + 1
                        pmove2(oGame,filetype)
                     else
                        file = dicesred[dicenr]
                        filetype = discred
                        sumred = sumred + 1
                        pmove1(oGame,filetype)
                     ok
                     } }

func pmove1(oGame,filetype)
       oGame { sprite {
                     width=40 height=40
                     name = :Red
                     file = filetype
                     transparent = true
                     Animate=false
                     Move=false
                     Scaled=true
                     state = func oGame,oSelf {
                                oSelf {
                                if filetype = discred
                                   oGame.find(:Red).x = 20+58*(ncor-1)
                                   oGame.find(:Red).y = 20+58*(10-mcor)
                                ok
                                cont()
                                }
			}
                        keypress = func ogame,oself,nKey {
                                        if nKey = key_space
					   lSpaceKey = True
                                        ok }
                  }
	}
        return

func pmove2(oGame,filetype)
       oGame { sprite {
                     width=40 height=40
                     name = :Yellow
                     file = filetype
                     transparent = true
                     Animate=false
                     Move=false
                     Scaled=true
                     state = func oGame,oSelf {
                                oSelf {
                                if filetype = discyellow
                                   oGame.find(:Yellow).x = 20+58*(ncor-1)
                                   oGame.find(:Yellow).y = 20+58*(10-mcor)
                                ok
                                cont()
                                }
			}
                        keypress = func ogame,oself,nKey {
                                        if nKey = key_space
					   lSpaceKey = True
                                        ok }
                  }
	}
        return

func pcor(num)
       nr = 0
       for n = 1 to size
            for m = 1 to size
                 nr = nr + 1
                 if nr = num
                    if n%2 = 1
                       ncor = m
                    else
                       ncor = 11-m
                    ok
                    mcor = n
                 ok
            next
       next
       return

func checkladder(num)
        flag = 0
        for n = 1 to len(ladder)
             if ladder[n][1] = num
                pcor(ladder[n][2])
                movenew = ladder[n][2]
                see "Ladder Move: " + ladder[n][1] + " -> " + ladder[n][2] + nl
                flag = 1
                exit
             ok
         next
         if flag = 1
            return 1
         else
            return 0
         ok

func checksnake(num)
        flag = 0
        for n = 1 to len(snake)
             if snake[n][2] = num
                pcor(snake[n][1])
                movenew = snake[n][1]
                see "Snake Move: " + snake[n][2] + " -> " + snake[n][1] + nl
                flag = 1
                exit
             ok
         next
         if flag = 1
            return 1
         else
            return 0
         ok

func cont()
     if lSpaceKey = True and flagdice = true
	lSpaceKey = False
	nKey = 0
        rnd = random(5)+1
	nextdice(rnd)
        flagdice = false
        numdice = 1
     ok
     if flagdice = false 	
        if numdice < rnd + 1
           numdice = numdice + 1
           movetype = movetype + 1
        else
           flagdice = true
	   moveold = movetype
	   laddercheck = checkladder(movetype)
	   if laddercheck = 1
	      movetype = movenew
	   ok
	   if laddercheck = 1
	      snakecheck = checksnake(movetype)
	   else
	      snakecheck = checksnake(moveold)
	   ok
	   if snakecheck = 1
	      movetype = movenew
	   but laddercheck = 0 and snakecheck = 0
	       movetype = moveold
	   ok
           return
        ok
  	if movetype > size*size-1
	   see "You won" + nl
	   see "Your Score: " + movetype + nl
	   oGame.shutdown()
	ok
        pcor(movetype)
     ok

