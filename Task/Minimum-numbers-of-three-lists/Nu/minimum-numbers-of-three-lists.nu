const Numbers1 = [5 45 23 21 67]
const Numbers2 = [43 22 78 46 38]
const Numbers3 = [9 98 12 98 53]

[$Numbers1 $Numbers2 $Numbers3] | each { enumerate | transpose -r -d | into record} | math min
