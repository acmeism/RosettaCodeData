load'zerowords/tgsjo'
rotR   0 0 _90
translate 0 0 _40
clearscreen ''
createTurtle 0 0 0

rectangle=: {{
    2 repeats {{ 'width height'=. y
        forward height
        left 90
        forward width
        left 90 }} y
}}

square=: {{size=. y
     rectangle size,size
}}

triangle=:{{
  3 repeats {{size=. y
        forward size
        right 120}} y
}}

house=:{{size=. y
    left 90
    square size
    triangle size
    right 90
}}

barchart=: {{'lst size'=. y
    if.#lst do.
        scale=. size%>./lst
        width=. size%#lst
        right 90
        for_j. lst do.
            rectangle (j * scale),width
            forward width
        end.
        back size
        left 90
    end.
}}

penColor Red
house 150
pen 0
right 90
forward 10
left 90
pen 1 [ penColor Blue
barchart 0.5 0.3333 2 1.3 0.5; 200
pen 0
left 90
forward 10
left 270
pen 1
