import strconv
import log

// canonicalize a CIDR block: make sure none of the host bits are set
fn canonicalize(cidr string) string {
	mut l := log.Log{}
	mut binary := ""
	mut ir := 0
	mut num := i64(0)
	mut bin, mut canon := []string{}, []string{}

    // dotted-decimal / bits in network part
    split_arr := cidr.split("/")
    dotted := split_arr[0]
    size := strconv.atoi(split_arr[1]) or {l.fatal('fatal 1')}

   // get IP as binary string
    for n in dotted.split(".") {
        ir = strconv.atoi(n) or {l.fatal('fatal 2')}
        bin << "${ir:08b}"
    }
	
	// replace the host part with all zeros
    binary = bin.join("")[0..size] + "0".repeat(32 - size)

    // convert back to dotted-decimal
    for i := 0; i < binary.len; i += 8 {
        num = strconv.parse_int(binary[i..i + 8], 2, 64) or {l.fatal('fatal 3')}
        canon << "${num}"
    }

    // and return
    return canon.join(".") + "/" + split_arr[1]
}

fn main() {
    tests := ["87.70.141.1/22",
        "36.18.154.103/12",
        "62.62.197.11/29",
        "67.137.119.181/4",
        "161.214.74.21/24",
        "184.232.176.184/18"]

    for test in tests {
        println("${test:-18} -> ${canonicalize(test)}")
    }
}
