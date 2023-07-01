import math.big
import strings

struct Result {
    name  string
    size  int
    start int
    end   int
}

fn (r Result) str() string {
    return "${r.name:-7}   ${r.size:2}    ${r.start:3}   ${r.end:3}"
}

fn validate(diagram string) ?[]string {
    mut lines := []string{}
    for mut line in diagram.split("\n") {
        line = line.trim(" \t")
        if line != "" {
            lines << line
        }
    }
    if lines.len == 0 {
        return error("diagram has no non-empty lines!")
    }
    width := lines[0].len
    cols := (width - 1) / 3
    if cols != 8 && cols != 16 && cols != 32 && cols != 64 {
        return error("number of columns should be 8, 16, 32 or 64")
    }
    if lines.len%2 == 0 {
        return error("number of non-empty lines should be odd")
    }
    if lines[0] != "${strings.repeat_string("+--", cols)}+" {
        return error("incorrect header line")
    }
    for i, line in lines {
        if i == 0 {
            continue
        } else if i%2 == 0 {
            if line != lines[0] {
                return error("incorrect separator line")
            }
        } else if line.len != width {
            return error("inconsistent line widths")
        } else if line[0..1] != '|' || line[width-1..width] != '|' {
            return error("non-separator lines must begin and end with '|'")
        }
    }
    return lines
}

fn decode(lines []string) []Result {
    println("Name     Bits  Start  End")
    println("=======  ====  =====  ===")
    mut start := 0
    width := lines[0].len
    mut results := []Result{}
    for i, l in lines {
        if i%2 == 0 {
            continue
        }
        line := l[1..width-1]
        for n in line.split("|") {
            mut name := n
            size := (name.len + 1) / 3
            name = name.trim_space()
            res := Result{name, size, start, start + size - 1}
            results << res
            println(res)
            start += size
        }
    }
    return results
}

fn unpack(results []Result, hex string) {
    println("\nTest string in hex:")
    println(hex)
    println("\nTest string in binary:")
    bin := hex2bin(hex) or {'ERROR'}
    println(bin)
    println("\nUnpacked:\n")
    println("Name     Size  Bit pattern")
    println("=======  ====  ================")
    for res in results {
        println("${res.name:-7}   ${res.size:2}   ${bin[res.start..res.end+1]}")
    }
}

fn hex2bin(hex string) ?string {
    z := big.integer_from_radix(hex, 16)?
    return "${z.binary_str():096}"
}

fn main() {
    diagram := '
        +--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+
         |                      ID                       |
        +--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+
        |QR|   Opcode  |AA|TC|RD|RA|   Z    |   RCODE   |
        +--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+
        |                    QDCOUNT                    |
        +--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+

        |                    ANCOUNT                    |
        +--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+
        |                    NSCOUNT                    |
        +--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+
        |                    ARCOUNT                    |
        +--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+
    '
    lines := validate(diagram)?
    println("Diagram after trimming whitespace and removal of blank lines:\n")
    for line in lines {
        println(line)
    }
    println("\nDecoded:\n")
    results := decode(lines)
    hex := "78477bbf5496e12e1bf169a4" // test string
    unpack(results, hex)
}
