fn main() {
    str := "a!===b=!=c"
    sep := ["==","!=","="]
    println(ms(str, sep))
}

fn ms(txt string, sep []string) (map[int]string, []string, []string) {
    mut ans, mut extra  := []string{}, []string{}
    mut place := map[int]string{}
    mut temp :=''
    mut vlen := 0

    for slen in sep {if slen.len > vlen {vlen = slen.len}}
	
    for cidx, cval in txt {	
        temp += cval.ascii_str()
        for value in sep {
            if temp.contains(value) && temp.len >= vlen {
                place[cidx] = value
                temp =''
            }
        }
    }

    for tidx, tval in txt {
        for pkey, pval in place {
	    if tidx == pkey {
                ans << ''
                extra << '(' + pval + ')'
	    }
	}
	if sep.any(it.contains(tval.ascii_str())) == false {
	    ans << tval.ascii_str()
	    extra << tval.ascii_str()
        }
    }
    println('Ending indices: $place')
    println('Answer: $ans')
    println('Extra: $extra')
    return place, ans, extra
}
