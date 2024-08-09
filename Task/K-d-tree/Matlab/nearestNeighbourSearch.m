function [nearestPoint, nearestDist, nodesVisited] = nearestNeighbourSearch(root, queryPoint)
    
    nearestPoint = [];
    nearestDist = inf;
    nodesVisited = 0;

    % Define the recursive search function
    function search(node, depth)
        if isempty(node)
            return;
        end

        nodesVisited = nodesVisited + 1; 

        % Calculate the current distance (squared distance)

        currentPoint = node.point;      
        currentDist = sum((queryPoint - currentPoint).^2);

        % Update nearest point if the current node is closer

        if isempty(nearestPoint) || currentDist < nearestDist
            nearestPoint = currentPoint;
            nearestDist = currentDist;
        end

        % Determine which subtree to search first (based on axis and query point)

        k = length(queryPoint);    % Dimensionality of points
        axis = mod(depth, k) + 1;

        if queryPoint(axis) <= currentPoint(axis)
            nearerSubtree = node.left;
            furtherSubtree = node.right;
        else
            nearerSubtree = node.right;
            furtherSubtree = node.left;
        end

        % Search the nearer subtree first

        search(nearerSubtree, depth + 1);

        % If the further subtree has a closer point

        dx = queryPoint(axis) - currentPoint(axis);
        if dx^2 < nearestDist
            search(furtherSubtree, depth + 1);
        end
    end

    % Search from the root of the kd-tree

    search(root, 0);
    
end
