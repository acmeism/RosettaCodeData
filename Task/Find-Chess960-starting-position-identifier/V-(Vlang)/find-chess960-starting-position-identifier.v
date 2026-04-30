struct ChessPosition {
	mut:
	q []int
	k []int
	b []int
	n []int
	r []int
	err string
}

fn spid(s string) int {
	mut pos := ChessPosition{}
	mut idx, mut n2, mut n1, mut n := 1, 0, 0, 0
	mut light_bishop, mut dark_bishop, mut knights_index, mut q_val := 0, 0, 0, 0
	for i := 0; i < s.len; i++ {
		ch := s[i]
		match ch {
			`Q` { pos.q << idx }
			`K` { pos.k << idx }
			`B` { pos.b << idx }
			`N` { pos.n << idx }
			`R` { pos.r << idx }
			else {
				println("Illegal piece: ${ch.ascii_str()}")
				return 0
			}
		}
		idx++
	}
	if pos.k.len != 1 { pos.err += "There must be exactly one King. " }
	if pos.q.len != 1 {	pos.err += "There must be exactly one Queen. " }
	if pos.b.len != 2 {	pos.err += "There must be exactly two Bishops. " }
	if pos.n.len != 2 {	pos.err += "There must be exactly two Knights. " }
	if pos.r.len != 2 {	pos.err += "There must be exactly two Rooks. " }
	if pos.k.len == 1 && pos.r.len == 2 {
		if pos.k[0] < pos.r[0] || pos.k[0] > pos.r[1] {
			pos.err += "King must be between the Rooks."
		}
	}
	if pos.b.len == 2 {
		if (pos.b[0] - pos.b[1]) % 2 == 0 {
			pos.err += "Bishops must be on opposite colors."
		}
	}
	if pos.err != "" {
		println(pos.err)
		return 0
	}
	for i_knight := 0; i_knight < 2; i_knight++ {
		orig_n := pos.n[i_knight]
		n = orig_n
		if orig_n > pos.q[0] { n -= 1 }
		for j_bishop := 0; j_bishop < 2; j_bishop++ {
			if orig_n > pos.b[j_bishop] { n -= 1 }
		}
		pos.n[i_knight] = n
	}
	pos.n[0] -= 1
	pos.n[1] -= 1
	if pos.n[0] > pos.n[1] { pos.n[0], pos.n[1] = pos.n[1], pos.n[0] }
	n1 = 0
	n2 = 1
	knights_index = -1
	for idx_pair := 0; idx_pair < 10; idx_pair++ {
		if n1 == pos.n[0] && n2 == pos.n[1] {
			knights_index = idx_pair
			break
		}
		n2++
		if n2 > 4 {
			n1++
			n2 = n1 + 1
		}
	}
	if knights_index == -1 {
		println("Error: knights pair not found")
		return 0
	}
	q_val = pos.q[0] - 1
	for i_bishop := 0; i_bishop < 2; i_bishop++ {
		if q_val >= pos.b[i_bishop] - 1 {
			q_val -= 1
		}
	}
	for i_bishop2 := 0; i_bishop2 < 2; i_bishop2++ {
		b_val := pos.b[i_bishop2] - 1
		if b_val & 1 == 1 { light_bishop = b_val / 2 }
		else { dark_bishop = b_val / 2 }
	}
	return 96 * knights_index + 16 * q_val + 4 * dark_bishop + light_bishop
}
fn main() {
	positions := ["QNRBBNKR", "RNBQKBNR", "RQNBBKRN", "RNQBBKRN"]
	for i := 0; i < positions.len; i++ {
		pos := positions[i]
		println("$pos -> ${spid(pos)}")
	}
}
