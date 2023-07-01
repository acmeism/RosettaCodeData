let sigma s = seq {
    for c in s do if c = '1' then yield '0' else yield '0'; yield '1'
}
let rec fibwordIterator s = seq { yield s; yield! fibwordIterator (sigma s) }

let goto (x, y) (dx, dy) c n =
    let (dx', dy') =
        if c = '0' then
            match (dx, dy), n with
            | (1,0),0 -> (0,1)  | (1,0),1 -> (0,-1)
            | (0,1),0 -> (-1,0) | (0,1),1 -> (1,0)
            | (-1,0),0 -> (0,-1)| (-1,0),1 -> (0,1)
            | (0,-1),0 -> (1,0) | (0,-1),1 -> (-1,0)
            | _ -> failwith "not possible (c=0)"
        else
            (dx, dy)
    (x+dx, y+dy), (dx', dy')

// How much longer a line is, compared to its thickness:
let factor = 2

let rec draw (x, y) (dx, dy) n = function
| [] -> ()
| z::zs ->
    printf "%d,%d " (factor*(x+dx)) (factor*(y+dy))
    let (xyd, d') = goto (x, y) (dx, dy) z n
    draw xyd d' (n^^^1) zs

// Seq of (width,height). n-th (n>=0) pair is for fibword fractal f(3*n+2)
let wh = Seq.unfold (fun ((w1,h1,n),(w2,h2)) ->
    Some((if n=0 then (w1,h1) else (h1,w1)), ((w2,h2,n^^^1),(2*w2+w1,w2+h2)))) ((1,0,1),(3,1))

[<EntryPoint>]
let main argv =
    let n = (if argv.Length > 0 then int (System.UInt16.Parse(argv.[0])) else 23)
    let (width,height) = Seq.head <| Seq.skip (n/3) wh
    let fibWord = Seq.toList (Seq.item (n-1) <| fibwordIterator ['1'])
    let (viewboxWidth, viewboxHeight) = ((factor*(width+1)), (factor*(height+1)))
    printf """<!DOCTYPE html>
<html><body><svg height="100%%" width="100%%" viewbox="0 0 %d %d">
  <polyline points="0,0 """ viewboxWidth viewboxHeight
    draw (0,0) (0,1) 1 <| Seq.toList fibWord
    printf """" style="fill:white;stroke:red;stroke-width:1" transform="matrix(1,0,0,-1,1,%d)"/>
  Sorry, your browser does not support inline SVG.
</svg></body></html>""" (viewboxHeight-1)
    0
