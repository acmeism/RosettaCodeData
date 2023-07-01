BEGIN {
    DEBUG = 0
    n = 2^64
    nn = sprintf("%.0f", n)
    printf "2^64 * 2^64 = %.0f\n", multiply(nn, nn)
    printf "2^64 * 2^64 = %.0f\n", n*n
    exit
}

function multiply(x, y,     len_x,len_y,ax,ay,j,m,c,i,k,d,v,res,mul,result) {
    len_x = split_reverse(x, ax)
    len_y = split_reverse(y, ay)
    print_array(ax)
    print_array(ay)
    for (j=1; j<=len_y; j++) {
        m = ay[j]
        c = 0
        i = j - 1
        for (k=1; k<=len_x; k++) {
            d = ax[k]
            i++
            v = res[i]
            if (v == "") {
                append_array(res, 0)
                v = 0
            }
            mul = v + c + d*m
            c = int(mul / 10)
            v = mul % 10
            res[i] = v
        }
        append_array(res, c)
    }
    print_array(res)
    result = reverse_join(res)
    sub(/^0+/, "", result)
    return result
}

function split_reverse(x, a,        a_x) {
    split(x, a_x, "")
    return reverse_array(a_x, a)
}

function reverse_array(a,b,         len,i) {
    len = length_array(a)
    for (i in a) {
        b[1+len-i] = a[i]
    }
    return len
}

function length_array(a,        len,i) {
    len = 0
    for (i in a) len++
    return len
}

function append_array(a, value,     len) {
    len = length_array(a)
    a[++len] = value
}

function reverse_join(a,        len,str,i) {
    len = length_array(a)
    str = ""
    for (i=len; i>=1; i--) {
        str = str a[i]
    }
    return str
}

function print_array(a,         len,i) {
    if (DEBUG) {
        len = length_array(a)
        print "length=" len
        for (i=1; i<=len; i++) {
            printf("%s ", i%10)
        }
        print ""
        for (i=1; i<=len; i++) {
            #print i " " a[i]
            printf("%s ", a[i])
        }
        print ""
        print "===="
    }
}
