def player1(sum,sm)
for i in 1..100
puts "player1 rolled"
a=gets.chomp().to_i
if (a>1 && a<7)
	sum+=a
	if sum>=100
	puts "player1 wins"
	break
	end
else

goto player2(sum,sm)
end
i+=1
end
end

def player2(sum,sm)
for j in 1..100
puts "player2 rolled"
b=gets.chomp().to_i
if(b>1 && b<7)
 sm+=b
	if sm>=100
	 puts "player2 wins"
	break
	end
else

player1(sum,sm)
end
j+=1
end
end
i=0
j=0
sum=0
sm=0
player1(sum,sm)
return
