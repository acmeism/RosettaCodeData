# syntax: GAWK -f KAHAN_SUMMATION.AWK
# converted from C
BEGIN {
    epsilon = 1
    while (1 + epsilon != 1) {
      epsilon /= 2
    }
    arr[1] = a = 1.0
    arr[2] = b = epsilon
    arr[3] = c = -b
    printf("Epsilon   = %18.16g\n",b)
    printf("(a+b)+c   = %18.16f\n",(a+b)+c)
    printf("Kahan sum = %18.16f\n",kahan_sum(arr))
    exit(0)
}
function kahan_sum(nums,  c,i,sum,t,y) {
    for (i=1; i<=length(nums); i++) {
      y = nums[i] - c
      t = sum + y
      c = (t - sum) - y
      sum = t
    }
    return(sum)
}
