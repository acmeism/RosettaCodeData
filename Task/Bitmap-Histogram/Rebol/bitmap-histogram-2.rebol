img: load %Lenna50.jpg
foreach channel [red green blue] [
    vec: to vector! img/:channel
    med: vec/median
    forall vec [vec/1: either vec/1 < med [0][255]]
    img/:channel: vec
]
browse save %Lenna50-rgb.png img
