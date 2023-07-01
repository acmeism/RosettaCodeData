function piEstimate = monteCarloPi(numDarts)

    %The square has a sides of length 2, which means the circle has radius
    %1.

    %Generate a table of random x-y value pairs in the range [0,1] sampled
    %from the uniform distribution for each axis.
    darts = rand(numDarts,2);

    %Any darts that are in the circle will have position vector whose
    %length is less than or equal to 1 squared.
    dartsInside = ( sum(darts.^2,2) <= 1 );

    piEstimate = 4*sum(dartsInside)/numDarts;

end
