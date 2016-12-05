fr = 1 t0 = 10
while true
see "Hey There,
========================
I'm thinking of a number between " + fr + " and " + t0 + ", Can you guess it??
Guess :> "
give x
n = nrandom(fr,t0)
if x = n see "

                  Congratulations :D

*****************************************************
     ** Your guess was right You Are Genius :D **
*****************************************************


"
exit
else
see "Oops its not true, you were just few steps"
if x > n see " up :)" else see " down :)" ok
see copy(nl,3)
ok
end

func nRandom s,e
while true
d = random(e)
if d >= s return d ok
end
