# syntax: GAWK -f OHALLORAN_NUMBERS.AWK
# converted from BASIC256
BEGIN {
    max_area = 1000
    half_max_area = max_area / 2
    for (i=0; i<=half_max_area-1; i++) {
      arr[i] = 1 # assume all are O'Halloran numbers
    }
    for (l=1; l<=max_area; l++) {
      for (w=1; w<=half_max_area; w++) {
        for (h=1; h<=half_max_area; h++) {
          suma = l*w + l*h + w*h
          if (suma < half_max_area) {
            arr[suma] = 0 # not an O'Halloran number
          }
        }
      }
    }
    for (l=6/2; l<=half_max_area-1; l++) {
      if (arr[l]) {
        printf("%d ",int(l*2))
      }
    }
    printf("\n")
    exit(0)
}
