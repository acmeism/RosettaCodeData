# syntax: GAWK -f DINESMANS_MULTIPLE-DWELLING_PROBLEM.AWK
BEGIN {
    for (Baker=1; Baker<=5; Baker++) {
      for (Cooper=1; Cooper<=5; Cooper++) {
        for (Fletcher=1; Fletcher<=5; Fletcher++) {
          for (Miller=1; Miller<=5; Miller++) {
            for (Smith=1; Smith<=5; Smith++) {
              if (rules() ~ /^1+$/) {
                printf("%d Baker\n",Baker)
                printf("%d Cooper\n",Cooper)
                printf("%d Fletcher\n",Fletcher)
                printf("%d Miller\n",Miller)
                printf("%d Smith\n",Smith)
              }
            }
          }
        }
      }
    }
    exit(0)
}
function rules(  stmt1,stmt2,stmt3,stmt4,stmt5,stmt6,stmt7) {
# The following problem statements may be changed:
#
# Baker, Cooper, Fletcher, Miller, and Smith live on different floors of an apartment house
# that contains only five floors numbered 1 (ground) to 5 (top)
    stmt1 = Baker!=Cooper && Baker!=Fletcher && Baker!=Miller && Baker!=Smith &&
            Cooper!=Fletcher && Cooper!=Miller && Cooper!=Smith &&
            Fletcher!=Miller && Fletcher!=Smith &&
            Miller!=Smith
    stmt2 = Baker != 5                     # Baker does not live on the top floor
    stmt3 = Cooper != 1                    # Cooper does not live on the bottom floor
    stmt4 = Fletcher != 5 && Fletcher != 1 # Fletcher does not live on either the top or the bottom floor
    stmt5 = Miller > Cooper                # Miller lives on a higher floor than does Cooper
    stmt6 = abs(Smith-Fletcher) != 1       # Smith does not live on a floor adjacent to Fletcher's
    stmt7 = abs(Fletcher-Cooper) != 1      # Fletcher does not live on a floor adjacent to Cooper's
    return(stmt1 stmt2 stmt3 stmt4 stmt5 stmt6 stmt7)
}
function abs(x) { if (x >= 0) { return x } else { return -x } }
