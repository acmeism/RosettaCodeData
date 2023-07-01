MODE DATA = CHAR;

PROC merge sort = ([]DATA m)[]DATA: (
    IF LWB m >= UPB m THEN
        m
    ELSE
        INT middle = ( UPB m + LWB m ) OVER 2;
        []DATA left = merge sort(m[:middle]);
        []DATA right = merge sort(m[middle+1:]);
        flex merge(left, right)[AT LWB m]
    FI
);

# FLEX version: A demonstration of FLEX for manipulating arrays #
PROC flex merge = ([]DATA in left, in right)[]DATA:(
    [UPB in left + UPB in right]DATA result;
    FLEX[0]DATA left := in left;
    FLEX[0]DATA right := in right;

    FOR index TO UPB result DO
        # change the direction of this comparison to change the direction of the sort #
        IF LWB right > UPB right THEN
            result[index:] := left;
            stop iteration
        ELIF LWB left > UPB left THEN
            result[index:] := right;
            stop iteration
        ELIF left[1] <= right[1] THEN
            result[index] := left[1];
            left := left[2:]
        ELSE
            result[index] := right[1];
            right := right[2:]
        FI
    OD;
stop iteration:
    result
);

[32]CHAR char array data := "big fjords vex quick waltz nymph";
print((merge sort(char array data), new line));
