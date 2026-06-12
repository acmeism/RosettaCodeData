// 20210415 Perl programming solution

perl -e 'for(0..999){my$n;s/(\d)/$n+=$1/egr;print"$_ "if/$n/}'
