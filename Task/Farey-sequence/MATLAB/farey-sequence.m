clear all;close all;clc;

% Print Farey sequences for 1 to 11
    for i = 1:11
        farey_sequence = farey(i);
        fprintf('%2d: %s\n', i, strjoin(farey_sequence, ' '));
    end
    fprintf('\n');

    % Print the number of fractions in Farey sequences for 100 to 1000 step 100
    for i = 100:100:1000
        farey_sequence = farey(i);
        fprintf('%4d: %6d fractions\n', i, length(farey_sequence));
    end

function farey_sequence = farey(n)
    a = 0;
    b = 1;
    c = 1;
    d = n;
    farey_sequence = {[num2str(a) '/' num2str(b)]}; % Initialize the sequence with "0/1"
    while c <= n
        k = fix((n + b) / d);
        aa = a;
        bb = b;
        a = c;
        b = d;
        c = k * c - aa;
        d = k * d - bb;
        farey_sequence{end+1} = [num2str(a) '/' num2str(b)]; % Append the fraction to the sequence
    end
end
