function [S,GS]=guess_a_number(low,high)

if nargin<1,
	low=1;
end;
if nargin<2,
	high=10;
end;

n = floor(rand(1)*(high-low+1))+low;
[guess,status] = str2num(input(sprintf('Guess a number between %i and %i',low,high)));
while (~status || g~=n)
	if g<n,
		g = input('to low, guess again');
	elseif g>n,
		g = input('to high, guess again');
	end;
	[guess, state] = str2num(g);
	while ~state	
		g = input('invalid input, guess again');
		[guess, state] = str2num(g);
	end
end
disp('Well guessed!')
