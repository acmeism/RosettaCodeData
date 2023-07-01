def draw_sphere:
  svg,
   "<title>Teal sphere</title>",
    sphericalGradient("tealGradient"; null), # define the gradient to use
    sphere(100;100;100; "tealGradient"),     # draw a sphere using the gradient
    sphere(100;300;100; "tealGradient"),     # draw another sphere using the same gradient
  "</svg>" ;

draw_sphere
