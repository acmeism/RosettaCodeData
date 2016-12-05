while true
see "Hey There,
========================
I'm thinking of a number between 0 and 10, Can you guess it??
Guess :> "
give x
n = random(10)
if x = n see "
**********************************************
     ** Thats right You Are Genius :D **
**********************************************
"
exit
else
see "Oops its not true, Try again please :)" + copy(nl,3)
ok
end
