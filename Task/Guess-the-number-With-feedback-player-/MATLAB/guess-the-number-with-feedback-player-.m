function GuessNumberFeedbackPlayer

    lowVal = input('Lower limit: ');
    highVal = input('Upper limit: ');
    fprintf('Think of your number. Press Enter when ready.\n')
    pause
    nGuesses = 1;
    done = false;
    while ~done
        guess = floor(0.5*(lowVal+highVal));
        score = input(sprintf( ...
            'Is %d too high (H), too low (L), or equal (E)? ', guess), 's');
        if any(strcmpi(score, {'h' 'hi' 'high' 'too high' '+'}))
            highVal = guess-1;
            nGuesses = nGuesses+1;
        elseif any(strcmpi(score, {'l' 'lo' 'low' 'too low' '-'}))
            lowVal = guess+1;
            nGuesses = nGuesses+1;
        elseif any(strcmpi(score, {'e' 'eq' 'equal' 'right' 'correct' '='}))
            fprintf('Yay! I win in %d guesses.\n', nGuesses)
            done = true;
        else
            fprintf('Unclear response. Try again.\n')
        end
        if highVal < lowVal
            fprintf('Incorrect scoring. No further guesses.\n')
            done = true;
        end
    end
end
