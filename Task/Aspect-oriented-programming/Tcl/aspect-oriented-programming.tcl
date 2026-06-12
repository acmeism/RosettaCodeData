oo::class create InterceptAspect {
    filter <methodCalled>
    method <methodCalled> args {
        puts "[self] - called '[self target]' with '$args'"
        set result [next {*}$args]
        puts "[self] - result was '$result'"
        return $result
    }
}

oo::class create Example {
    method calculate {a b c} {
        return [expr {$a**3 + $b**2 + $c}]
    }
}

Example create xmpl
puts ">>[xmpl calculate 2 3 5]<<"
oo::objdefine xmpl mixin InterceptAspect
puts ">>[xmpl calculate 2 3 5]<<"
