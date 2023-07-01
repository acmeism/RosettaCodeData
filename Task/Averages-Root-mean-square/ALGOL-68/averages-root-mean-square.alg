# Define the rms PROCedure & ABS OPerators for LONG... REAL #
MODE RMSFIELD = #LONG...# REAL;
PROC (RMSFIELD)RMSFIELD rms field sqrt = #long...# sqrt;
INT rms field width = #long...# real width;

PROC crude rms = ([]RMSFIELD v)RMSFIELD: (
  RMSFIELD sum := 0;
  FOR i FROM LWB v TO UPB v DO sum +:= v[i]**2 OD;
  rms field sqrt(sum / (UPB v - LWB v + 1))
);

PROC rms = ([]RMSFIELD v)RMSFIELD: (
# round off error accumulated at standard precision #
  RMSFIELD sum := 0, round off error:= 0;
  FOR i FROM LWB v TO UPB v DO
    RMSFIELD org = sum, prod = v[i]**2;
    sum +:= prod;
    round off error +:= sum - org - prod
  OD;
  rms field sqrt((sum - round off error)/(UPB v - LWB v + 1))
);

main: (
  []RMSFIELD one to ten = (1,2,3,4,5,6,7,8,9,10);

  print(("crude rms(one to ten): ", crude rms(one to ten), new line));
  print(("rms(one to ten): ",       rms(one to ten), new line))
)
