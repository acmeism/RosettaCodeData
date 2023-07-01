# syntax: GAWK -f COMPARE_LENGTH_OF_TWO_STRINGS.AWK
BEGIN {
    main("abcd","123456789")
    main("longer","short")
    main("hello","world")
    exit(0)
}
function main(Sa,Sb,  La,Lb) {
    La = length(Sa)
    Lb = length(Sb)
    if (La > Lb) {
      printf("a>b\n%3d %s\n%3d %s\n\n",La,Sa,Lb,Sb)
    }
    else if (La < Lb) {
      printf("a<b\n%3d %s\n%3d %s\n\n",Lb,Sb,La,Sa)
    }
    else {
      printf("a=b\n%3d %s\n%3d %s\n\n",Lb,Sb,La,Sa)
    }
}
