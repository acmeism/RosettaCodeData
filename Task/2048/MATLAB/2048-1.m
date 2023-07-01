function field = puzzle2048(field)

if nargin < 1 || isempty(field)
    field = zeros(4);
    field = addTile(field);
end

clc
rng('shuffle')

while true
    oldField = field;
    clc
    score = displayField(field);

    % check losing condition
    if isGameLost(field)
        sprintf('You lose with a score of %g.',score)
        return
    end

    direction = input('Which direction? (w,a,s,d) (x for exit)\n','s');
    switch direction
        case 'w'
            field = moveUp(field);
        case 'a'
            field = rot90( moveUp( rot90(field,-1) ) );
        case 's'
            field = flipud( moveUp( flipud(field) ) );
        case 'd'
            field = rot90( moveUp( rot90(field) ), -1);
        case 'x'
            return
    end

    if any(field>=2048,'all')
        disp('You win!')
        return
    end

    if ~all(field==oldField,'all')
        field = addTile(field);
    end

end

end

function gameIsLost = isGameLost(field)

if all(field,'all') && ...
        all(conv2(field,[1, -1],'same'),'all') && ...
        all(conv2(field,[1; -1],'same'),'all')
    gameIsLost = true;
else
    gameIsLost = false;
end

end

function field = addTile(field)

freeIndices = find(~field);
newIndex = freeIndices( randi(length(freeIndices)) );
newNumber = 2 + 2 * (rand < 0.1);
field(newIndex) = newNumber;

end

function score = displayField(field)

% Unicode characters for box drawings
% 9484: U+250C Box Drawings Light Down and Right
% 9472: U+2500 Box Drawings Light Horizontal
% 9474: U+2502 Box Drawings Light Vertical
% 9488: U+2510 Box Drawings Light Down and Left
% 9492: U+2515 Box Drawings Light Up and Right
% 9496: U+2518 Box Drawings Light Up and Left
% 9500: U+251C Box Drawings Light Vertical and Right
% 9508: U+2524 Box Drawings Light Vertical and Left
% 9516: U+252C Box Drawings Light Down and Horizontal
% 9524: U+2534 Box Drawings Light Up and Horizontal
% 9532: U+253C Box Drawings Light Vertical and Horizontal
score = sum(field(:));
cellField = arrayfun(@num2str, field, 'UniformOutput', false);
cellField = cellfun(@(x) [ char(9474) blanks(5-length(x)) x ' ' ], ...
    cellField, 'UniformOutput', false);
topRow = repmat('-',1,7*size(field,2)+1);
topRow(1:7:end) = char(9516);
topRow([1 end]) = [ char(9484) char(9488) ];
midRow = topRow;
midRow(1:7:end) = char(9532);
midRow([1 end]) = [ char(9500) char(9508) ];
botRow = topRow;
botRow(1:7:end) = char(9524);
botRow([1 end]) = [ char(9492) char(9496) ];
charField = topRow;
for iRow = cellField'
    charField = [ charField; iRow{:} char(9474); midRow ];
end
charField(end,:) = botRow;
charField(charField == '0') = ' ';

disp(charField)
fprintf('\nYour score: %g\n', score)

end

function field = moveUp(field)

for iCol = 1:size(field,2)
    col = field(:,iCol);
    col = removeZeros(col);
    for iRow = 1:length(col)-1
        if col(iRow)==col(iRow+1)
            col(iRow:iRow+1) = [ 2*col(iRow); 0 ];
        end
    end
    col = removeZeros(col);
    if length(col) < length(field)
        col(end+1:length(field)) = 0;
    end
    field(:,iCol) = col;
end

end

function vector = removeZeros(vector)

vector(vector==0) = [];

end
