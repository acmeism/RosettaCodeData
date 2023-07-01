// Parse IP addresses: Nigel Galloway. May 29th., 2021
open System.Text.RegularExpressions
type ipv6= Complete |Composite |Compressed |CompressedComposite
let ip4n,ip6i,ip6g,ip6e,ip6l=let n,g="[0-9a-fA-F]{1,4}","(25[0-5])|(2[0-4]\d)|(1\d\d)|([1-9]?[0-9])" in (
  sprintf "^(%s)\.(%s)\.(%s)\.(%s)$" g g g g, sprintf "^(%s):(%s):(%s):(%s):(%s):(%s):(%s):(%s)$" n n n n n n n n,
  sprintf "^((%s):)?((%s):)?((%s):)?((%s):)?((%s):)?((%s):)?(^|%s)::(%s|$)(:(%s))?(:(%s))?(:(%s))?(:(%s))?(:(%s))?(:(%s))?$" n n n n n n n n n n n n n n,
  sprintf "^(%s):(%s):(%s):(%s):(%s):(%s):(%s)\.(%s)\.(%s)\.(%s)$" n n n n n n g g g g,
  sprintf "^((%s):)?((%s):)?((%s):)?((%s):)?(^|%s)::((%s):)?((%s):)?((%s):)?((%s):)?((%s):)?(%s)\.(%s)\.(%s)\.(%s)$" n n n n n n n n n n g g g g)
let mn,mi,mg,me,ml=[2;4;6;8;10;12;13], [14..2..26], [2;4;6;8;9], [11..2..19], [20..5..35]
let     fN(n:Match) g=g|>List.filter(fun(g:int)->n.Groups.[g].Length>0)
let     fI n (g:Match)=n|>List.fold(fun Σ (n:int)->(Σ<<<16)+((int>>bigint)(sprintf "0x%s" g.Groups.[n].Value)))0I
let rec fG n g=let a="0123456789abcdef" in match bigint.DivRem(n,16I) with (n,r) when n=0I->a.[int r]::g|>Array.ofList|>System.String |(n,r)->fG n (a.[int r]::g)
let     fE(m:Match) n g=(fN m n,fN m g)
let     fL n (g:Match)=n|>List.fold(fun Σ (n:int)->(Σ<<<8)+int(g.Groups.[n].Value))0
let (|IP4 |_|) n=let g=Regex.Match(n,ip4n) in if g.Success then Some(fL [1..5..16] g) else None
let (|IP6n|_|) i=let g=Regex.Match(i,ip6i) in if g.Success then Some(fI [1..8] g) else None
let (|IP6i|_|) g=let g=Regex.Match(g,ip6g) in if g.Success then let n,l=fE g mn mi in (if n.Length+l.Length<8 then Some(((fI n g)<<<((8-n.Length)*16))+(fI l g)) else None) else None
let (|IP6g|_|) e=let g=Regex.Match(e,ip6e) in if g.Success then Some(((fI [1..6] g)<<<32)+bigint(fL [7..5..22] g)) else None
let (|IP6e|_|) l=let g=Regex.Match(l,ip6l) in if g.Success then let n,l=fE g mg me in (if n.Length+l.Length<6 then Some(((fI n g)<<<((8-n.Length)*16))+((fI l g)<<<32)+bigint(fL ml g)) else None) else None
let (|IP6l|_|) n=match n with IP6n n->Some(Complete,fG n []) |IP6i n->Some(Compressed,fG n []) |IP6g n->Some(Composite,fG n []) |IP6e n->Some(CompressedComposite,fG n []) |_->None
let (|IP4p|_|) n=let g=Regex.Match(n,"^(.+):(\d{1,4})$") in if g.Success then match g.Groups.[1].Value with IP4 n->Some(n,int g.Groups.[2].Value) |_->None else None
let (|IP6p|_|) n=let g=Regex.Match(n,"^\[(.+)\]:(\d{1,4})$") in if g.Success then match g.Groups.[1].Value with IP6l n->Some(n,int g.Groups.[2].Value) |_->None else None
let pIP n=match n with IP6p((t,g),p)->printfn "%s is a %A IPv6 address value 0x%s using port %d" n t g p
                      |IP4 g->printfn "%s is an IPv4 address value %0x" n g
                      |IP6l(t,g)->printfn "%s is a %A IPv6 address value 0x%s" n t g
                      |IP4p(g,p)->printfn "%s is an IPv4 address value %0x using port %d" n g p
                      |_->printfn "%s not matched" n

["127.0.0.1";"127.0.0.1:80";"2605:2700:0:3::4713:93e3";"::1";"[::1]:80";"2605:2700:0:3::4713:93e3";"[2605:2700:0:3::4713:93e3]:80";
  "::ffff:127.0.0.1";"1:2:3:4:5:6:7:8";"1:2:3:4:5:6:7:8:9";"1:2:3:4:5:6:127.0.0.1"]|>List.iter pIP
