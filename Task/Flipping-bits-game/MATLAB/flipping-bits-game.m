function FlippingBitsGame(n)
% Play the flipping bits game on an n x n array

    % Generate random target array
    fprintf('Welcome to the Flipping Bits Game!\n')
    if nargin < 1
        n = input('What dimension array should we use? ');
    end
    Tar = logical(randi([0 1], n));

    % Generate starting array by randomly flipping rows or columns
    Cur = Tar;
    while all(Cur(:) == Tar(:))
        nFlips = randi([3*n max(10*n, 100)]);
        randDim = randi([0 1], nFlips, 1);
        randIdx = randi([1 n], nFlips, 1);
        for k = 1:nFlips
            if randDim(k)
                Cur(randIdx(k), :) = ~Cur(randIdx(k), :);
            else
                Cur(:, randIdx(k)) = ~Cur(:, randIdx(k));
            end
        end
    end

    % Print rules
    fprintf('Given a %d x %d logical array,\n', n, n)
    fprintf('and a target array configuration,\n')
    fprintf('attempt to transform the array to the target\n')
    fprintf('by inverting the bits in a whole row or column\n')
    fprintf('at once in as few moves as possible.\n')
    fprintf('Enter the corresponding letter to invert a column,\n')
    fprintf('or the corresponding number to invert a row.\n')
    fprintf('0 will reprint the target array, and no entry quits.\n\n')
    fprintf('Target:\n')
    PrintArray(Tar)

    % Play until player wins or quits
    move = true;
    nMoves = 0;
    while ~isempty(move) && any(Cur(:) ~= Tar(:))
        fprintf('Move %d:\n', nMoves)
        PrintArray(Cur)
        move = lower(input('Enter move: ', 's'));
        if length(move) > 1
            fprintf('Invalid move, try again\n')
        elseif move
            r = str2double(move);
            if isnan(r)
                c = move-96;
                if c > n || c < 1
                    fprintf('Invalid move, try again\n')
                else
                    Cur(:, c) = ~Cur(:, c);
                    nMoves = nMoves+1;
                end
            else
                if r > n || r < 0
                    fprintf('Invalid move, try again\n')
                elseif r == 0
                    fprintf('Target:\n')
                    PrintArray(Tar)
                else
                    Cur(r, :) = ~Cur(r, :);
                    nMoves = nMoves+1;
                end
            end
        end
    end

    if all(Cur(:) == Tar(:))
        fprintf('You win in %d moves! Try not to flip out!\n', nMoves)
    else
        fprintf('Quitting? The challenge a bit much for you?\n')
    end
end

function PrintArray(A)
    [nRows, nCols] = size(A);
    fprintf('        ')
    fprintf(' %c', (1:nCols)+96)
    fprintf('\n')
    for r = 1:nRows
        fprintf('%8d%s\n', r, sprintf(' %d', A(r, :)))
    end
    fprintf('\n')
end
