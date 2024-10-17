integer key

puts(1,"Your answer? (Y/N)\n")
while get_key()!=-1 do
end while

while 1 do
    key = get_key()
    if key!=-1 and (key = 'Y' or key = 'y' or key = 'N' or key = 'n') then
        exit
    end if
end while

printf(1,"Your response was %s\n",key)
