    function grayscale {
        RGBColor_t c
        for ((y=0; y<_.height; y++)); do
            for ((x=0; x<_.width; x++)); do
                c.setrgb ${_.data[y][x]}
                c.grayscale
                _.data[y][x]=$(c.to_s)
            done
        done
    }

    function read {
        exec 4<"$1"
        typeset filetype
        read -u4 filetype
        if [[ $filetype != "P3" ]]; then
            print -u2 "error: I can only read P3 type PPM files"
        else
            read -u4 _.width _.height
            integer maxval
            read -u4 maxval
            integer x y r g b
            typeset -a bytes
            for ((y=0; y<_.height; y++)); do
                read -u4 -A bytes
                for ((x=0; x<_.width; x++)); do
                    r=${bytes[3*x+0]}
                    g=${bytes[3*x+1]}
                    b=${bytes[3*x+2]}
                    if (( r > maxval || g > maxval || b > maxval )); then
                        print -u2 "error: invalid color ($r $g $b), max=$maxval"
                        return 1
                    fi
                    _.data[y][x]="$r $g $b"
                done
            done
        fi
        exec 4<&-
    }
