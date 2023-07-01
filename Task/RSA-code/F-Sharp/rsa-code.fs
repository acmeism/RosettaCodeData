//Nigel Galloway February 12th., 2018
let RSA n g l = bigint.ModPow(l,n,g)
let encrypt = RSA 65537I 9516311845790656153499716760847001433441357I
let m_in = System.Text.Encoding.ASCII.GetBytes "The magic words are SQUEAMISH OSSIFRAGE"|>Array.chunkBySize 16|>Array.map(Array.fold(fun n g ->(n*256I)+(bigint(int g))) 0I)
let n = Array.map encrypt m_in
let decrypt = RSA 5617843187844953170308463622230283376298685I 9516311845790656153499716760847001433441357I
let g = Array.map decrypt n
let m_out = Array.collect(fun n->Array.unfold(fun n->if n>0I then Some(byte(int (n%256I)),n/256I) else None) n|>Array.rev) g|>System.Text.Encoding.ASCII.GetString
printfn "'The magic words are SQUEAMISH OSSIFRAGE' as numbers -> %A\nEncrypted -> %A\nDecrypted -> %A\nAs text -> %A" m_in n g m_out
