# syntax: GAWK -f SANITIZE_USER_INPUT.AWK SANITIZE_USER_INPUT.TXT
{   printf("%-35s",$0)
    if (NF < 2) {
      print("NG both first and last name are required")
      next
    }
    if ($0 ~ /[0-9]/) {
      print("NG numbers not allowed")
      next
    }
    print ($0 ~ /^[a-zA-Z[:punct:]\- ]+$/) ? "OK" : "NG"
}
END {
    exit(0)
}
