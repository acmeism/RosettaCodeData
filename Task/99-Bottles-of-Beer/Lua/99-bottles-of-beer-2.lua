verse = [[%i bottle%s of beer on the wall
%i bottle%s of beer
Take one down, pass it around
%i bottle%s of beer on the wall
]]
function suffix(i) return i ~= 1 and 's' or '' end

for i = 99, 1, -1 do
    print(verse:format(i, suffix(i), i, suffix(i), i-1, suffix(i-1)))
end
