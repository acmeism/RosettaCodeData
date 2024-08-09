function randomPoints = hypercubePoints(numPoints, hypercubeSize, numDimensions)
    % Generate random points in the n-dimensional hypercube
    
     randomPoints = hypercubeSize * rand(numPoints, numDimensions); % scales these values to the dimensions of the n-dimensional hypercube
end

