include std/console.e

sequence s = {-2,-1,0,1,2}  --print elements of a numerical list
for i = 1 to length(s) do
	? s[i]
end for

puts(1,'\n')

s = {"Name","Date","Field1","Field2"} -- print elements of a list of 'strings'
for i = 1 to length(s) do
	printf(1,"%s\n",{s[i]})
end for

puts(1,'\n')

for i = 1 to length(s) do  -- print subelements of elements of a list of 'strings'
	for j = 1 to length(s[i]) do
		printf(1,"%s\n",s[i][j])
	end for
	puts(1,'\n')
end for

if getc(0) then end if
