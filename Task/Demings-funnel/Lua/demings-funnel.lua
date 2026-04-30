-- Import the `moses` library, which provides utility functions for functional
-- programming and list operations.
local moses = require("moses")

-- Define a list of x-direction displacements (dx values) used in the experiment.
-- These represent random perturbations or changes applied to a position over time.
local dxs = {
    -0.533, 0.27, 0.859, -0.043, -0.205, -0.127, -0.071, 0.275, 1.251,
    -0.231, -0.401, 0.269, 0.491, 0.951, 1.15, 0.001, -0.382, 0.161, 0.915,
    2.08, -2.337, 0.034, -0.126, 0.014, 0.709, 0.129, -1.093, -0.483, -1.193,
    0.02, -0.051, 0.047, -0.095, 0.695, 0.34, -0.182, 0.287, 0.213, -0.423,
    -0.021, -0.134, 1.798, 0.021, -1.099, -0.361, 1.636, -1.134, 1.315, 0.201,
    0.034, 0.097, -0.17, 0.054, -0.553, -0.024, -0.181, -0.7, -0.361, -0.789,
    0.279, -0.174, -0.009, -0.323, -0.658, 0.348, -0.528, 0.881, 0.021, -0.853,
    0.157, 0.648, 1.774, -1.043, 0.051, 0.021, 0.247, -0.31, 0.171, 0.0, 0.106,
    0.024, -0.386, 0.962, 0.765, -0.125, -0.289, 0.521, 0.017, 0.281, -0.749,
    -0.149, -2.436, -0.909, 0.394, -0.113, -0.598, 0.443, -0.521, -0.799,
    0.087
}
-- Define a list of y-direction displacements (dy values), analogous to `dxs`.
local dys = {
    0.136, 0.717, 0.459, -0.225, 1.392, 0.385, 0.121, -0.395, 0.49, -0.682,
    -0.065, 0.242, -0.288, 0.658, 0.459, 0.0, 0.426, 0.205, -0.765, -2.188,
    -0.742, -0.01, 0.089, 0.208, 0.585, 0.633, -0.444, -0.351, -1.087, 0.199,
    0.701, 0.096, -0.025, -0.868, 1.051, 0.157, 0.216, 0.162, 0.249, -0.007,
    0.009, 0.508, -0.79, 0.723, 0.881, -0.508, 0.393, -0.226, 0.71, 0.038,
    -0.217, 0.831, 0.48, 0.407, 0.447, -0.295, 1.126, 0.38, 0.549, -0.445,
    -0.046, 0.428, -0.074, 0.217, -0.822, 0.491, 1.347, -0.141, 1.23, -0.044,
    0.079, 0.219, 0.698, 0.275, 0.056, 0.031, 0.421, 0.064, 0.721, 0.104,
    -0.729, 0.65, -1.103, 0.154, -1.72, 0.051, -0.385, 0.477, 1.537, -0.901,
    0.939, -0.411, 0.341, -0.411, 0.106, 0.224, -0.947, -1.424, -0.542, -1.032
}

-- Simulates a "funnel" process: applies a sequence of displacements (`dxs`) using
-- a given update rule to track a state variable `x`.

-- At each step:
--   - The current output position is recorded as `x + dx`
--   - The internal state `x` is updated via `rule(x, dx)`

-- Returns the list of observed positions (`rxs`).
local function funnel(dxs, rule)
    local x = 0  -- Initial state (e.g., current position or error)
    local rxs = {}  -- Table to store resulting positions
    for i, dx in ipairs(dxs) do
        rxs[i] = x + dx  -- Observed value = current state + displacement
        x = rule(x, dx)  -- Update internal state using the provided rule
    end
    return rxs
end

-- Computes the sample standard deviation of a list of numbers.
-- Uses the formula: `sqrt( sum((x_i - mean)^2) / N )`

-- Note: This uses population standard deviation (divides by N, not N-1).
local function stddev(xs)
    local m = moses.mean(xs)  -- Compute mean of the input list
    -- Map each element to squared deviation from mean, sum them, divide by count, then
    -- sqrt
    return math.sqrt(moses.sum(moses.map(xs, function (x)
        return (x - m) ^ 2
    end))/(#xs))
end

-- Runs an experiment using a specific update rule.

-- Applies the funnel process independently to `dxs` and `dys`, then prints the
-- mean and standard deviation of the resulting `x` and `y` positions.
local function experiment(label, rule)
    local rxs, rys = funnel(dxs, rule), funnel(dys, rule)
    print(label)
    print("Mean of (x, y): "..string.format("%.8f, %.8f", moses.mean(rxs), moses.mean(rys)))
    print("Standard derivation of (x, y): "..string.format("%.8f, %.8f", stddev(rxs), stddev(rys)))
end

-- Run four experiments with different feedback rules:

-- Rule 1: Reset state to 0 after every step (no memory).
-- This simulates independent measurements with no correction.

-- Rule 2: Set next state to negative of the displacement.
-- Equivalent to: x_{n+1} = -dx_n

-- Rule 3: Next state = -(current state + displacement)
-- This introduces strong negative feedback (over-correction).

-- Rule 4: Next state = current state + displacement (accumulate errors)
-- This is a random walk: x_{n+1} = x_n + dx_n

experiment("Rule 1", function (z, dz)
    return 0
end)
experiment("Rule 2", function (z, dz)
    return -dz
end)
experiment("Rule 3", function (z, dz)
    return -z - dz
end)
experiment("Rule 4", function (z, dz)
    return z + dz
end)
