function [theSet,realAxis,imaginaryAxis] = mandelbrotSet(start,gridSpacing,last,maxIteration)

    %Define the escape time algorithm
    function escapeTime = escapeTimeAlgorithm(z0)

        escapeTime = 0;
        z = 0;

        while( (abs(z)<=2) && (escapeTime < maxIteration) )
            z = (z + z0)^2;
            escapeTime = escapeTime + 1;
        end

    end

    %Define the imaginary axis
    imaginaryAxis = (imag(start):imag(gridSpacing):imag(last));

    %Define the real axis
    realAxis = (real(start):real(gridSpacing):real(last));

    %Construct the complex plane from the real and imaginary axes
    complexPlane = meshgrid(realAxis,imaginaryAxis) + meshgrid(imaginaryAxis(end:-1:1),realAxis)'.*i;

    %Apply the escape time algorithm to each point in the complex plane
    theSet = arrayfun(@escapeTimeAlgorithm, complexPlane);


    %Draw the set
    pcolor(realAxis,imaginaryAxis,theSet);
    shading flat;

end
