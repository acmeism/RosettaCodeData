include Settings

say 'NON-DECIMAL RADICES - 11 Mar 2025'
say version
say
arg xx
if xx = '' then
   xx = 255
do n = 2 to 36
   say xx 'decimal =' Basenn(xx,n) 'base' n '=' Base10(Basenn(xx,n),n) 'decimal'
end
exit

include Functions
include Abend
