$$ MODE TUSCRIPT
MODE DATA
$$ BUILD X_TABLE alfabet2moco =*
"!"---."\".-..-."$"...-..-"'".----."
"("-.--.")"-.--.-"+".-.-.","--..--"
"-"-....-".".-.-.-"/"-..-."
"0"-----"1".----"2"..---"3"...--"
"4"....-"5"....."6"-...."7"--..."
"8"---.."9"----."
":"---...";"-.-.-."="-...-"?"..--.."
"@".--.-."
"A".-"B"-..."C"-.-."D"-.."
"E"."F"..-."G"--."H"...."
"I".."J".---"K"-.-"L".-.."
"M"--"N"-."O"---"P".--."
"Q"--.-"R".-."S"..."T"-"
"U"..-"V"...-"W".--"X"-..-"
"Y"-.--"Z"--.."
"["-.--."]"-.--.-"_"..--.-"
$$ BUILD X_TABLE moco2sound =*
" "p2 "
"-"a4 "
"."a2 "
$$ BUILD X_TABLE space2split=": :':"
$$ MODE TUSCRIPT
ASK "Please enter your sentence": mc=""
PRINT "SEE your morsecode !"
mc=EXCHANGE (mc,alfabet2moco)
PRINT mc
PRINT "HEAR your morsecode !"
mc=EXCHANGE (mc,moco2sound)
mc=EXCHANGE (mc,space2split)
BEEP $mc
