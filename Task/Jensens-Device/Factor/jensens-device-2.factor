SYMBOL: i

: sum ( i lo hi term -- x )
    [ [a,b] ] dip pick [ inc ] curry compose map-sum nip ;
    inline

i 1 100 [ recip ] sum .
