function node = buildKDTree(points, depth)
    if nargin < 2
        depth = 0;      % default depth to start building tree, otherwise specified in the function call
    end
    if isempty(points)
        node = [];
        return;
    end

    k = size(points, 2);        % Dimensionality of the points
    axis = mod(depth, k) + 1;

    % Sort point list and choose median as pivot element

    sortedPoints = sortrows(points, axis);
    medianIdx = floor(size(sortedPoints, 1) / 2) + 1;

    % Create node and construct subtrees
    
    node = kdNode(sortedPoints(medianIdx, :), ...
                  buildKDTree(sortedPoints(1 : medianIdx - 1, :), depth + 1), ...
                  buildKDTree(sortedPoints(medianIdx + 1 : end, :), depth + 1));
end
