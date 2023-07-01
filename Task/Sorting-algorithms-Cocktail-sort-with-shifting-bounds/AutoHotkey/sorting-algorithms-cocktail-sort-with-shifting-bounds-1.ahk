cocktailShakerSort(A){
    beginIdx := 1
    endIdx := A.Count() - 1
    while (beginIdx <= endIdx) {
        newBeginIdx := endIdx
        newEndIdx := beginIdx
        ii := beginIdx
        while (ii <= endIdx) {
            if (A[ii] > A[ii + 1]) {
                tempVal := A[ii], A[ii] := A[ii+1], A[ii+1] := tempVal
                newEndIdx := ii
            }
            ii++
        }
        endIdx := newEndIdx - 1
        ii := endIdx
        while (ii >= beginIdx) {
            if (A[ii] > A[ii + 1]) {
                tempVal := A[ii], A[ii] := A[ii+1], A[ii+1] := tempVal
                newBeginIdx := ii
            }
            ii--
        }
        beginIdx := newBeginIdx + 1
    }
}
