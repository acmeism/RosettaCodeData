typeset -T RGBColor_t=(
    integer r g b
    function to_s {
        printf "%d %d %d" ${_.r} ${_.g} ${_.b}
    }
    function white   { print "255 255 255"; }
    function black   { print "0 0 0"; }
    function red     { print "255 0 0"; }
    function green   { print "0 255 0"; }
    function blue    { print "0 0 255"; }
    function yellow  { print "255 255 0"; }
    function magenta { print "255 0 255"; }
    function cyan    { print "0 255 255"; }
)

typeset -T Bitmap_t=(
    integer height
    integer width
    typeset -a data

    function fill {
        typeset color=$1
        if [[ -z ${color:+set} ]]; then
            print -u2 "error: no fill color specified"
            return 1
        fi
        integer x y
        for ((y=0; y<_.height; y++)); do
            for ((x=0; x<_.width; x++)); do
                _.data[y][x]="$color"
            done
        done
    }

    function setpixel {
        integer x=$1 y=$2
        typeset color=$3
        _.data[y][x]=$color
    }

    function getpixel {
        integer x=$1 y=$2
        print "${_.data[y][x]}"
    }

    function to_s {
        typeset ppm=""
        ppm+="P3"$'\n'
        ppm+="${_.width} ${_.height}"$'\n'
        ppm+="255"$'\n'
        typeset sep
        for ((y=0; y<_.height; y++)); do
            sep=""
            for ((x=0; x<_.width; x++)); do
                ppm+="$sep${_.data[y][x]}"
                sep=" "
            done
            ppm+=$'\n'
        done
        print -- "$ppm"
    }
)

RGBColor_t color
Bitmap_t b=( width=3  height=2 )
b.fill "$(color.white)"
b.setpixel 0 0 "$(color.red)"
b.setpixel 1 0 "$(color.green)"
b.setpixel 2 0 "$(color.blue)"
b.setpixel 0 1 "$(color.yellow)"
b.setpixel 1 1 "$(color.white)"
b.setpixel 2 1 "$(color.black)"
echo "$(b.getpixel 0 0)"
b.to_s
