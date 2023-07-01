# syntax: GAWK -f MOBIUS_FUNCTION.AWK
# converted from Java
BEGIN {
    printf("first 199 terms of the mobius sequence:\n   ")
    for (n=1; n<200; n++) {
      printf("%3d",mobius(n))
      if ((n+1) % 20 == 0) {
        printf("\n")
      }
    }
    exit(0)
}
function mobius(n,  i,j,mu_max) {
    if (n in MU) {
      return(MU[n])
    }
    mu_max = 1000000
    for (i=0; i<mu_max; i++) { # populate array
      MU[i] = 1
    }
    for (i=2; i<=int(sqrt(mu_max)); i++ ) {
      if (MU[i] == 1) {
        for (j=i; j<=mu_max; j+=i) { # for each factor found, swap + and -
          MU[j] *= -i
        }
        for (j=i*i; j<=mu_max; j+=i*i) { # square factor = 0
          MU[j] = 0
        }
      }
    }
    for (i=2; i<=mu_max; i++) {
      if (MU[i] == i) {
        MU[i] = 1
      }
      else if (MU[i] == -i) {
        MU[i] = -1
      }
      else if (MU[i] < 0) {
        MU[i] = 1
      }
      else if (MU[i] > 0) {
        MU[i] = -1
      }
    }
    return(MU[n])
}
