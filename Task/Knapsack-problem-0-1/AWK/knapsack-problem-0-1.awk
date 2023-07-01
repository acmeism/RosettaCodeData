# syntax: GAWK -f KNAPSACK_PROBLEM_0-1.AWK
BEGIN {
#   arr["item,weight"] = value
    arr["map,9"] = 150
    arr["compass,13"] = 35
    arr["water,153"] = 200
    arr["sandwich,50"] = 160
    arr["glucose,15"] = 60
    arr["tin,68"] = 45
    arr["banana,27"] = 60
    arr["apple,39"] = 40
    arr["cheese,23"] = 30
    arr["beer,52"] = 10
    arr["suntan cream,11"] = 70
    arr["camera,32"] = 30
    arr["T-shirt,24"] = 15
    arr["trousers,48"] = 10
    arr["umbrella,73"] = 40
    arr["waterproof trousers,42"] = 70
    arr["waterproof overclothes,43"] = 75
    arr["note-case,22"] = 80
    arr["sunglasses,7"] = 20
    arr["towel,18"] = 12
    arr["socks,4"] = 50
    arr["book,30"] = 10
    sack_size = 400 # dag
    PROCINFO["sorted_in"] = "@val_num_desc"
    for (i in arr) {
      if (total_weight >= sack_size) {
        break
      }
      split(i,tmp,",")
      weight = tmp[2]
      if (total_weight + weight <= sack_size) {
        printf("%s\n",tmp[1])
        total_items++
        total_value += arr[i]
        total_weight += weight
      }
    }
    printf("items=%d (out of %d) weight=%d value=%d\n",total_items,length(arr),total_weight,total_value)
    exit(0)
}
