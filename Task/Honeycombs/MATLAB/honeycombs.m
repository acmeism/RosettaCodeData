function Honeycombs
    nRows = 4;                      % Number of rows
    nCols = 5;                      % Number of columns
    nHexs = nRows*nCols;            % Number of hexagons
    rOuter = 1;                     % Circumradius
    startX = 0;                     % x-coordinate of upper left hexagon
    startY = 0;                     % y-coordinate of upper left hexagon
    delX = rOuter*1.5;              % Horizontal distance between hexagons
    delY = rOuter*sqrt(3);          % Vertical distance between hexagons
    offY = delY/2;                  % Vertical offset between columns
    genHexX = rOuter.*cos(2.*pi.*(0:5).'./6);   % x-coords of general hexagon
    genHexY = rOuter.*sin(2.*pi.*(0:5).'./6);   % y-coords of general hexagon
    centX = zeros(1, nHexs);        % x-coords of hexagon centers
    centY = zeros(1, nHexs);        % y-coords of hexagon centers
    for c = 1:nCols
        idxs = (c-1)*nRows+1:c*nRows;   % Indeces of hexagons in that column
        if mod(c, 2)                % Odd numbered column - higher y-values
            centY(idxs) = startY:-delY:startY-delY*(nRows-1);
        else                        % Even numbered column - lower y-values
            centY(idxs) = startY-offY:-delY:startY-offY-delY*(nRows-1);
        end
        centX(idxs) = (startX+(c-1)*delX).*ones(1, nRows);
    end
    [MCentX, MGenHexX] = meshgrid(centX, genHexX);
    [MCentY, MGenHexY] = meshgrid(centY, genHexY);
    HexX = MCentX+MGenHexX;         % x-coords of hexagon vertices
    HexY = MCentY+MGenHexY;         % y-coords of hexagon vertices
    figure
    hold on
    letters = char([65:90 97:122]);
    randIdxs = randperm(26);
    letters = [letters(randIdxs) letters(26+randIdxs)];
    hexH = zeros(1, nHexs);
    for k = 1:nHexs                 % Create patches individually
        hexH(k) = patch(HexX(:, k), HexY(:, k), [1 1 0]);
        textH = text(centX(k), centY(k), letters(mod(k, length(letters))), ...
            'HorizontalAlignment', 'center', 'FontSize', 14, ...
            'FontWeight', 'bold', 'Color', [1 0 0], 'HitTest', 'off');
        set(hexH(k), 'UserData', textH) % Save to object for easy access
    end
    axis equal
    axis off
    set(gca, 'UserData', '')        % List of clicked patch labels
    set(hexH, 'ButtonDownFcn', @onClick)
end

function onClick(obj, event)
    axesH = get(obj, 'Parent');
    textH = get(obj, 'UserData');
    set(obj, 'FaceColor', [1 0 1])                      % Change color
    set(textH, 'Color', [0 0 0])                        % Change label color
    set(obj, 'HitTest', 'off')                          % Ignore future clicks
    currList = get(axesH, 'UserData');                  % Hexs already clicked
    newList = [currList get(textH, 'String')];          % Update list
    set(axesH, 'UserData', newList)
    title(newList)
end
