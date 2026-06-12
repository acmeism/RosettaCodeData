function issquare( n as integer ) as boolean
    if int(sqr(n))^2=n then return true else return false
end function

dim as integer i, j, nums(1 to 3, 1 to 9) = {{3,4,34,25,9,12,36,56,36},_
 {2,8,81,169,34,55,76,49,7}, {75,121,75,144,35,16,46,35,-1}}, c, d, ii, jj      'pad the last list to make it the same length
redim as integer squares(-1)   'we don't know beforehand how many squares we'll find, so set up a placeholder

while true                     'keep going while there are still squares in the lists
    c = 99999                  'sentinel value
    for i = 1 to 3             'loop through lists
        for j = 1 to 9
            d = nums(i, j)
            if issquare(d) then     'have we found a square?
                if d < c then       'is it the smallest so far?
                    c = d
                    ii = i
                    jj = j
                end if
            end if
        next j
    next i
    if c = 99999 then exit while    'if we didn't find a square, stop looking
    redim preserve squares(0 to ubound(squares)+1)      'update our list
    squares(ubound(squares)) = c
    nums(ii,jj) = 13                'mod the original lists so we don't find that same square again
wend

for i = 0 to ubound(squares)        'output data
    print squares(i);"  ";
next i
