function NumberReversalGame
    list = randperm(9);
    while issorted(list)
        list = randperm(9);
    end
    fprintf('Given a list of numbers, try to put them into ascending order\n')
    fprintf('by sequentially reversing everything left of a point you choose\n')
    fprintf('in the array. Try to do it in as few reversals as possible.\n')
    fprintf('No input will quit the game.\n')
    fprintf('Position Num:%s\n', sprintf(' %d', 1:length(list)))
    fprintf('Current List:%s', sprintf(' %d', list))
    pivot = 1;
    nTries = 0;
    while ~isempty(pivot) && ~issorted(list)
        pivot = input('    Enter position of reversal limit: ');
        if pivot
            list(1:pivot) = list(pivot:-1:1);
            fprintf('Current List:%s', sprintf(' %d', list))
            nTries = nTries+1;
        end
    end
    if issorted(list)
        fprintf('\nCongratulations! You win! Only %d reversals.\n', nTries)
    else
        fprintf('\nPlay again soon!\n')
    end
end
