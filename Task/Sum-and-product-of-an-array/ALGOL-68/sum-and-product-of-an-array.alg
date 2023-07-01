main:(
  INT default upb := 3;
  MODE INTARRAY = [default upb]INT;

  INTARRAY array = (1,2,3,4,5,6,7,8,9,10);
  INT sum := 0;
  FOR i FROM LWB array TO UPB array DO
     sum +:= array[i]
  OD;

  # Define the product function #
  PROC int product = (INTARRAY item)INT:
  (
    INT prod :=1;
    FOR i FROM LWB item TO UPB item DO
       prod *:= item[i]
    OD;
    prod
  ) # int product # ;
  printf(($" Sum: "g(0)$,sum,$", Product:"g(0)";"l$,int product(array)))
)
