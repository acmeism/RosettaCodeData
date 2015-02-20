    function setrgb {
        _.r=$1
        _.g=$2
        _.b=$3
    }
    function grayscale {
        integer x=$(( round( 0.2126*_.r + 0.7152*_.g + 0.0722*_.b ) ))
        _.r=$x
        _.g=$x
        _.b=$x
    }
