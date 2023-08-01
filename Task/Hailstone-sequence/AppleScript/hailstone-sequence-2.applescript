-- Number(s) below 100,000 giving the longest sequence length, using the hailstoneSequence(n) handler above.
set nums to {}
set longestLength to 1
repeat with n from 2 to 99999
    set thisLength to (count hailstoneSequence(n))
    if (thisLength < longestLength) then
    else if (thisLength > longestLength) then
        set nums to {n}
        set longestLength to thisLength
    else
        set end of nums to n
    end if
end repeat
return {|number(s) giving longest sequence length|:nums, |length of sequence|:longestLength}
