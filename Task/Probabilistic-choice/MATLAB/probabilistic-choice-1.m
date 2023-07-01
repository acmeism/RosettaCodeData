function probChoice
    choices = {'aleph' 'beth' 'gimel' 'daleth' 'he' 'waw' 'zayin' 'heth'};
    w = [1/5 1/6 1/7 1/8 1/9 1/10 1/11 1759/27720];
    R = randsample(length(w), 1e6, true, w);
    T = tabulate(R);
    fprintf('Value\tCount\tPercent\tGoal\n')
    for k = 1:size(T, 1)
        fprintf('%6s\t%.f\t%.2f%%\t%.2f%%\n', ...
            choices{k}, T(k, 2), T(k, 3), 100*w(k))
    end
end
