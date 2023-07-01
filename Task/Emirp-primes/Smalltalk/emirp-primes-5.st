Transcript
    show:'first 20 emirps: ';
    showCR:(listOfEmirps take:20) asArray.

Transcript
    show:'emirps between 7700 and 8000 are: ';
    showCR:((7700 to:8000) select:[:n | n isPrime and:[isEmirp value:n]]).

Transcript
    show:'10000''th emirp: ';
    showCR:(listOfEmirps nth:10000).
