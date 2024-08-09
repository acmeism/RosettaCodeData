numPoints = 5000;
cubeSize = 10;
numDimensions = 10;

points = hypercubePoints(numPoints, cubeSize, numDimensions);

hypercubeKDTree = buildKDTree(points);

queryPoint = rand(1, numDimensions);  % for the k-nearest neighbour search

[nearestPoint, nearestDist, nodesVisited] = nearestNeighbourSearch(hypercubeKDTree, queryPoint);

fprintf('Points in KD-Tree:\n');
fprintf('Query point: (%.2f, %.2f, %.2f)\n', queryPoint);
fprintf('Nearest point: (%.2f, %.2f, %.2f)\n', nearestPoint);
fprintf('Distance: %.4f\n', nearestDist);
fprintf('Nodes visited: %d\n', nodesVisited);
