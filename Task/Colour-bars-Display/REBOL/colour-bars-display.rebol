Rebol [
    title: "Rosetta code: Colour bars/Display"
    file:  %Colour_bars-Display.r3
    url:   https://rosettacode.org/wiki/Colour_bars-Display
    note:  "Works only on Windows so far"
    needs: blend2d
]

canvas: system/view/screen-gob/size
colors: [black red green blue magenta cyan yellow white]

n: length? colors
gap: canvas/x / n
drawing: []
tl: 0x0
br: as-pair 0 canvas/y
append drawing collect [
    repeat i n [
        br/x: gap + tl/x: i - 1 * gap
        keep reduce ['fill-pen colors/:i 'box tl br]
    ]
]

win: make gob! compose [image: (draw canvas drawing)]
view/options win [flags: [no-title no-border] offset: 0x0]
