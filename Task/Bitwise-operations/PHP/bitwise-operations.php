function bitwise($a, $b)
{
    function zerofill($a,$b) {
        if($a>=0) return $a>>$b;
        if($b==0) return (($a>>1)&0x7fffffff)*2+(($a>>$b)&1); // this line shifts a 0 into the sign bit for compatibility, replace with "if($b==0) return $a;" if you need $b=0 to mean that nothing happens
        return ((~$a)>>$b)^(0x7fffffff>>($b-1));

    echo '$a AND $b: ' . $a & $b . '\n';
    echo '$a OR $b: ' . $a | $b . '\n';
    echo '$a XOR $b: ' . $a ^ $b . '\n';
    echo 'NOT $a: ' . ~$a . '\n';
    echo '$a << $b: ' . $a << $b . '\n'; // left shift
    echo '$a >> $b: ' . $a >> $b . '\n'; // arithmetic right shift
    echo 'zerofill($a, $b): ' . zerofill($a, $b) . '\n'; // logical right shift
}
