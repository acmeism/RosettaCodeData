|x|
x := 1.
value :=
    x caseOf: {
       [1]->['one'].
       [2]->['two'].
       [3]->['three']
    }
    otherwise:['none of them'].
