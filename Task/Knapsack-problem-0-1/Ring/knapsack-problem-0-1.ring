# Project : Knapsack problem/0-1

knap = [["map",9,150],
            ["compass",13,35],
            ["water",153,20],
            ["sandwich",50,160],
            ["glucose",15,60],
            ["tin",68,45],
            ["banana",27,60],
            ["apple",39,40],
            ["cheese",23,30],
            ["beer",52,10],
            ["suntan cream",11,70],
            ["camera",32,30],
            ["T-shirt",24,15],
            ["trousers",48,10],
            ["umbrella",73,40],
            ["waterproof trousers",42,70],
            ["waterproof overclothes",43,75],
            ["note-case",22,80],
            ["sunglasses",7,20],
            ["towel",18,12],
            ["socks",4,50],
            ["book",30,10]]
knapsack = createDimList([pow(2, len(knap)),len(knap)+2])
lenknap = list(pow(2, len(knap)))

sacksize = 400
powerset(knap)

for n = 1 to pow(2, len(knap))-2
      for m = n + 1 to pow(2, len(knap))-1
      if knapsack[m][lenknap[m]-1] <= sacksize and
         knapsack[m][lenknap[m]] > knapsack[n][lenknap[n]]
         temp = knapsack[n]
         lentemp = lenknap[n]
         knapsack[n] = knapsack[m]
         knapsack[n+1] = temp
         lenknap[n] = lenknap[m]
         lenknap[n+1] = lentemp
      ok
      next
next

for n = 1 to lenknap[1] - 2
      see knapsack[1][n] + nl
next

see "Total weight = " + knapsack[1][lenknap[1]-1] + nl
see "Total value  = " + knapsack[1][lenknap[1]] + nl

func powerset(list)
        n1 = 0
        for i = 2 to (2 << len(list)) - 1 step 2
             n2 = 0
             n1 = n1 + 1
             weight = 0
             value = 0
             for j = 1 to len(list)
                  if i & (1 << j)
                     n2 = n2 + 1
                     knapsack[n1][n2] = list[j][1]
                     weight = weight + list[j][2]
                     value = value + list[j][3]
                     knapsack[n1][n2+1] = weight
                     knapsack[n1][n2+2] = value
                  ok
             next
             lenknap[n1] = n2+2
         next

func createDimList(dimArray)
        sizeList = len(dimArray)
        newParms = []
        for i = 2 to sizeList
            Add(newParms, dimArray[i])
        next
        alist = list(dimArray[1])
        if sizeList = 1
           return aList
        ok
        for t in alist
              t = createDimList(newParms)
        next
        return alist
