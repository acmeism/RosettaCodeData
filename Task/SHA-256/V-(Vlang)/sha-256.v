import crypto.sha256

fn main() {
    println("${sha256.hexhash('Rosetta code')}")

    mut h := sha256.new()
    h.write('Rosetta code'.bytes()) ?
    println('${h.checksum().map(it.hex()).join('')}')
}
