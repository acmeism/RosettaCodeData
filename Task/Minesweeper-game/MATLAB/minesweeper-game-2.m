function Minesweeper

    % Game parameters (should be modified by user)
    nRows = 6;
    nCols = 4;
    percentMines = 0.15;

    % Create minefield
    nMines = ceil(percentMines*nRows*nCols);
    field = makeGrid(nRows, nCols, nMines);

    % Create timer for updating in axes title
    stopwatch = timer('TimerFcn', {@updateTime, field}, ...
        'ExecutionMode', 'fixedRate', 'Period', 1, 'StartDelay', 1, ...
        'TasksToExecute', 999);

    % Specify callbacks
    set(gcf, 'CloseRequestFcn', {@cleanUp, stopwatch})
    set(gca, 'ButtonDownFcn', {@onClick, field, stopwatch})


end

function field = makeGrid(nRows, nCols, nMines)
    % Create minefield with unit squares
    % Use quadrant IV to make indexing semi-consistent
    % i.e. square in ith row, jth column has lower-right corner at (j, -i)
    figure
    set(gcf, 'Color', [1 1 1])
    axis([0 nCols -nRows 0])
    axis square
    axis manual
    hold on
    set(gca, 'GridLineStyle', '-')
    grid on
    set(gca, 'XTick', 0:nCols)
    set(gca, 'YTick', -nRows:0)
    set(gca, 'XTickLabel', [])
    set(gca, 'YTickLabel', [])
    set(gca, 'Color', [0.6 0.6 0.6])
    setTitle(nMines, ': )', 0)
    xlabel('left-click to dig, right-click to mark')

    % Set up field structure
    % text will contain the handles to the labels in each square
    %   One character per square (or other functions will break)
    %   . Nothing noted
    %   M Marked as mine
    %   ? Marked as unknown
    %   1-8 Digits indicate how many mines this square touches
    %   * Mine (game over)
    %   (blank) Square has been (dug) and is not mined nor touching any mines
    % squares will contain handles to the colored "fill" objects
    %   fill objects will be deleted once square is "dug"
    %   Use ishandle() to determine if square is not yet dug
    % mines will contain a logical array indicating positions of mines
    %   true Mine
    %   false No mine
    % Later versions of MATLAB use gobjects() to preallocate text and squares
    field = struct('text', zeros(nRows, nCols), ...
        'squares', zeros(nRows, nCols), ...
        'mines', false(nRows, nCols));

    % Create individual square color and label objects
    for r = 1:nRows
        for c = 1:nCols
            field.squares(r, c) = ...
                fill([c-1 c-1 c c c-1], [-r+1 -r -r -r+1 -r+1], [0.9 0.9 0.9]);
            set(field.squares(r, c), 'HitTest', 'off')
            field.text(r, c) = text(c-0.5, -r+0.5, '.');
            set(field.text(r, c), 'FontSize', 12, 'FontWeight', 'bold', ...
                'HorizontalAlignment', 'center', 'HitTest', 'off');
        end
    end

    % Place mines randomly without repeats
    k = 0;
    while k < nMines
        idx = randi(nRows*nCols);
        if ~field.mines(idx)
            field.mines(idx) = true;
            k = k+1;
        end
    end
end

function onClick(obj, event, field, stopwatch)
    if strcmp(stopwatch.Running, 'off')
        start(stopwatch)
    end

    pt = get(obj, 'CurrentPoint');
    r = ceil(-pt(1, 2));
    c = ceil(pt(1, 1));

    if r > 0 && c > 0 && r <= size(field.squares, 1) && ... % Not yet been "dug"
            c <= size(field.squares, 2) && ishandle(field.squares(r, c))
        buttons = {'normal' 'alt' 'extend'};
        btn = find(strcmp(get(get(obj, 'Parent'), 'SelectionType'), buttons));
        labels = '.M?'; % Unmarked, mine flag, unknown flag
        currLabel = get(field.text(r, c), 'String');

        if btn == 1     % Left click
            if currLabel ~= labels(2);  % Don't dig if flagged as mine
                if field.mines(r, c)    % Mine there -> you lose
                    gameLost(field, stopwatch, r, c)
                else                    % No mine -> free to dig
                    minesLeft = countMineFlags(field);
                    digSquare(field, r, c)
                    if all(all(ishandle(field.squares) == field.mines))
                        gameWon(field, stopwatch)
                    else
                        faceTimer = timer('StartDelay', 0.5, ...
                            'StartFcn', {@setTitleOnTimer, minesLeft, ...
                            ': o', stopwatch.TasksExecuted}, ...
                            'TimerFcn', {@setTitleOnTimer, minesLeft, ...
                            ': )', stopwatch.TasksExecuted}, ...
                            'StopFcn', @deleteTimer);
                        start(faceTimer)
                    end
                end
            end

        elseif btn == 2 % Right-click
            % Rotate through labels list to the next one
            switch find(currLabel == labels)
                case 1
                    newLabel = labels(2);
                case 2
                    newLabel = labels(3);
                case 3
                    newLabel = labels(1);
            end
            set(field.text(r, c), 'String', newLabel);
            setTitle(countMineFlags(field), ': )', stopwatch.TasksExecuted)

        elseif btn == 3 % Middle-click
            % Mark/unmark unknown flag
            if currLabel == labels(1)
                set(field.text(r, c), 'String', labels(3));
            elseif currLabel == labels(3)
                set(field.text(r, c), 'String', labels(1));
            end
        end
    end
end

function updateTime(obj, event, field)
    setTitle(countMineFlags(field), ': )', obj.TasksExecuted)
end

function deleteTimer(obj, event)
    delete(obj)
end

function setTitleOnTimer(obj, event, mines, face, time)
    setTitle(mines, face, time)
end

function setTitle(mines, face, time)
    title(sprintf('%03d Mines        %s        Timer %03d', mines, face, time))
end

function minesLeft = countMineFlags(field)
% Determine how many mines are unmarked (negative means too many mines marked)
    minesLeft = sum(field.mines(:));
    for k = 1:numel(field.text)
        if get(field.text(k), 'String') % Not an empty string
            minesLeft = minesLeft-(get(field.text(k), 'String') == 'M');
        end
    end
end

function digSquare(field, r, c)
% If square is touching one or more mines then indicate the number
% Otherwise indicate no mines and dig surrounding squares recursively
% Assumes current square is clear of mines
    delete(field.squares(r, c))
    [nRows, nCols] = size(field.mines);
    surrR = [r-1 r r+1 r-1 r+1 r-1 r r+1];
    surrC = [c-1 c-1 c-1 c c c+1 c+1 c+1];
    toDelete = surrR < 1 | surrR > nRows | surrC < 1 | surrC > nCols;
    surrR(toDelete) = [];
    surrC(toDelete) = [];
    nearMines = sum(field.mines(sub2ind([nRows nCols], surrR, surrC)));
    label = sprintf('%d', nearMines);
    textColor = [0 0 0 ; 0 0 1 ; 0 1 0 ; 1 0 0 ; 0.5 0.1 0.9 ; ...
        0.6 0 0 ; 0.2 0.5 0.3 ; 0.2 0.2 0.1 ; 0 0 0];
    if ~nearMines
        label = '';
        for k = 1:length(surrR)
            if ~field.mines(surrR(k), surrC(k)) && ...
                    ishandle(field.squares(surrR(k), surrC(k))) && ...
                    ~strcmp(get(field.text(k), 'String'), 'M')
                digSquare(field, surrR(k), surrC(k))
            end
        end
    end
    set(field.text(r, c), 'String', label, 'Color', textColor(nearMines+1, :))
end

function gameLost(field, stopwatch, r, c)
    stop(stopwatch)
    setTitle(countMineFlags(field), 'X (', stopwatch.TasksExecuted)
    set(field.squares(r, c), 'FaceColor', [1 0 0])
    for k = 1:numel(field.text)
        if field.mines(k) && any(get(field.text(k), 'String') == '.?')
            set(field.text(k), 'String', '*', 'FontSize', 20)
        elseif ~field.mines(k) && ishandle(field.squares(k)) && ...
                get(field.text(k), 'String') == 'M'
            set(field.text(k), 'String', 'X', 'Color', [1 0 0])
        end
    end
    set(gca, 'HitTest', 'off')
    queryPlayAgain('Game over')
end

function gameWon(field, stopwatch)
% Flag any leftover mines and indicate win
    stop(stopwatch)
    set(field.text(ishandle(field.squares)), 'String', 'M')
    setTitle(0, 'B )', stopwatch.TasksExecuted)
    set(gca, 'HitTest', 'off')
    queryPlayAgain('Minefield cleared!')
end

function queryPlayAgain(msg)
% Ask player if they want to play again
% Reset game by closing and reopening figure
    choice = questdlg(sprintf('%s\nWould you like to play again?', msg), ...
        '', 'Yes', 'No', 'No');
    if strcmp(choice, 'Yes')
        close
        Minesweeper
    end
end

function cleanUp(obj, event, stopwatch)
% Stop and close down all necessary processes
    stop(stopwatch)
    delete(stopwatch)
    delete(obj)
end
