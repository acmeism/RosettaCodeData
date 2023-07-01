    function s = count_jewels(stones,jewels)
    s=0;
    for c=jewels
        s=s+sum(c==stones);
    end
    %!test
    %! assert(count_jewels('aAAbbbb','aA'),3)
    %!test
    %! assert(count_jewels('ZZ','z'),0)
