// half adder with XOR and AND
// SUM = A XOR B
// CARRY = A.B
fn half_adder(a: usize, b: usize) -> (usize, usize) {
    return (a ^ b, a & b);
}

// full adder as a combination of half adders
// SUM = A XOR B XOR C
// CARRY = A.B + B.C + C.A
fn full_adder(a: usize, b: usize, c_in: usize) -> (usize, usize) {
    let (s0, c0) = half_adder(a, b);
    let (s1, c1) = half_adder(s0, c_in);
    return (s1, c0 | c1);
}

// A = (A3, A2, A1, A0)
// B = (B3, B2, B1, B0)
// S = (S3, S2, S1, S0)
fn four_bit_adder (
    a: (usize, usize, usize, usize),
    b: (usize, usize, usize, usize)
)
    ->
    // 4 bit output, carry is ignored
    (usize, usize, usize, usize)
{
    // lets have a.0 refer to the rightmost element
    let a = a.reverse();
    let b = b.reverse();

    // i would prefer a loop but that would abstract
    // the "connections of the constructive blocks"
    let (sum, carry) = half_adder(a.0, b.0);
    let out0 = sum;
    let (sum, carry) = full_adder(a.1, b.1, carry);
    let out1 = sum;
    let (sum, carry) = full_adder(a.2, b.2, carry);
    let out2 = sum;
    let (sum, _) = full_adder(a.3, b.3, carry);
    let out3 = sum;
    return (out3, out2, out1, out0);
}

fn main() {
    let a: (usize, usize, usize, usize) = (0, 1, 1, 0);
    let b: (usize, usize, usize, usize) = (0, 1, 1, 0);
    assert_eq!(four_bit_adder(a, b), (1, 1, 0, 0));
    // 0110 + 0110 = 1100
    // 6 + 6 = 12
}

// misc. traits to make our life easier
trait Reverse<A, B, C, D> {
    fn reverse(self) -> (D, C, B, A);
}

// reverse a generic tuple of arity 4
impl<A, B, C, D> Reverse<A, B, C, D> for (A, B, C, D) {
    fn reverse(self) -> (D, C, B, A){
        return (self.3, self.2, self.1, self.0)
    }
}
