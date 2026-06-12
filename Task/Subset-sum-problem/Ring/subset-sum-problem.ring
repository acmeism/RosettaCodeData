# Project : Subset sum problem

knap = [["alliance", -624],
            ["archbishop", -915],
            ["balm", 397],
            ["bonnet", 452],
            ["brute", 870],
            ["centipede", -658],
            ["cobol", 362],
            ["covariate", 590],
            ["departure", 952],
            ["deploy", 44],
            ["diophantine", 645],
            ["efferent", 54],
            ["elysee", -326],
            ["eradicate", 376],
            ["escritoire", 856],
            ["exorcism", -983],
            ["fiat", 170],
            ["filmy", -874],
            ["flatworm", 503],
            ["gestapo", 915],
            ["infra", -847],
            ["isis", -982],
            ["lindholm", 999],
            ["markham", 475],
            ["mincemeat", -880],
            ["moresby", 756],
            ["mycenae", 183],
            ["plugging", -266],
            ["smokescreen", 423],
            ["speakeasy", -745],
            ["vein", 813]]

knapsack = createDimList([pow(2, len(knap)),len(knap)+2])
knapweight = createDimList([pow(2, len(knap)),len(knap)+2])
lenknap = list(pow(2, len(knap)))

powerset(knap)

func powerset(list)
        n1 = 0
        num = 0
        for i = 2 to (2 << len(list)) - 1 step 2
             n2 = 0
             n1 = n1 + 1
             weight = 0
             for j = 1 to len(list)
                  if i & (1 << j)
                     n2 = n2 + 1
                     knapsack[n1][n2] = list[j][1]
                     weight = weight + list[j][2]
                     knapweight[n1][n2] = list[j][2]
                  ok
             next
             lenknap[n1] = n2+1
             if weight = 0
             see "" + num + ": "
                for p = 1 to lenknap[n1]-1
                      see "{" + knapsack[n1][p] + " " + knapweight[n1][p]+ "}"
                next
                see nl
                num = num + 1
             ok
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
