function piEstimate = monteCarloPi(numDarts)

    piEstimate = 4*sum( sum(rand(numDarts,2).^2,2) <= 1 )/numDarts;

end
