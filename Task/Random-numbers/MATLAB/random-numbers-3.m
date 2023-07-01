function randNum = randNorm(mu0,chi2, sz)

    radiusSquared = +Inf;

    while (radiusSquared >= 1)
        u = ( 2 * rand(sz) ) - 1;
        v = ( 2 * rand(sz) ) - 1;

        radiusSquared = u.^2 + v.^2;
    end

    scaleFactor = sqrt( ( -2*log(radiusSquared) )./ radiusSquared );
    randNum = (v .* scaleFactor .* chi2) + mu0;

end
