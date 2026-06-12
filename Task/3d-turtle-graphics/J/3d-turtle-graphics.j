NB. pre-requisites:
NB. ;install each cut 'gl2 gles github:zerowords/tgsjo'
load'zerowords/tgsjo'
stop''
clearscreen ''
createTurtle 0 0 0

EYE_tgsjo_=: 0 0 _90
rotR 180+94 10 0

column=: {{
    4 repeats {{'height width'=. y
        2 repeats {{'height width'=. y
            forward width
            pitch 90
            forward height
            pitch 90
        }} y
        forward width
        right 90
    }} y
}}

cube=: {{ column y,y }}

codihedral=: 180p_1*_3 o.%%:2
pyramid=: {{
    4 repeats {{
        roll codihedral
        pitch triangle y
        roll-codihedral
        forward y
        left 90
    }} y
}}

NB. in 3d, we want to know which turning mechanism to use, when drawing a plane figure
triangle=: {{
    3 repeats (u {{
        forward y
        u 120
    }}) y
}}


house=: {{
    cube y
    roll 180
    pyramid y
}}

barchart=: {{'lst size'=. y
    if.#lst do.
        scale=. size%>./lst
        width=. size%#lst
        for_j. lst do.
            column (j * scale),width
            forward width
        end.
        back size
    end.
}}

penColor Red
house 150
pen 0
back 30
right 180
pen 1
penColor Blue
barchart 0.5 0.3333 2 1.3 0.5; 200
pen 0
left 180
forward 30
roll 180
