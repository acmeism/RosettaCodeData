# syntax: GAWK -f DEPARTMENT_NUMBERS.AWK
BEGIN {
    print(" # FD PD SD")
    for (fire=1; fire<=7; fire++) {
      for (police=1; police<=7; police++) {
        for (sanitation=1; sanitation<=7; sanitation++) {
          if (rules() ~ /^1+$/) {
            printf("%2d %2d %2d %2d\n",++count,fire,police,sanitation)
          }
        }
      }
    }
    exit(0)
}
function rules(  stmt1,stmt2,stmt3) {
    stmt1 = fire != police && fire != sanitation && police != sanitation
    stmt2 = fire + police + sanitation == 12
    stmt3 = police % 2 == 0
    return(stmt1 stmt2 stmt3)
}
