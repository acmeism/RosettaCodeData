begin % find the lowest positive n where the difference between n^2 and (n-1)^2 is > 1000 %
    integer requiredDifference;
    requiredDifference := 1000;
    write(  i_w := 1, s_w := 0,
         , "Smallest n where n^2 - (n-1)^2 is > ", requiredDifference
         , " is: ", ( ( requiredDifference + 1 ) div 2 ) + 1
         )
end.
