function  stdDevEval(n)
disp(sqrt(sum((n-sum(n)/length(n)).^2)/length(n)));
end
