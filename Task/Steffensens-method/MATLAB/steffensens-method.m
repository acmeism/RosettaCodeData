clear all;close all;clc;
tol = 0.00000001; iters = 1000; stepsize = 0.1;
test_steffensen(tol, iters, stepsize);


% Aitken's extrapolation
function p = aitken(f, p0)
    p1 = f(p0);
    p2 = f(p1);
    p = p0 - (p1 - p0)^2 / (p2 - 2 * p1 + p0);
end

% Steffensen's method using Aitken
function p = steffensen_aitken(f, pinit, tol, maxiter)
    p0 = pinit;
    p = aitken(f, p0);
    iter = 1;
    while abs(p - p0) > tol && iter < maxiter
        p0 = p;
        p = aitken(f, p0);
        iter = iter + 1;
    end
    if abs(p - p0) > tol
        p = NaN;
    end
end

% deCasteljau function
function result = deCasteljau(c0, c1, c2, t)
    s = 1.0 - t;
    result = s * (s * c0 + t * c1) + t * (s * c1 + t * c2);
end

% Helper functions
function result = xConvexLeftParabola(t)
    result = deCasteljau(2, -8, 2, t);
end

function result = yConvexRightParabola(t)
    result = deCasteljau(1, 2, 3, t);
end

function result = implicit_equation(x, y)
    result = 5 * x^2 + y - 5;
end

% Main function
function result = f(t)
    if isnan(t) || isinf(t)
        result = NaN;
    else
        result = implicit_equation(xConvexLeftParabola(t), yConvexRightParabola(t)) + t;
    end
end

% Test example
function test_steffensen(tol, iters, stepsize)
    if nargin < 1
        tol = 0.00000001;
    end
    if nargin < 2
        iters = 1000;
    end
    if nargin < 3
        stepsize = 0.1;
    end

    for t0 = 0:stepsize:1.1
        fprintf('t0 = %f : ', t0);
        t = steffensen_aitken(@f, t0, tol, iters);
        if isnan(t)
            fprintf('no answer\n');
        else
            x = xConvexLeftParabola(t);
            y = yConvexRightParabola(t);
            if abs(implicit_equation(x, y)) <= tol
                fprintf('intersection at (%f, %f)\n', x, y);
            else
                fprintf('spurious solution\n');
            end
        end
    end
end
