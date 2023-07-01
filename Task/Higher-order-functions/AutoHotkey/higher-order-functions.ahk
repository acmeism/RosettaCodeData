f(x) {
    return "This " . x
}

g(x) {
    return "That " . x
}

show(fun) {
    msgbox % %fun%("works")
}

show(Func("f")) ; either create a Func object
show("g")       ; or just name the function
return
