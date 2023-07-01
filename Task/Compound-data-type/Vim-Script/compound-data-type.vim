function MakePoint(x, y)    " 'Constructor'
    return {"x": a:x, "y": a:y}
endfunction

let p1 = MakePoint(3, 2)
let p2 = MakePoint(-1, -4)

echon "Point 1: x = " p1.x ", y = " p1.y "\n"
echon "Point 2: x = " p2.x ", y = " p2.y "\n"
