x = hailstone(27);
fprintf('hailstone(27): %d %d %d %d ... %d %d %d %d\nnumber of elements: %d\n', x(1:4), x(end-3:end), numel(x))
