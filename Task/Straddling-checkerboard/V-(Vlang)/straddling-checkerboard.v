const key = "
 8752390146
 ET AON RIS
5BC/FGHJKLM
0PQD.VWXYZU"

const pnt = "you have put on 7.5 pounds since I saw you."

fn main() {
    println(pnt)
    cnt := enc(key, pnt)
    println(cnt)
    println(dec(key, cnt))
}

fn enc(bsg string, psg string) string {
    row := bsg.split("\n")[1..]
    r2d := row[2][..1]
    r3d := row[3][..1]
    mut enc := map[byte]string{}
    mut csg, mut dre, mut num := "", "", ""
    for col := 1; col <= 10; col++ {
        dre = row[0][col].ascii_str()
        enc[row[1][col]] = dre
        enc[row[2][col]] = r2d + dre
        enc[row[3][col]] = r3d + dre
    }
    num = enc[`/`]
    enc.delete(`/`)
    enc.delete(` `)
    for cal in psg.bytes() {
        if cal >= `0` && cal <= `9` { csg += num + cal.ascii_str() }
      else {
            mut ch := cal
            if ch >= `a` && ch <= `z` { ch -= `a` - `A` }
            csg += enc[ch] or { "" }
        }
    }
    return csg
}

fn dec(bsg string, csg string) string {
   row := bsg.split("\n")[1..]
   r2d := row[2][0] - `0`
    r3d := row[3][0] - `0`
    mut cay := [10]int{}
   mut psg := ""
    mut dre, mut bre := rune(0), rune(0)
    mut inr, mut rnr := 0, 0
    for idx in 1 .. 11 {
        cay[int(row[0][idx]) - int(`0`)] = idx
    }
    for inr < csg.len {
        dre = csg[inr] - `0`
        rnr = 0
        match dre {
            r2d { rnr = 2 }
            r3d { rnr = 3 }
            else {
                psg += row[1][cay[int(dre)]].ascii_str()
                inr++
                continue
            }
        }
        inr++
        bre = row[rnr][cay[int(csg[inr] - `0`)]]
      if bre == `/` {
            inr++
            psg += csg[inr].ascii_str()
        }
      else { psg += bre.str() }
        inr++
    }
    return psg
}
