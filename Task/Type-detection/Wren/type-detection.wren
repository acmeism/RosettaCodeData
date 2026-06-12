import "./fmt" for Fmt

var showType = Fn.new { |obj|
    Fmt.print("$10n has type $q", obj, obj.type)
}

var a  = [4, 3.728, [1, 2], { 1: "first" }, true, null, 1..6, "Rosetta"]
a.each { |e| showType.call(e) }
