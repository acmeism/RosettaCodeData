PROC opt merge sort = ([]REF DATA m)[]REF DATA: (
    IF LWB m >= UPB m THEN
        m
    ELSE
        INT middle = ( UPB m + LWB m ) OVER 2;
        []REF DATA left = opt merge sort(m[:middle]);
        []REF DATA right = opt merge sort(m[middle+1:]);
        opt merge(left, right)[AT LWB m]
    FI
);

PROC opt merge = ([]REF DATA left, right)[]REF DATA:(
    [UPB left - LWB left + 1 + UPB right - LWB right + 1]REF DATA result;
    INT index left:=LWB left, index right:=LWB right;

    FOR index TO UPB result DO
        # change the direction of this comparison to change the direction of the sort #
        IF index right > UPB right THEN
            result[index:] := left[index left:];
            stop iteration
        ELIF index left > UPB left THEN
            result[index:] := right[index right:];
            stop iteration
        ELIF left[index left] <= right[index right] THEN
            result[index] := left[index left]; index left +:= 1
        ELSE
            result[index] := right[index right]; index right +:= 1
        FI
    OD;
stop iteration:
    result
);

# create an array of pointers to the data being sorted #
[UPB char array data]REF DATA data; FOR i TO UPB char array data DO data[i] := char array data[i] OD;

[]REF CHAR result = opt merge sort(data);
FOR i TO UPB result DO print((result[i])) OD; print(new line)
