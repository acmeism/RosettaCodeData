function TicTacToe

    % Set up the board (one for each player)
    boards = false(3, 3, 2);    % Players' pieces
    rep = ['   1 | 4 | 7' ; '   2 | 5 | 8' ; '   3 | 6 | 9'];

    % Prompt user with options
    fprintf('Welcome to Tic-Tac-Toe!\n')
    nHumans = str2double(input('Enter the number of human players: ', 's'));
    if isnan(nHumans) || ceil(nHumans) ~= nHumans || nHumans < 1 || nHumans > 2
        nHumans = 0;
        pHuman = false(2, 1);
    elseif nHumans == 1
        humanFirst = input('Would the human like to go first (Y/N)? ', 's');
        if length(humanFirst) == 1 && lower(humanFirst) == 'n'
            pHuman = [false ; true];
        else
            pHuman = [true ; false];
        end
    else
        pHuman = true(2, 1);
    end
    if any('o' == input('Should Player 1 use X or O? ', 's'))
        marks = 'OX';
    else
        marks = 'XO';
    end
    fprintf('So Player 1 is %shuman and %cs and Player 2 is %shuman and %cs.\n', ...
        char('not '.*~pHuman(1)), marks(1), char('not '.*~pHuman(2)), marks(2))
    if nHumans > 0
        fprintf('Select the space to mark by entering the space number.\n')
        fprintf('No entry will quit the game.\n')
    end

    % Play game
    gameOver = false;
    turn = 1;
    while ~gameOver
        fprintf('\n')
        disp(rep)
        fprintf('\n')
        if pHuman(turn)
            [move, isValid, isQuit] = GetMoveFromPlayer(turn, boards);
            gameOver = isQuit;
        else
            move = GetMoveFromComputer(turn, boards);
            fprintf('Player %d chooses %d\n', turn, move)
            isValid = true;
            isQuit = false;
        end
        if isValid && ~isQuit
            [r, c] = ind2sub([3 3], move);
            boards(r, c, turn) = true;
            rep(r, 4*c) = marks(turn);
            if CheckWin(boards(:, :, turn))
                gameOver = true;
                fprintf('\n')
                disp(rep)
                fprintf('\nPlayer %d wins!\n', turn)
            elseif CheckDraw(boards)
                gameOver = true;
                fprintf('\n')
                disp(rep)
                fprintf('\nCat''s game!\n')
            end
            turn = ~(turn-1)+1;
        end
    end
end

function [move, isValid, isQuit] = GetMoveFromPlayer(pNum, boards)
% move - 1-9 indicating move position, 0 if invalid move
% isValid - logical indicating if move was valid, true if quitting
% isQuit - logical indicating if player wishes to quit game
    p1 = boards(:, :, 1);
    p2 = boards(:, :, 2);
    moveStr = input(sprintf('Player %d: ', pNum), 's');
    if isempty(moveStr)
        fprintf('Play again soon!\n')
        move = 0;
        isValid = true;
        isQuit = true;
    else
        move = str2double(moveStr);
        isQuit = false;
        if isnan(move) || move < 1 || move > 9 || p1(move) || p2(move)
            fprintf('%s is an invalid move.\n', moveStr)
            isQuit = 0;
            isValid = false;
        else
            isValid = true;
        end
    end
end

function move = GetMoveFromComputer(pNum, boards)
% pNum - 1-2 player number
% boards - 3x3x2 logical array where pBoards(:,:,1) is player 1's marks
% Assumes that it is possible to make a move
    if ~any(boards(:))     % Play in the corner for first move
        move = 1;
    else                    % Use Newell and Simon's "rules to win"
        pMe = boards(:, :, pNum);
        pThem = boards(:, :, ~(pNum-1)+1);
        possMoves = find(~(pMe | pThem)).';

        % Look for a winning move
        move = FindWin(pMe, possMoves);
        if move
            return
        end

        % Look to block opponent from winning
        move = FindWin(pThem, possMoves);
        if move
            return
        end

        % Look to create a fork (two non-blocked lines of two)
        for m = possMoves
            newPMe = pMe;
            newPMe(m) = true;
            if CheckFork(newPMe, pThem)
                move = m;
                return
            end
        end

        % Look to make two in a row so long as it doesn't force opponent to fork
        notGoodMoves = false(size(possMoves));
        for m = possMoves
            newPMe = pMe;
            newPMe(m) = true;
            if CheckPair(newPMe, pThem)
                nextPossMoves = possMoves;
                nextPossMoves(nextPossMoves == m) = [];
                theirMove = FindWin(newPMe, nextPossMoves);
                newPThem = pThem;
                newPThem(theirMove) = true;
                if ~CheckFork(newPThem, newPMe)
                    move = m;
                    return
                else
                    notGoodMoves(possMoves == m) = true;
                end
            end
        end
        possMoves(notGoodMoves) = [];

        % Play the center if available
        if any(possMoves == 5)
            move = 5;
        	return
        end

        % Play the opposite corner of the opponent's piece if available
        corners = [1 3 7 9];
        move = intersect(possMoves, ...
            corners(~(pMe(corners) | pThem(corners)) & pThem(fliplr(corners))));
        if ~isempty(move)
            move = move(1);
            return
        end

        % Play an empty corner if available
        move = intersect(possMoves, corners);
        if move
            move = move(1);
            return
        end

        % Play an empty side if available
        sides = [2 4 6 8];
        move = intersect(possMoves, sides);
        if move
            move = move(1);
            return
        end

        % No good moves, so move randomly
        possMoves = find(~(pMe | pThem));
        move = possMoves(randi(length(possMoves)));
    end
end

function move = FindWin(board, possMoves)
% board - 3x3 logical representing one player's pieces
% move - integer indicating position to move to win, or 0 if no winning move
    for m = possMoves
        newPMe = board;
        newPMe(m) = true;
        if CheckWin(newPMe)
            move = m;
            return
        end
    end
    move = 0;
end

function win = CheckWin(board)
% board - 3x3 logical representing one player's pieces
% win - logical indicating if that player has a winning board
    win = any(all(board)) || any(all(board, 2)) || ...
        all(diag(board)) || all(diag(fliplr(board)));
end

function fork = CheckFork(p1, p2)
% fork - logical indicating if player 1 has created a fork unblocked by player 2
    fork = sum([sum(p1)-sum(p2) (sum(p1, 2)-sum(p2, 2)).' ...
        sum(diag(p1))-sum(diag(p2)) ...
        sum(diag(fliplr(p1)))-sum(diag(fliplr(p2)))] == 2) > 1;
end

function pair = CheckPair(p1, p2)
% pair - logical indicating if player 1 has two in a line unblocked by player 2
    pair = any([sum(p1)-sum(p2) (sum(p1, 2)-sum(p2, 2)).' ...
        sum(diag(p1))-sum(diag(p2)) ...
        sum(diag(fliplr(p1)))-sum(diag(fliplr(p2)))] == 2);
end

function draw = CheckDraw(boards)
% boards - 3x3x2 logical representation of all players' pieces
    draw = all(all(boards(:, :, 1) | boards(:, :, 2)));
end
