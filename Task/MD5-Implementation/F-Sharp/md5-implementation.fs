let fxyz x y z : uint32 = (x &&& y) ||| (~~~x &&& z)
let gxyz x y z : uint32 = (z &&& x) ||| (~~~z &&& y)
let hxyz x y z : uint32 = x ^^^ y ^^^ z
let ixyz x y z : uint32 = y ^^^ (x ||| ~~~z)
let fghi = [ fxyz; gxyz; hxyz; ixyz ] |> List.collect (List.replicate 16)
let g1Idx = id
let g2Idx i = (5 * i + 1) % 16
let g3Idx i = (3 * i + 5) % 16
let g4Idx i = (7 * i) % 16

let gIdxs =
  [ g1Idx; g2Idx; g3Idx; g4Idx ]
  |> List.collect (List.replicate 16)
  |> List.map2 (fun idx func -> func idx) [ 0..63 ]

let s =
  [ [ 7; 12; 17; 22 ]
    [ 5; 9; 14; 20 ]
    [ 4; 11; 16; 23 ]
    [ 6; 10; 15; 21 ] ]
  |> List.collect (List.replicate 4)
  |> List.concat

let k =
  [ 1...64. ] |> List.map (sin
                           >> abs
                           >> ((*) (2. ** 32.))
                           >> floor
                           >> uint32)

type MD5 =
  { a : uint32
    b : uint32
    c : uint32
    d : uint32 }

let initialMD5 =
  { a = 0x67452301u
    b = 0xefcdab89u
    c = 0x98badcfeu
    d = 0x10325476u }

let md5round (msg : uint32 []) { MD5.a = a; MD5.b = b; MD5.c = c; MD5.d = d } i =
  let rotateL32 r x = (x <<< r) ||| (x >>> (32 - r))
  let f = fghi.[i] b c d
  let a' = b + (a + f + k.[i] + msg.[gIdxs.[i]]
                |> rotateL32 s.[i])
  { a = d
    b = a'
    c = b
    d = c }

let md5plus m (bs : byte []) =
  let msg =
    bs
    |> Array.chunkBySize 4
    |> Array.take 16
    |> Array.map (fun elt -> System.BitConverter.ToUInt32(elt, 0))

  let m' = List.fold (md5round msg) m [ 0..63 ]
  { a = m.a + m'.a
    b = m.b + m'.b
    c = m.c + m'.c
    d = m.d + m'.d }

let padMessage (msg : byte []) =
  let msgLen = Array.length msg
  let msgLenInBits = (uint64 msgLen) * 8UL

  let lastSegmentSize =
    let m = msgLen % 64
    if m = 0 then 64
    else m

  let padLen =
    64 - lastSegmentSize + (if lastSegmentSize >= 56 then 64
                            else 0)

  [| yield 128uy
     for i in 2..padLen - 8 do
       yield 0uy
     for i in 0..7 do
       yield ((msgLenInBits >>> (8 * i)) |> byte) |]
  |> Array.append msg

let md5sum (msg : string) =
  System.Text.Encoding.ASCII.GetBytes msg
  |> padMessage
  |> Array.chunkBySize 64
  |> Array.fold md5plus initialMD5
  |> (fun { MD5.a = a; MD5.b = b; MD5.c = c; MD5.d = d } ->
    System.BitConverter.GetBytes a
    |> (fun x -> System.BitConverter.GetBytes b |> Array.append x)
    |> (fun x -> System.BitConverter.GetBytes c |> Array.append x)
    |> (fun x -> System.BitConverter.GetBytes d |> Array.append x))
  |> Array.map (sprintf "%02X")
  |> Array.reduce (+)
