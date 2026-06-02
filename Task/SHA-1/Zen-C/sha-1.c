import "std/crypto/sha1.zc"
import "std/encoding/hex.zc"

fn main() {
    let digest = Sha1::hash("Rosetta Code", 12);
    println "{Hex::encode(digest.bytes, 20)}";
}
