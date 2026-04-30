include std\text.e
include std\os.e
include std\sequence.e
include std\console.e

sequence bcData = {0,0} --bull,cow score for the player
sequence goalNum = { {0,0,0,0}, {0,0,0,0}, 0} --computer's secret number digits (element 1), marked as bull/cow
--indexes in element 2, integer value of it in element 3
sequence currentGuess = { {0,0,0,0}, {0,0,0,0}, 0} --player's guess, same format as goalNum
sequence removeChars = 0 & " 0\r\t\n" --characters to trim (remove) from user's input. \r, \t are single escaped characters,
--0 is ascii 0x0 and number zero is ascii 48, or 0x30. The rest are wysiwyg
integer tries = 0 --track number of tries to guess the number
sequence bcStrings ={"bull", "cow"} --stores singular and/or plural strings depending on score in bcData

goalNum[1] = rand( {9,9,9,9} ) --rand function works on objects. here it outputs into each sequence element.
goalNum[3] = goalNum[1][1] * 1000 + goalNum[1][2] * 100 + goalNum[1][3] * 10 + goalNum[1][4] --convert digits to an integer
--and store it

procedure getInputAndProcess(integer stage = 1)  --object = 1 sets default value for the parameter if it isn't specified

    goalNum[2][1..4] = 0 --{0,0,0,0} --set these to unscaned (0) since the scanning will start over.
    currentGuess[1][1..4] = 0 --{0,0,0,0} --these too, or they will contain old marks
    currentGuess[2][1..4] = 0
    tries += 1 --equivalent to tries = tries + 1, but faster and shorter to write
    bcData[1..2] = 0 -- {0,0}

    if stage <= 1 then --if this process was run for the first time or with no parameters, then..
        puts(1,"The program has thought of a four digit number using only digits 1 to 9.\nType your guess and press enter.\n")
    end if

    while 1 label "guesscheck" do --labels can be used to specify a jump point from exit or retry, and help readability
        currentGuess[1] = trim(gets(0), removeChars) --get user input, trim unwanted characters from it, store it in currentGuess[1]
        currentGuess[1] = mapping( currentGuess[1], {49,50,51,52,53,54,55,56,57}, {1,2,3,4,5,6,7,8,9} ) --convert ascii codes to
        -- integer digits they represent
        integer tempF = find('0',currentGuess[1])
        if length(currentGuess[1]) != 4 or tempF != 0 then --if the input string is now more than 4 characters/integers,
            --the input won't be used.
            puts(1,"You probably typed too many digits or a 0. Try typing a new 4 digit number with only numbers 1 through 9.\n")
            retry "guesscheck"
            else
                exit "guesscheck"
        end if
    end while
    --convert separate digits to the one integer they represent and store it, like with goalNum[3]
    currentGuess[3] = currentGuess[1][1] * 1000 + currentGuess[1][2] * 100 + currentGuess[1][3] * 10 + currentGuess[1][4]
--convert digits to the integer they represent, to print to a string later

    --check for bulls
    for i = 1 to 4 do
        if goalNum[1][i] = currentGuess[1][i] then
            goalNum[2][i] = 1
            currentGuess[2][i] = 1
            bcData[1] += 1
        end if
    end for

    --check for cows, but not slots marked as bulls or cows already.
    for i = 1 to 4 label "iGuessElem"do --loop through each guessed digit
        for j = 1 to 4 label "jGoalElem" do --but first go through each goal digit, comparing the first guessed digit,
            --and then the other guessed digits 2 through 4

            if currentGuess[2][i] = 1 then --if the guessed digit we're comparing right now has been marked as bull or cow already
                continue "iGuessElem" --skip to the next guess digit without comparing this guess digit to the other goal digits
            end if

            if goalNum[2][j] = 1 then --if the goal digit we're comparing to right now has been marked as a bull or cow already
                continue "jGoalElem" --skip to the next goal digit
            end if

            if currentGuess[1][i] = goalNum[1][j] then --if the guessed digit is the same as the goal one,
                --it won't be a bull, so it's a cow
                bcData[2] += 1 --score one more cow
                goalNum[2][j] = 1 --mark this digit as a found cow in the subsequence that stores 0's or 1's as flags
                continue "iGuessElem" --skip to the next guess digit, so that this digit won't try to check for
                --matches(cow) with other goal digits
            end if

        end for --this guess digit was compared to one goal digit , try comparing this guess digit with the next goal digit
    end for --this guess digit was compared with all goal digits, compare the next guess digit to all the goal digits

    if bcData[1] = 1 then --uses singular noun when there is score of 1, else plural
        bcStrings[1] = "bull"
        else
            bcStrings[1] = "bulls"
    end if

    if bcData[2] = 1 then --the same kind of thing as above block
        bcStrings[2] = "cow"
        else
            bcStrings[2] = "cows"
    end if

    if bcData[1] < 4 then --if less than 4 bulls were found, the player hasn't won, else they have...
        printf(1, "Guess #%d : You guessed %d . You found %d %s, %d %s. Type new guess.\n", {tries, currentGuess[3], bcData[1], bcStrings[1], bcData[2], bcStrings[2]} )
        getInputAndProcess(2)
    else --else they have won and the procedure ends
        printf(1, "The number was %d. You guessed %d in %d tries.\n", {goalNum[3], currentGuess[3], tries} )
        any_key()--wait for keypress before closing console window.
    end if

end procedure
--run the procedure
getInputAndProcess(1)
