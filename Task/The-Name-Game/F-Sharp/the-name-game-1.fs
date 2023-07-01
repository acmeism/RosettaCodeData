// The Name Game. Nigel Galloway: March 28th., 2018
let   fN g =
  let fG α β γ = printfn "%s, %s, bo-%s\nBanana-fana fo-%s\nFee-fi-mo-%s\n%s!" g g α β γ g
  match g.ToLower().[0] with
  |'a'|'e'|'i'|'o'|'u' as n  -> fG ("b"+(string n)+g.[1..]) ("f"+(string n)+g.[1..]) ("m"+(string n)+g.[1..])
  |'b'                       -> fG (g.[1..]) ("f"+g.[1..]) ("m"+g.[1..])
  |'f'                       -> fG ("b"+g.[1..]) (g.[1..]) ("m"+g.[1..])
  |'m'                       -> fG ("b"+g.[1..]) ("f"+g.[1..]) (g.[1..])
  |_                         -> fG ("b"+g.[1..]) ("f"+g.[1..]) ("m"+g.[1..])
