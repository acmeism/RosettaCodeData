-- 28 Jul 2025
include Settings
arg xx
if xx = '' then
   xx = 255

say 'NON-DECIMAL RADICES CONVERT'
say version
say
do n = 2 to 36
   say xx 'decimal =' BaseNN(xx,n) 'base' n '=' Base10(BaseNN(xx,n),n) 'decimal'
end
exit

include Math
