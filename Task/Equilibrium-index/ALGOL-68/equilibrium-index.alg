MODE YIELDINT = PROC(INT)VOID;

PROC gen equilibrium index = ([]INT arr, YIELDINT yield)VOID:
(
    INT sum := 0;
    FOR i FROM LWB arr TO UPB arr DO
        sum +:= arr[i]
    OD;

    INT left:=0, right:=sum;
    FOR i FROM LWB arr TO UPB arr DO
        right -:= arr[i];
        IF left = right THEN yield(i) FI;
        left +:= arr[i]
    OD
);

test:(
  []INT arr = []INT(-7, 1, 5, 2, -4, 3, 0)[@0];
# FOR INT index IN # gen equilibrium index(arr, # ) DO ( #
##   (INT index)VOID:
     print(index)
# OD # );
  print(new line)
)
