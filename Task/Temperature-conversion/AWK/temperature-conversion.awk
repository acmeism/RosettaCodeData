# syntax: AWK -f TEMPERATURE_CONVERSION.AWK
BEGIN {
    while (1) {
      printf("\nKelvin degrees? ")
      getline K
      if (K ~ /^$/) {
        break
      }
      if (K < 0) {
        print("K must be > 0")
        continue
      }
      printf("K = %.2f\n",K)
      printf("C = %.2f\n",K - 273.15)
      printf("F = %.2f\n",K * 1.8 - 459.67)
      printf("R = %.2f\n",K * 1.8)
    }
    exit(0)
}
