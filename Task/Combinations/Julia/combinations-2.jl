##############################
# COMBINATIONS OF 3 OUT OF 5 #
##############################

# Set n and m
m = 5
n = 3

# Prepare the boundary of the calculation. Only m - n numbers are changing in each position.
max_n = m - n

#Prepare an array for result
result = zeros(Int64, n)

function combinations(pos, val)            # n, max_n and result are visible in the function
    for i = val:max_n                      # from current value to the boundary
        result[pos] = pos + i              # fill the position of result
        if pos < n                         # if combination isn't complete,
           combinations(pos+1, i)         # go to the next position
        else
            println(result)                # combination is complete, print it
        end
   end
end

combinations(1, 0)
end
