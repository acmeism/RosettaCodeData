num=5
let num=num+1          # Increment the number
let "num = num + 1"    # Increment again. (We can use spaces inside quotes)
((num = num + 1))      # This time we use doublebrackets
let num+=1             # This time we use +=
let "num += 1"
((num += 1))
