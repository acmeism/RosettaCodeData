import "std/bigint.zc"

fn main() {
    let bi  = BigInt::from_int(1);
    let one = BigInt::from_int(1);
    let count = 0;
    loop {
         println "{bi}";
         bi.add_in_place(&one);
    }
}
