use num::bigint::BigInt;
use num::{FromPrimitive, pow};
use std::primitive::bool;

/// Tupper function value maxtrix for graphic
fn tuppermat(kconst: BigInt) -> Vec<[bool; 106]> {
    let mut tmatrix = vec![[true; 106]; 17];
    let bigone: BigInt = BigInt::from_u32(1).unwrap();
    let bigtwo: BigInt = BigInt::from_u32(2).unwrap();
    for i in 0..106 {
        for j in 0..17 {
            let y: BigInt = kconst.clone() + j;
            let mut a: BigInt = y.clone() / 17;
            let mut b: BigInt = y.clone() % 17;
            b += i * 17;
            b = pow(bigtwo.clone(),  b.try_into().unwrap());
            a /= b;
            a %= 2;
            tmatrix[j][105 - i] = a == bigone;
        }
    }
    return tmatrix
}

fn main() {
    let k: BigInt = BigInt::parse_bytes(b"960939379918958884971672962127852754715004339660129306651505519271702802395266424689642842174350718121267153782770623355993237280874144307891325963941337723487857735749823926629715517173716995165232890538221612403238855866184013235585136048828693337902491454229288667081096184496091705183454067827731551705405381627380967602565625016981482083418783163849115590225610003652351370343874461848378737238198224849863465033159410054974700593138339226497249461751545728366702369745461014655997933798537483143786841806593422227898388722980000748404719",
       10).unwrap();
    let bmap = tuppermat(k);
    for line in bmap.iter() {
        for c in line.iter() {
            if *c {
                print!("\u{2588}");
            }
            else {
                print!(" ");
            }
        }
        println!()
    }
}
