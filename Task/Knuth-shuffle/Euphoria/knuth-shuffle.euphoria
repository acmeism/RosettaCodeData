sequence cards
cards = repeat(0,52)
integer card,temp

puts(1,"Before:\n")
for i = 1 to 52 do
    cards[i] = i
    printf(1,"%d ",cards[i])
end for

for i = 52 to 1 by -1 do
    card = rand(i)
    if card != i then
        temp = cards[card]
        cards[card] = cards[i]
        cards[i] = temp
    end if
end for

puts(1,"\nAfter:\n")
for i = 1 to 52 do
    printf(1,"%d ",cards[i])
end for
