print( "Fire", "Police", "Sanitation" )
sol = 0
for f = 1, 7 do
    for p = 1, 7 do
        for s = 1, 7 do
            if s + p + f == 12 and p % 2 == 0 and f ~= p and f ~= s and p ~= s then
                print( f, p, s ); sol = sol + 1
            end
        end
    end
end
print( string.format( "\n%d solutions found", sol ) )
