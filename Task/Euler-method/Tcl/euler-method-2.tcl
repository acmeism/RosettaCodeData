proc newtonCoolingLaw {time temp} {
    expr {-0.07 * ($temp - 20)}
}

euler newtonCoolingLaw 100 0 100 2
euler newtonCoolingLaw 100 0 100 5
euler newtonCoolingLaw 100 0 100 10
