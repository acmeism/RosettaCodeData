#! /bin/bash
declare -a encodeTable=(
# +   ,   -   .   /   0   1   2   3   4   5   6   7   8   9   :
 62  -1  -1  -1  63  52  53  54  55  56  57  58  59  60  61  -1
# ;   <   =   >   ?   @   A   B   C   D   E   F   G   H   I   J
 -1  -1  -1  -1  -1  -1   0   1   2   3   4   5   6   7   8   9
# K   L   M   N   O   P   Q   R   S   T   U   V   W   X   Y   Z
 10  11  12  13  14  15  16  17  18  19  20  21  22  23  24  25
# [   \   ]   ^   _   `   a   b   c   d   e   f   g   h   i   j
 -1  -1  -1  -1  -1  -1  26  27  28  29  30  31  32  33  34  35
# k   l   m   n   o   p   q   r   s   t   u   v   w   x   y   z
 36  37  38  39  40  41  42  43  44  45  46  47  48  49  50  51
)
function a2b6()
{
    if [ $1 -lt 43 -o $1 -gt 122 ]
    then
        echo -1
    else
        echo ${encodeTable[$(($1-43))]}
    fi
}

function flush() {
    for (( k=2; k>=4-CNT; k-- ))
    do
        (( b8=BUF>>(k*8)&255 ))
        printf -v HEX %x $b8
        printf \\x$HEX
    done
}

while read INPUT
do
    for (( i=0; i<${#INPUT}; i++ ))
    do
        printf -v NUM %d "'${INPUT:$i:1}"
        if (( NUM==61 ))
        then
            flush
            exit 0
        else
            DEC=$( a2b6 $NUM )
            if (( DEC>=0 ))
            then
                (( BUF|=DEC<<6*(3-CNT) ))
                if (( ++CNT==4 ))
                then
                    flush
                    (( CNT=0, BUF=0 ))
                fi
            fi
        fi
    done
done
