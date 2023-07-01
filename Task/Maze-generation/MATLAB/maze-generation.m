function M = makeMaze(n)
    showProgress = false;

    colormap([1,1,1;1,1,1;0,0,0]);
    set(gcf,'color','w');

    NoWALL      = 0;
    WALL        = 2;
    NotVISITED  = -1;
    VISITED     = -2;

    m = 2*n+3;
    M = NotVISITED(ones(m));
    offsets = [-1, m, 1, -m];

    M([1 2:2:end end],:) = WALL;
    M(:,[1 2:2:end end]) = WALL;

    currentCell = sub2ind(size(M),3,3);
    M(currentCell) = VISITED;

    S = currentCell;

    while (~isempty(S))
        moves = currentCell + 2*offsets;
        unvistedNeigbors = find(M(moves)==NotVISITED);

        if (~isempty(unvistedNeigbors))
            next = unvistedNeigbors(randi(length(unvistedNeigbors),1));
            M(currentCell + offsets(next)) = NoWALL;

            newCell = currentCell + 2*offsets(next);
            if (any(M(newCell+2*offsets)==NotVISITED))
                S = [S newCell];
            end

            currentCell = newCell;
            M(currentCell) = VISITED;
        else
            currentCell = S(1);
            S = S(2:end);
        end

        if (showProgress)
            image(M-VISITED);
            axis equal off;
            drawnow;
            pause(.01);
        end
    end

    image(M-VISITED);
    axis equal off;
