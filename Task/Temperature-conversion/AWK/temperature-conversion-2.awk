# usage: gawk -f temperature_conversion.awk  input.txt -

BEGIN     { print("# Temperature conversion\n") }
BEGINFILE { print "# reading", FILENAME
            if( FILENAME=="-" ) print "# Please enter temperature values in K:\n"
          }

!NF       { exit }

          { print "Input:" $0 }
$1<0      { print("K must be >= 0\n"); next }
          { K = 0+$1
            printf("K = %8.2f Kelvin degrees\n",K)
            printf("C = %8.2f\n",  K - 273.15)
            printf("F = %8.2f\n",  K * 1.8 - 459.67)
            printf("R = %8.2f\n\n",K * 1.8)
          }

END       { print("# Bye.") }
