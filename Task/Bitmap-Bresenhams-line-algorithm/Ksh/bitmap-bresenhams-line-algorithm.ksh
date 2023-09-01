function line {
        typeset x0=$1 y0=$2 x1=$3 y1=$4

        if ((x0 > x1))
        then
                ((dx = x0 - x1)); ((sx = -1))
        else
                ((dx = x1 - x0)); ((sx = 1))
        fi

        if ((y0 > y1))
        then
                ((dy = y0 - y1)); ((sy = -1))
        else
                ((dy = y1 - y0)); ((sy = 1))
        fi

        if ((dx > dy))
        then
                ((err = dx))
        else
                ((err = -dy))
        fi
        ((err /= 2)); ((e2 = 0))

        while :
        do
                echo $x0 $y0
                ((x0 == x1 && y0 == y1)) && return
                ((e2 = err))
                ((e2 > -dx)) && { ((err -= dy)); ((x0 += sx)) }
                ((e2 <  dy)) && { ((err += dx)); ((y0 += sy)) }
        done
}
