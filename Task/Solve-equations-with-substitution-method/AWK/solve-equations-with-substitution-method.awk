# syntax: GAWK -f SOLVE_EQUATIONS_WITH_SUBSTITUTION_METHOD.AWK
BEGIN {
    main("3,1,-1","2,-3,-19")
    exit(0)
}
function main(s1,s2,  arr,e1,e2,result_x,result_y,r1,r2,x1,x2,y1,y2) {
    split(s1,e1,",")
    split(s2,e2,",")
    x1 = e1[1]
    y1 = e1[2]
    r1 = e1[3]
    x2 = e2[1]
    y2 = e2[2]
    r2 = e2[3]
    arr[1] = x1
    arr[2] = -y1
    arr[3] = r1
    result_y = ((arr[1]*r2) - (x2*arr[3])) / ((x2*arr[2]) + (arr[1]*y2))
    result_x = (r1 - (y1*result_y)) / x1
    printf("x = %g\ny = %g\n",result_x,result_y)
}
