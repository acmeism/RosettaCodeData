var k2c = k => k - 273.15
var k2r = k => k * 1.8
var k2f = k => k2r(k) - 459.67

Number.prototype.toMaxDecimal = function (d) {
    return +this.toFixed(d) + ''
}

function kCnv(k) {
    document.write( k,'K° = ', k2c(k).toMaxDecimal(2),'C° = ', k2r(k).toMaxDecimal(2),'R° = ', k2f(k).toMaxDecimal(2),'F°<br>' )
}

kCnv(21)
kCnv(295)
