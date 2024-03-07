% Rosetta Code task rosettacode.org/wiki/Babylonian_spiral

clear all;close all;clc;
% Example usage
fprintf("The first 40 Babylonian spiral points are:\n");
spiral_points = babylonianspiral(40);
for i = 1:size(spiral_points, 1)
    fprintf('(%d, %d) ', spiral_points(i, 1), spiral_points(i, 2));
    if mod(i, 10) == 0
        fprintf('\n');
    end
end

% For plotting the spiral (requires MATLAB plotting functions)
spiral_points = babylonianspiral(10000);
plot(spiral_points(:, 1), spiral_points(:, 2), 'LineWidth', 1);


function points = babylonianspiral(nsteps)
% Get the points for a Babylonian spiral of `nsteps` steps. Origin is at (0, 0)
% with first step one unit in the positive direction along the vertical (y) axis.
% See also: oeis.org/A256111, oeis.org/A297346, oeis.org/A297347

    persistent squarecache;
    if isempty(squarecache)
        squarecache = [];
    end

    if length(squarecache) <= nsteps
        squarecache = [squarecache, arrayfun(@(x) x^2, length(squarecache):nsteps)];
    end

    xydeltas = [0, 0; 0, 1];
    deltaSq = 1;
    for i = 1:nsteps-2
        x = xydeltas(end, 1);
        y = xydeltas(end, 2);
        theta = atan2(y, x);
        candidates = [];
        while isempty(candidates)
            deltaSq = deltaSq + 1;
            for k = 1:length(squarecache)
                a = squarecache(k);
                if a > deltaSq / 2
                    break;
                end
                for j = floor(sqrt(deltaSq)):-1:1
                    b = squarecache(j+1);
                    if a + b < deltaSq
                        break;
                    end
                    if a + b == deltaSq
                        i = k - 1;
                        candidates = [candidates; i, j; -i, j; i, -j; -i, -j; ...
                                                     j, i; -j, i; j, -i; -j, -i];
                    end
                end
            end
        end
        [~, idx] = min(arrayfun(@(n) mod(theta - atan2(candidates(n, 2), candidates(n, 1)), 2*pi), 1:size(candidates, 1)));
        xydeltas = [xydeltas; candidates(idx, :)];
    end

    points = cumsum(xydeltas);
end
