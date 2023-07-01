function [xCoordinates,yCoordinates] = randomDisc(numPoints)

    xCoordinates = [];
    yCoordinates = [];

    %Helper function that samples a random integer from the uniform
    %distribution between -15 and 15.
    function nums = randInt(n)
        nums = round((31*rand(n,1))-15.5);
    end

    n = numPoints;

    while n > 0

        x = randInt(n);
        y = randInt(n);

        norms = sqrt((x.^2) + (y.^2));
        inBounds = find((10 <= norms) & (norms <= 15));

        xCoordinates = [xCoordinates; x(inBounds)];
        yCoordinates = [yCoordinates; y(inBounds)];

        n = numPoints - numel(xCoordinates);
    end

    xCoordinates(numPoints+1:end) = [];
    yCoordinates(numPoints+1:end) = [];

end
