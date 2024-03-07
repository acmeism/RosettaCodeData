clear all;close all;clc;
% Calculate the sequences
padovan_sequence_20 = Padovan1(20)
padovan_approx_20 = Padovan2(20)

% Check if the sequences are equal for n = 64
are_sequences_equal = isequal(Padovan1(64), Padovan2(64))


% Generate the substitution system sequence
sequence_32 = createLSystem();
words = sequence_32(1:10)

% Check if the length of the substitution system sequence equals the Padovan sequence
are_lengths_equal = all( cellfun(@(ele) length(ele), sequence_32) ...
                                        == Padovan2(32) )

function words = createLSystem()
    words = {'A'}; % Initialize cell array with one element "A"
    text = 'A'; % Current text is "A"

    while length(words) < 32
        newText = ''; % Initialize new text as empty
        for i = 1:length(text)
            switch text(i)
                case 'A'
                    newText = [newText 'B']; % Append 'B' to new text
                case 'B'
                    newText = [newText 'C']; % Append 'C' to new text
                case 'C'
                    newText = [newText 'AB']; % Append 'AB' to new text
            end
        end
        text = newText; % Update text with the new text
        words{end+1} = text; % Append new text to words list
    end
end

function padovan_sequence = Padovan1(nmax)
    padovan_sequence = zeros(1, nmax);
    padovan_sequence(1:3) = [1, 1, 1];
    for n = 4:nmax
        padovan_sequence(n) = padovan_sequence(n-2) + padovan_sequence(n-3);
    end
end

function padovan_approx = Padovan2(nmax)
    p = 1.324717957244746025960908854;
    s = 1.0453567932525329623;
    padovan_approx = floor(p.^(-1:nmax-2) / s + 0.5);
end
