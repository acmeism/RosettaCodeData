// Centre and radius of a circle passing through 3 points in a plane. Nigel Galloway: February 20th., 2024
let c (a,b) (c,d) (e,f)=(0.5*((a*a+b*b)*(f-d)+(c*c+d*d)*(b-f)+(e*e+f*f)*(d-b))/(a*(f-d)+c*(b-f)+e*(d-b)),
                         0.5*((a*a+b*b)*(e-c)+(c*c+d*d)*(a-e)+(e*e+f*f)*(c-a))/(b*(e-c)+d*(a-e)+f*(c-a)))
let d n g = let n,g=fst n-fst g,snd n-snd g in sqrt(n*n+g*g)
let circ P1 P2 P3 = let c=c P1 P2 P3 in (c,d c P1)

let centre,radius=circ (22.83, 2.07) (14.39, 30.24) (33.65, 17.31)
printfn $"Centre = %A{centre}, radius = %f{radius}"
