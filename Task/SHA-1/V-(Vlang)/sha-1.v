import crypto.sha1

fn main() {
    println("${sha1.hexhash('Rosetta Code')}")//Rosetta code

    mut h := sha1.new()
    h.write('Rosetta Code'.bytes()) ?
    println('${h.checksum().map(it.hex()).join('')}')
}
