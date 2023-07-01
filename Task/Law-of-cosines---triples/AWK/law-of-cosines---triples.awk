# syntax: GAWK -f LAW_OF_COSINES_-_TRIPLES.AWK
# converted from C
BEGIN {
    description[1] = "90 degrees, a*a + b*b = c*c"
    description[2] = "60 degrees, a*a + b*b - a*b = c*c"
    description[3] = "120 degrees, a*a + b*b + a*b = c*c"
    split("0,1,-1",coeff,",")
    main(13,1,0)
    main(1000,0,1) # 10,000 takes too long
    exit(0)
}
function main(max_side_length,show_sides,no_dups,  a,b,c,count,k) {
    printf("\nmaximum side length: %d\n",max_side_length)
    for (k=1; k<=3; k++) {
      count = 0
      for (a=1; a<=max_side_length; a++) {
        for (b=1; b<=a; b++) {
          for (c=1; c<=max_side_length; c++) {
            if (a*a + b*b - coeff[k] * a*b == c*c) {
              if (no_dups && (a == b || b == c)) {
                continue
              }
              count++
              if (show_sides) {
                printf("  %d %d %d\n",a,b,c)
              }
            }
          }
        }
      }
      printf("%d triangles, %s\n",count,description[k])
    }
}
