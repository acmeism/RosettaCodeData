/* numbers that are equal to the sum of their digits raised to the power 5 */

maximum = 9**5 * 6
total = 0
out = ''
do i = 2 to maximum
    if sum5(i) = i then do
        if out \= '' then out = out || ' + '
        out = out || i
        total = total + i
    end
end
say out || ' = ' || total
exit

sum5: procedure
    arg num
    result = 0
    do i = 1 to length(num)
        result = result + substr(num, i, 1) ** 5
    end
    return result
