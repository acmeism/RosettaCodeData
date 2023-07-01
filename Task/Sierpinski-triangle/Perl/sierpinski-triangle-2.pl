perl -le '$l=40;$l2="!" x $l;substr+($l2^=$l2),$l/2,1,"\xFF";for(1..16){local $_=$l2;y/\0\xFF/ */;print;($lf,$rt)=map{substr $l2 x 2,$_%$l,$l;}1,-1;$l2=$lf^$rt;select undef,undef,undef,.1;}'
