type
  tdpa   = array[0..2] of LongWord; // 0 = deficient,1= perfect,2 = abundant
var
 ..
  DpaCnt       : tdpa;
..
in function Check
    // SumOfProperDivs
    s := DivSumField[i]-i;
    //in Pascal boolean true == 1/false == 0
    inc(DpaCnt[Ord(s>=i)-Ord(s<=i)+1]);
