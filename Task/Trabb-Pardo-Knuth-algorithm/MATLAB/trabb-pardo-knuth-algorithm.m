clear all;close all;clc;

% Define the function f(x)
f = @(x) sqrt(abs(x)) + 5 * x^3;

% Read a line of input, split it into elements, convert to numbers
inputLine = input('', 's');
numbers = str2double(strsplit(inputLine));

% Process each number in reverse order
for i = length(numbers):-1:1
    value = f(numbers(i));
    if value > 400
        fprintf('%g: TOO LARGE\n', numbers(i));
    else
        fprintf('%g: %g\n', numbers(i), value);
    end
end
