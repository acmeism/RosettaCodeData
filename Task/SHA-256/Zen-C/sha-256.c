import "std/crypto/sha256.zc"

fn main() {
    let hash = Sha256::hash("Rosetta code");
    println "{hash}";
}
