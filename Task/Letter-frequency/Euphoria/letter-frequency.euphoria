-- LetterFrequency.ex
-- Count frequency of each letter in own source code.

include std/console.e
include std/io.e
include std/text.e

sequence letters = repeat(0,26)

sequence content = read_file("LetterFrequency.ex")

content = lower(content)

for i = 1 to length(content) do
	if content[i] > 96 and content[i] < 123 then
		letters[content[i]-96] += 1
	end if
end for

for i = 1 to 26 do
	printf(1,"%s:  %d\n",{i+96,letters[i]})
end for

if getc(0) then end if
