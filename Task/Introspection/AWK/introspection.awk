# syntax: GAWK -f INTROSPECTION.AWK
BEGIN {
    if (PROCINFO["version"] < "4.1.0") {
      print("version is too old")
      exit(1)
    }
    bloop = -1
    if (PROCINFO["identifiers"]["abs"] == "user" && bloop != "") {
      printf("bloop = %s\n",bloop)
      printf("abs(bloop) = %s\n",abs(bloop))
    }
    exit(0)
}
function abs(x) { if (x >= 0) { return x } else { return -x } }
