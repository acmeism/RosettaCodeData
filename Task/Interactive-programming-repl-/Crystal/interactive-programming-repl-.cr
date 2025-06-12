> crystal i
Crystal interpreter 1.15.1 [89944bf] (2025-02-04).
EXPERIMENTAL SOFTWARE: if you find a bug, please consider opening an issue in
https://github.com/crystal-lang/crystal/issues/new/
icr:1> def f(s1, s2, sep)
icr:2>   s1 + sep + sep + s2
icr:3> end
 => nil
icr:4> f "Rosetta", "Code", ":"
 => "Rosetta::Code"
icr:5>
