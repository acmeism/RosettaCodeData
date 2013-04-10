numeric digits 1000             /*just in case the user gets ka-razy. */
say 'enter some numbers to be summed:'
parse pull y
many=words(y)
sum=0
            do j=1 for many
            sum=sum+word(y,j)
            end
say 'sum of' many "numbers = " sum/1
