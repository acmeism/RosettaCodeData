function [New]=PerfectShuffle(Nitems, Nturns)
    if mod(Nitems,2)==0 %only if even number
        X=1:Nitems; %define deck
        for c=1:Nturns %defines one shuffle
            X=reshape(X,Nitems/2,2)'; %split the deck in two and stack halves
            X=X(:)'; %mix the halves
        end
        New=X; %result of multiple shufflings
    end
