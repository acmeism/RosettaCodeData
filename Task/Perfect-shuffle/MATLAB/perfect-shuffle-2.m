Result=[]; %vector to store results
Q=[8, 24, 52, 100, 1020, 1024, 10000]; %queries
for n=Q %for each query
    Same=0; %initialize comparison
    T=0; %initialize number of shuffles
    while ~Same %while the result is not the original query
        T=T+1; %one more shuffle
        R=PerfectShuffle(n,T); %result of shuffling the query
        Same=~(any(R-(1:n))); %same vector as the query
    end %when getting the same vector
    Result=[Result;T]; %collect results
end
disp([Q', Result])
