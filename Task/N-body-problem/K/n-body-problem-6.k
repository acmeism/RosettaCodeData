s::n#3                                            / size of sprite bitmap
sc:1.25;P::{w*0.5*1+(1%sc)*x}                     / display units
wh::(w;h);C::wh%2                                 / viewbox
RGB:("#f00";"#0f0";"#00f")                        / color palette
BW:("#000";"#fff")                                / monochrome palette
msg::,":"                                         / initial position marker
tick::{N[dt]}                                     / time increment callback
draw::{                                           / display callback
  r:(,:'P[p]-s%2),'`RGB,',:'(2#'s)#'!n            / plot the bodies
  r,:,(P[1 0];BW;~,/'+text@`i$msg)                / plot the initial position marker
}
