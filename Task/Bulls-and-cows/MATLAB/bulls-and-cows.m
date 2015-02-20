function BullsAndCows
% Plays the game Bulls and Cows as the "game master"

    % Create a secret number
    nDigits = 4;
    lowVal = 1;
    highVal = 9;
    digitList = lowVal:highVal;
    secret = zeros(1, 4);
    for k = 1:nDigits
        idx = randi(length(digitList));
        secret(k) = digitList(idx);
        digitList(idx) = [];
    end

    % Give game information
    fprintf('Welcome to Bulls and Cows!\n')
    fprintf('Try to guess the %d-digit number (no repeated digits).\n', nDigits)
    fprintf('Digits are between %d and %d (inclusive).\n', lowVal, highVal)
    fprintf('Score: 1 Bull per correct digit in correct place.\n')
    fprintf('       1 Cow per correct digit in incorrect place.\n')
    fprintf('The number has been chosen. Now it''s your moooooove!\n')
    gs = input('Guess: ', 's');

    % Loop until user guesses right or quits (no guess)
    nGuesses = 1;
    while gs
        gn = str2double(gs);
        if isnan(gn) || length(gn) > 1  % Not a scalar
            fprintf('Malformed guess. Keep to valid scalars.\n')
            gs = input('Try again: ', 's');
        else
            g = sprintf('%d', gn) - '0';
            if length(g) ~= nDigits || any(g < lowVal) || any(g > highVal) || ...
                    length(unique(g)) ~= nDigits    % Invalid number for game
                fprintf('Malformed guess. Remember:\n')
                fprintf('  %d digits\n', nDigits)
                fprintf('  Between %d and %d inclusive\n', lowVal, highVal)
                fprintf('  No repeated digits\n')
                gs = input('Try again: ', 's');
            else
                score = CountBullsCows(g, secret);
                if score(1) == nDigits
                    fprintf('You win! Bully for you! Only %d guesses.\n', nGuesses)
                    gs = '';
                else
                    fprintf('Score: %d Bulls, %d Cows\n', score)
                    gs = input('Guess: ', 's');
                end
            end
        end
        nGuesses = nGuesses+1;  % Counts malformed guesses
    end
end

function score = CountBullsCows(guess, correct)
% Checks the guessed array of digits against the correct array to find the score
% Assumes arrays of same length and valid numbers
    bulls = guess == correct;
    cows = ismember(guess(~bulls), correct);
    score = [sum(bulls) sum(cows)];
end
