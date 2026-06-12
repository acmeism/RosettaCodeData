function lcp ($arr) {
    if($arr){
        $arr = $arr | sort {$_.length} | select -unique
        if(1 -lt $arr.count) {
            $lim, $i, $test = $arr[0].length, 0, $true
            while (($i -lt $lim) -and $test) {
                $test = ($arr | group {$_[$i]}).Name.Count -eq 1
                if ($test) {$i += 1}
            }
            $arr[0].substring(0,$i)
        } else {$arr}
    } else{''}

}
function show($arr) {
    function quote($str) {"`"$str`""}
    "lcp @($(($arr | foreach{quote $_}) -join ', ')) = $(lcp $arr)"
}
show @("interspecies","interstellar","interstate")
show @("throne","throne")
show @("throne","dungeon")
show @("throne", "","throne")
show @("cheese")
show @("")
show @()
show @("prefix","suffix")
show @("foo","foobar")
