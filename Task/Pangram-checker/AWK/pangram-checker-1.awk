#!/usr/bin/awk -f
BEGIN {
   allChars="ABCDEFGHIJKLMNOPQRSTUVWXYZ";
   print isPangram("The quick brown fox jumps over the lazy dog.");
   print isPangram("The quick brown fo.");
}

function isPangram(string) {
    delete X;
    for (k=1; k<length(string); k++) {
        X[toupper(substr(string,k,1))]++;  # histogram
    }
    for (k=1; k<=length(allChars); k++) {
        if (!X[substr(allChars,k,1)]) return 0;
    }	
    return 1;
}
