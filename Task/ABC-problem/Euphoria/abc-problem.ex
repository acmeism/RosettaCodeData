include std/text.e

sequence blocks = {{'B','O'},{'X','K'},{'D','Q'},{'C','P'},{'N','A'},
                   {'G','T'},{'R','E'},{'T','G'},{'Q','D'},{'F','S'},
                   {'J','W'},{'H','U'},{'V','I'},{'A','N'},{'O','B'},
                   {'E','R'},{'F','S'},{'L','Y'},{'P','C'},{'Z','M'}}
sequence words = {"A","BarK","BOOK","TrEaT","COMMON","SQUAD","CONFUSE"}

sequence current_word
sequence temp
integer matches

for i = 1 to length(words) do
	current_word = upper(words[i])
	temp = blocks
	matches = 0
	for j = 1 to length(current_word) do
		for k = 1 to length(temp) do
			if find(current_word[j],temp[k]) then
				temp = remove(temp,k)
				matches += 1
				exit
			end if
		end for
		if length(current_word) = matches then
			printf(1,"%s: TRUE\n",{words[i]})
			exit
		end if
	end for
	if length(current_word) != matches then
		printf(1,"%s: FALSE\n",{words[i]})
	end if
end for

if getc(0) then end if
