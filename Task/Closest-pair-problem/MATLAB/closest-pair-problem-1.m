function [closest,closestpair] = closestPair(xP,yP)

    N = numel(xP);

    if(N <= 3)

        %Brute force closestpair
        if(N < 2)
            closest = +Inf;
            closestpair = {};
        else
            closest = norm(xP{1}-xP{2});
            closestpair = {xP{1},xP{2}};

            for i = ( 1:N-1 )
                for j = ( (i+1):N )
                    if ( norm(xP{i} - xP{j}) < closest )
                        closest = norm(xP{i}-xP{j});
                        closestpair = {xP{i},xP{j}};
                    end %if
                end %for
            end %for
        end %if (N < 2)
    else

        halfN = ceil(N/2);

        xL = { xP{1:halfN} };
        xR = { xP{halfN+1:N} };
        xm = xP{halfN}(1);

        %cellfun( @(p)le(p(1),xm),yP ) is the same as { p ∈ yP : px ≤ xm }
        yLIndicies = cellfun( @(p)le(p(1),xm),yP );

        yL = { yP{yLIndicies} };
        yR = { yP{~yLIndicies} };

        [dL,pairL] = closestPair(xL,yL);
        [dR,pairR] = closestPair(xR,yR);

        if dL < dR
            dmin = dL;
            pairMin = pairL;
        else
            dmin = dR;
            pairMin = pairR;
        end

        %cellfun( @(p)lt(norm(xm-p(1)),dmin),yP ) is the same as
        %{ p ∈ yP : |xm - px| < dmin }
        yS = {yP{ cellfun( @(p)lt(norm(xm-p(1)),dmin),yP ) }};
        nS = numel(yS);

        closest = dmin;
        closestpair = pairMin;

        for i = (1:nS-1)
            k = i+1;

            while( (k<=nS) && (yS{k}(2)-yS{i}(2) < dmin) )

                if norm(yS{k}-yS{i}) < closest
                    closest = norm(yS{k}-yS{i});
                    closestpair = {yS{k},yS{i}};
                end

                k = k+1;
            end %while
        end %for
    end %if (N <= 3)
end %closestPair
