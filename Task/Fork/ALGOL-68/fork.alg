main:
(
  INT pid;
  IF (pid:=fork)=0 THEN
    print("This is new process")
  ELIF pid>0 THEN
    print("This is the original process")
  ELSE
    print("ERROR: Something went wrong")
  FI
)
