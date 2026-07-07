-- 6 Jul 2026
Main:
include Setting

say 'PRIME DECOMPOSITION'
say version
arg digs
-- Above 30 digits factorizations may become slow
if digs='' then
   digs=30
digs/=1
say '30 numbers max' digs 'digits'
say
numeric digits 2*digs+10
say 'Seqnum Elapsed' Left('Number',digs) 'Prime factors'
n=0
-- Run 30 numbers
do 30
-- Generate random number between 1 to given digits
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
      say l Stem2vectSt('Fact.')
end
exit

-- FactorS Elaps Stem2vectSt
include Math
