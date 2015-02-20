function probChoice
    choices = {'aleph' 'beth' 'gimel' 'daleth' 'he' 'waw' 'zayin' 'heth'};
    w = [1/5 1/6 1/7 1/8 1/9 1/10 1/11 1759/27720];
    nSamp = 1e6;
    nChoice = length(w);
    R = rand(nSamp, 1);
    wCS = cumsum(w);
    results = zeros(1, nChoice);
    fprintf('Value\tCount\tPercent\tGoal\n')
    for k = 1:nChoice
        choiceKIdxs = R < wCS(k);
        R(choiceKIdxs) = k;
        results(k) = sum(choiceKIdxs);
        fprintf('%6s\t%.f\t%.2f%%\t%.2f%%\n', ...
            choices{k}, results(k), 100*results(k)/nSamp, 100*w(k))
    end
end
