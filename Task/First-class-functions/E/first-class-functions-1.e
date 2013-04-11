def sin(x)  { return x.sin() }
def cos(x)  { return x.cos() }
def asin(x) { return x.asin() }
def acos(x) { return x.acos() }
def cube(x) { return x ** 3     }
def curt(x) { return x ** (1/3) }

def forward := [sin,  cos,  cube]
def reverse := [asin, acos, curt]
