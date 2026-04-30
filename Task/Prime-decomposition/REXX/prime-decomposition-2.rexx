-- 25 Apr 2026
Main:
include Setting
Memo.cache=0

say 'PRIME DECOMPOSITION'
say version
arg digs
-- Above 30 digits factorizations may become slow
if digs='' then
   digs=30
say 'Endless run max' digs 'digits'
say
numeric digits 2*digs+10
say 'Seqnum Elapsed' Left('Number',digs) 'Prime factors'
n=0
-- Run forever
do forever
-- Generate random number with 1 to given digits
   arg1=''
   do Random(1,digs)
      arg1=arg1||Random(9)
   end
   if arg1=0 then
      iterate
   n+=1
-- Factorize
   arg1/=1; f=FactorS(arg1)
-- Show prime factors
   l=Right(n,6) Format(Elaps('r'),3,3) Left(arg1,digs)
   if f=0 then
      say l 'failed'
   else
      say l Stem2struct('Fact.')
end
exit

-- FactorS; Stem2struct; Elaps
include Math
