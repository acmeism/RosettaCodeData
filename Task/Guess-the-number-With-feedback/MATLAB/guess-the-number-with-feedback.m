function guess_a_number(low, high)

if nargin < 1 || ~isnumeric(low) || length(low) > 1 || isnan(low)
    low = 1;
end;
if nargin < 2 || ~isnumeric(high) || length(high) > 1 || isnan(high)
    high = low+9;
elseif low > high
    [low, high] = deal(high, low);
end

n = floor(rand(1)*(high-low+1))+low;
gs = input(sprintf('Guess an integer between %i and %i (inclusive): ', low, high), 's');
while gs    % No guess quits the game
    g = str2double(gs);
    if length(g) > 1 || isnan(g) || g < low || g > high
        gs = input('Invalid input, guess again: ', 's');
    elseif g < n
        gs = input('Too low, guess again: ', 's');
    elseif g > n
        gs = input('Too high, guess again: ', 's');
    else
        disp('Good job, you win!')
        gs = '';
    end
end
