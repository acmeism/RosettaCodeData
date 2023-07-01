[(1000): 233168, (10e20): 233333333333333333333166666666666666666668].each { arg, value ->
    println "Checking $arg == $value"
    assert sum35(arg) == value
}
