#SingleInstance, Force
#NoEnv
SetBatchLines, -1

pToken := Gdip_Startup()
global pBitmap := Gdip_CreateBitmap(500, 500)
drawLine(100,50,400,400)
Gdip_SaveBitmapToFile(pBitmap, A_ScriptDir "\linetest.png")
Gdip_DisposeImage(pBitmap)
Gdip_Shutdown(pToken)
Run, % A_ScriptDir "\linetest.png"
ExitApp

plot(x, y, c) {
    A := DecToBase(255 * c, 16)
    Gdip_SetPixel(pBitmap, x, y, "0x" A "000000")
}

; integer part of x
ipart(x) {
    return x // 1
}

rnd(x) {
    return ipart(x + 0.5)
}

; fractional part of x
fpart(x) {
    if (x < 0)
        return 1 - (x - floor(x))
    return x - floor(x)
}

rfpart(x) {
    return 1 - fpart(x)
}

drawLine(x0,y0,x1,y1) {
    steep := abs(y1 - y0) > abs(x1 - x0)

    if (steep) {
        temp := x0, x0 := y0, y0 := temp
        temp := x1, x1 := y1, y1 := temp
    }
    if (x0 > x1 then) {
        temp := x0, x0 := x1, x1 := temp
        temp := y0, y0 := y1, y1 := temp
    }

    dx := x1 - x0
    dy := y1 - y0
    gradient := dy / dx

    ; handle first endpoint
    xend := rnd(x0)
    yend := y0 + gradient * (xend - x0)
    xgap := rfpart(x0 + 0.5)
    xpxl1 := xend ; this will be used in the main loop
    ypxl1 := ipart(yend)
    if (steep) {
        plot(ypxl1,   xpxl1, rfpart(yend) * xgap)
        plot(ypxl1+1, xpxl1,  fpart(yend) * xgap)
    }
    else {
        plot(xpxl1, ypxl1  , rfpart(yend) * xgap)
        plot(xpxl1, ypxl1+1,  fpart(yend) * xgap)
    }
    intery := yend + gradient ; first y-intersection for the main loop

    ; handle second endpoint
    xend := rnd(x1)
    yend := y1 + gradient * (xend - x1)
    xgap := fpart(x1 + 0.5)
    xpxl2 := xend ;this will be used in the main loop
    ypxl2 := ipart(yend)
    if (steep) {
        plot(ypxl2  , xpxl2, rfpart(yend) * xgap)
        plot(ypxl2+1, xpxl2,  fpart(yend) * xgap)
    }
    else {
        plot(xpxl2, ypxl2,  rfpart(yend) * xgap)
        plot(xpxl2, ypxl2+1, fpart(yend) * xgap)
    }

    ; main loop
    while (x := xpxl1 + A_Index) < xpxl2 {
        if (steep) {
            plot(ipart(intery)  , x, rfpart(intery))
            plot(ipart(intery)+1, x,  fpart(intery))
        }
        else {
            plot(x, ipart (intery),  rfpart(intery))
            plot(x, ipart (intery)+1, fpart(intery))
        }
        intery := intery + gradient
    }
}

DecToBase(n, Base) {
    static U := A_IsUnicode ? "w" : "a"
    VarSetCapacity(S,65,0)
    DllCall("msvcrt\_i64to" U, "Int64",n, "Str",S, "Int",Base)
    return, S
}
