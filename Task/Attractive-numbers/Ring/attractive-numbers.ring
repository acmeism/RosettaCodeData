# Project: Attractive Numbers

decomp = []
nump = 0
see "Attractive Numbers up to 120:" + nl
while nump < 120
decomp = []
nump = nump + 1
for i = 1 to nump
    if isPrime(i) and nump%i = 0
       add(decomp,i)
       dec = nump/i
       while dec%i = 0
             add(decomp,i)
             dec = dec/i
       end
    ok
next
if isPrime(len(decomp))
   see string(nump) + " = ["
for n = 1 to len(decomp)
    if n < len(decomp)
       see string(decomp[n]) + "*"
    else
       see string(decomp[n]) + "] - " + len(decomp) + " is prime" + nl
    ok
next
ok
end


func isPrime(num)
     if (num <= 1) return 0 ok
     if (num % 2 = 0) and num != 2 return 0 ok
     for i = 3 to floor(num / 2) -1 step 2
         if (num % i = 0) return 0 ok
     next
     return 1
