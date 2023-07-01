local
 open IntInf
in
 fun summDigits  base = ( fn 0 => 0 | n => n mod base + summDigits base (n div base ) )
end;

summDigits 10 1 ;
summDigits 10 1234 ;
summDigits 16 0xfe ;
summDigits 16 0xf0e ;
summDigits 4332489243570890023480923 0x8092eeac80923984098234098efad2109ce341000c3f0912527130  ;
