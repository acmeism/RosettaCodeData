clear all;close all;clc;
format longG;

% Main Script
for h = [5, 10]
    fprintf('Step %d:\n\n', h);
    tabular(15, 'Time', 'Euler', 'Analytic');
    T0 = 100.0;
    t0 = 0;
    t1 = 100;
    T = euler(@(T) -0.07 * (T - 20.0), T0, t0, t1, h);
    for i = 1:length(T)
        t = (i-1) * h;
        analytic = 20.0 + 80.0 * exp(-0.07 * t);
        tabular(15, t, round(T(i), 6), round(analytic, 6));
    end
    fprintf('\n');
end

function T = euler(f, T0, t0, t1, h)
    % EULER A simple implementation of Euler's method for solving ODEs
    % f - function handle for the derivative
    % T0 - initial temperature
    % t0, t1 - start and end times
    % h - step size
    T = T0;
    for t = t0:h:t1
        T(end+1) = T(end) + h * f(T(end));
    end
end

function tabular(width, varargin)
    % TABULAR Prints a series of values in a tabular form
    % width - cell width
    % varargin - variable number of arguments representing cells
    for i = 1:length(varargin)
        fprintf('%-*s', width, num2str(varargin{i}));
    end
    fprintf('\n');
end
