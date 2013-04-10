--caesar cipher for Rosetta Code wiki
--User:Lnettnay

--usage eui caesar ->default text, key and encode flag
--usage eui caesar 'Text with spaces and punctuation!' 5 D
--If text has imbedded spaces must use apostophes instead of quotes so all punctuation works
--key = integer from 1 to 25, defaults to 13
--flag = E (Encode) or D (Decode), defaults to E
--no error checking is done on key or flag

include std/get.e
include std/types.e


sequence cmd = command_line()
sequence val
-- default text for encryption
sequence text = "The Quick Brown Fox Jumps Over The Lazy Dog."
atom key = 13 -- default to Rot-13
sequence flag = "E" -- default to Encrypt
atom offset
atom num_letters = 26 -- number of characters in alphabet

--get text
if length(cmd) >= 3 then
	text = cmd[3]
end if

--get key value
if length(cmd) >= 4 then
	val = value(cmd[4])
	key = val[2]
end if

--get Encrypt/Decrypt flag
if length(cmd) = 5 then
	flag = cmd[5]
	if compare(flag, "D") = 0 then
		key = 26 - key
	end if
end if

for i = 1 to length(text) do
	if t_alpha(text[i]) then
		if t_lower(text[i]) then
			offset = 'a'
		else
			offset = 'A'
		end if
		text[i] = remainder(text[i] - offset + key, num_letters) + offset
	end if
end for

printf(1,"%s\n",{text})
