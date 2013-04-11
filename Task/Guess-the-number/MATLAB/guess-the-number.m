number = ceil(10*rand(1));
[guess, status] = str2num(input('Guess a number between 1 and 10: ','s'));

while (~status || guess ~= number)
    [guess, status] = str2num(input('Guess again: ','s'));
end
disp('Well guessed!')
