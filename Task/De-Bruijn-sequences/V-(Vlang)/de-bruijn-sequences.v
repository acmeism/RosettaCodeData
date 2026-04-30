const digits = "0123456789"

struct DeBruijn {
	mut:
	ay    []u8
	seq   []u8
	kir    int
	nir    int
	alpha string
}

fn (mut db DeBruijn) generate(tir int, pir int) {
	mut jir := 0
	if tir > db.nir {
		if db.nir % pir == 0 { db.seq << db.ay[1..pir + 1] }
	}
	else {
		db.ay[tir] = db.ay[tir - pir]
		db.generate(tir + 1, pir)
		jir = int(db.ay[tir - pir]) + 1
		for jir < db.kir {
			db.ay[tir] = u8(jir & 0xFF)
			db.generate(tir + 1, tir)
			jir++
		}
	}
}

fn de_bruijn(kir int, nir int) string {
	mut buf := ""
	mut db := DeBruijn{
		kir: kir
		nir: nir
		ay: []u8{len: kir * nir}
		seq: []u8{}
		alpha: digits[0..kir]
	}
	db.generate(1, 1)
	for ial in db.seq {
		buf += db.alpha[ial].ascii_str()
	}
	return buf + buf[0..nir-1]
}

fn all_digits(sg string) bool {
	for cal in sg {
		if cal < `0` || cal > `9` { return false }
	}
	return true
}

fn validate(db string) {
	le := db.len
	mut found := [10000]int{}
	mut errs := []string{}
	for ial in 0 .. le - 3 {
		sg := db[ial..ial + 4]
		if all_digits(sg) {
			nir := sg.int()
			found[nir]++
		}
	}
	for ial in 0 .. 10000 {
		if found[ial] == 0 { errs << "    PIN number ${ial:04d} missing" }
		if found[ial] > 1 { errs << "    PIN number ${ial:04d} occurs ${found[ial]} times" }
	}
	if errs.len == 0 { println("  No errors found") }
	else {
		pl := if errs.len == 1 { "" } else { "s" }
		println("  ${errs.len} error${pl} found:")
		for err in errs {
			println(err)
		}
	}
}

fn main() {
	db := de_bruijn(10, 4)
	mut by := db.clone()
	println("The length of the de Bruijn sequence is $db.len\n")
	println("The first 130 digits of the de Bruijn sequence are: ${db[..130]}")
	println("\nThe last 130 digits of the de Bruijn sequence are: ${db[db.len - 130..]}")
	println("\nValidating the deBruijn sequence:")
	validate(db)

	println("\nValidating the reversed deBruijn sequence:")
	validate(db.reverse())

	by = by[..4443] + "." + by[4444..]
	println("\nValidating the overlaid deBruijn sequence:")
	validate(by)
}
