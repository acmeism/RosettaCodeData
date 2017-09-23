# syntax: GAWK -f KNAPSACK_PROBLEM_CONTINUOUS.AWK
BEGIN {
#   arr["item,weight,price"]
    arr["beef,3.8,36"]
    arr["pork,5.4,43"]
    arr["ham,3.6,90"]
    arr["greaves,2.4,45"]
    arr["flitch,4.0,30"]
    arr["brawn,2.5,56"]
    arr["welt,3.7,67"]
    arr["salami,3.0,95"]
    arr["sausage,5.9,98"]
    for (i in arr) {
      split(i,tmp,",")
      arr[i] = tmp[3] / tmp[2] # $/unit
    }
    sack_size = 15 # kg
    PROCINFO["sorted_in"] = "@val_num_desc"
    print("item    weight  price $/unit")
    for (i in arr) {
      if (total_weight >= sack_size) {
        break
      }
      split(i,tmp,",")
      weight = tmp[2]
      if (total_weight + weight <= sack_size) {
        price = tmp[3]
        msg = "all"
      }
      else {
        weight = sack_size - total_weight
        price = weight * arr[i]
        msg = weight " of " tmp[2]
      }
      printf("%-7s %6.2f %6.2f %6.2f take %s\n",tmp[1],weight,tmp[3],arr[i],msg)
      total_items++
      total_price += price
      total_weight += weight
    }
    printf("%7d %6.2f %6.2f total\n",total_items,total_weight,total_price)
    exit(0)
}
