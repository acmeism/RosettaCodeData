import crypto.sha256

const test = ["1AGNa15ZQXAZUgFiqJ2i7Z2DPU2J6hW62i", "1Q1pE5vPGEEMqRcVRMbtBK842Y6Pzo6nK9",
			"1badbadbadbadbadbadbadbadbadbadbad", "1AGNa15ZQXAZUgFiqJ2i7Z2DPU2J6hW62I"]

struct A25 {
	mut:
    data [25]u8
    tmpl []u8 = "123456789ABCDEFGHJKLMNPQRSTUVWXYZabcdefghijkmnopqrstuvwxyz".bytes()
}

fn (a &A25) version() u8 {
    return a.data[0]
}

fn (a &A25) embedded_checksum() [4]u8 {
    mut c := [4]u8{}
    for i in 0 .. 4 {
        c[i] = a.data[21 + i]
    }
    return c
}

fn (a &A25) double_sha256() []u8 {
    h1 := sha256.sum(a.data[0..21])
    h2 := sha256.sum(h1)
    return h2
}

fn (a &A25) compute_checksum() [4]u8 {
    d := a.double_sha256()
    mut c := [4]u8{}
    for i in 0 .. 4 {
        c[i] = d[i]
    }
    return c
}

fn (mut a A25) set58(s []u8) ! {
    for s1 in s {
        mut c := a.tmpl.index(s1)
        if c < 0 { return error("bad char") }
        for j := 24; j >= 0; j-- {
            c += 58 * int(a.data[j])
            a.data[j] = u8(c % 256)
            c /= 256
        }
        if c > 0 { return error("too long") }
    }
    return
}

fn valid_a58(a58 []u8) !bool {
    mut a := A25{}
    a.set58(a58) or { return false }
    if a.version() != 0 { return false }
    return a.embedded_checksum() == a.compute_checksum()
}

fn main() {
	for val in test {
		try := val.bytes()
		match valid_a58(try)! {
			true { println("'${try.bytestr()}' is valid") }
			false { println("'${try.bytestr()}' is not valid") }
		}
	}
}
