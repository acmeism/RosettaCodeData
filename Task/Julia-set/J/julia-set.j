load '~addons/graphics/fvj4/complex_dynamics.ijs'
pal2=: 255,~0,<.(254$1 0.8 0.6)*Hue 5r6*(i.%<:)254
g=: [: %: 0.3746j0.102863 0.132565j0.389103 _0.373935j_0.353777 1&p.
view_image pal2;b=:g escapetc (10 255) 500 zl_clur _1.5 1.5j1.5
