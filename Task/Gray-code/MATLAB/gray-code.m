%% Gray Code Generator
% this script generates gray codes of n bits
% total 2^n -1 continuous gray codes will be generated.
% this code follows a recursive approach. therefore,
% it can be slow for large n



clear all;
clc;

bits = input('Enter the number of bits: ');
if (bits<1)
    disp('Sorry, number of bits should be positive');
elseif (mod(bits,1)~=0)
    disp('Sorry, number of bits can only be positive integers');
else
    initial_container = [0;1];
    if bits == 1
        result = initial_container;
    else
        previous_container = initial_container;
        for i=2:bits
            new_gray_container = zeros(2^i,i);
            new_gray_container(1:(2^i)/2,1) = 0;
            new_gray_container(((2^i)/2)+1:end,1) = 1;

            for j = 1:(2^i)/2
                new_gray_container(j,2:end) = previous_container(j,:);
            end

            for j = ((2^i)/2)+1:2^i
                new_gray_container(j,2:end) = previous_container((2^i)+1-j,:);
            end

            previous_container = new_gray_container;
        end
        result = previous_container;
    end
    fprintf('Gray code of %d bits',bits);
    disp(' ');
    disp(result);
end
