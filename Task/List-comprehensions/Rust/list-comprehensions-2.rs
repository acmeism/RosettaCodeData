macro_rules! comp {
    ($e:expr, for $x:pat in $xs:expr $(, if $c:expr)?) => {{
        $xs.filter_map(move |$x| if $($c &&)? true { Some($e) } else { None })
    }};
    ($e:expr, for $x:pat in $xs:expr $(, for $y:pat in $ys:expr)+ $(, if $c:expr)?) => {{
        $xs.flat_map(move |$x| comp!($e, $(for $y in $ys),+ $(, if $c)?))
    }};
}
