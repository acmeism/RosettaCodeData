$n = [BigInt]::Parse("9516311845790656153499716760847001433441357")
$e = [BigInt]::new(65537)
$d = [BigInt]::Parse("5617843187844953170308463622230283376298685")
$plaintextstring = "Hello, Rosetta!"
$plaintext = [Text.ASCIIEncoding]::ASCII.GetBytes($plaintextstring)
[BigInt]$pt = [BigInt]::new($plaintext)
if ($n -lt $pt) {throw "`$n = $n < $pt = `$pt"}
$ct = [BigInt]::ModPow($pt, $e, $n)
"Encoded:  $ct"
$dc = [BigInt]::ModPow($ct, $d, $n)
"Decoded:  $dc"
$decoded = [Text.ASCIIEncoding]::ASCII.GetString($dc.ToByteArray())
"As ASCII: $decoded"
