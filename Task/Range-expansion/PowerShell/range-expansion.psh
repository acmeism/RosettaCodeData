function range-expansion($array) {
    function expansion($arr) {
        if($arr) {
            $arr = $arr.Split(',')
             $arr | foreach{
                $a = $_
                $b, $c, $d, $e = $a.Split('-')
                switch($a) {
                    $b {return $a}
                    "-$c" {return $a}
                    "$b-$c" {return "$(([Int]$b)..([Int]$c))"}
                    "-$c-$d" {return "$(([Int]$("-$c"))..([Int]$d))"}
                    "-$c--$e" {return "$(([Int]$("-$c"))..([Int]$("-$e")))"}
                }
             }
        } else {""}
    }
    $OFS = ", "
    "$(expansion $array)"
    $OFS = " "
}
range-expansion "-6,-3--1,3-5,7-11,14,15,17-20"
