      $SET SOURCEFORMAT "FREE"
$SET ILUSING "System"
$SET ILUSING "System.Numerics"
class-id Prog.
method-id. Main static.
procedure division.
    declare num as type Complex = type Complex::ImaginaryOne()
    declare results as type Complex occurs any
    set content of results to ((num + num), (num * num), (- num), (1 / num), type Complex::Conjugate(num))
    perform varying result as type Complex thru results
        display result
    end-perform
end method.
end class.
