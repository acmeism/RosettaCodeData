i,j,m,d,seed = 55,24,10^9,34,292929     # parameters
s = Array{Int32}(undef,i); r = similar(s)
s[1:2] = [seed,1]                       # table initialization
for n = 3:i; (s[n] = s[n-2]-s[n-1]) < 0 && (s[n] += m) end
t = 1; for u=1:i; (global t+=d)>i && (t-=i); r[u]=s[t] end # permutation, r = s[(d*(1:i) .% i).+1]

u,v,n = i,i-j,i-1
while (n += 1) > 0
    (global u += 1) > i && (u = 1)      # circular indexing: u,v = ((n,n-j) .% i).+1
    (global v += 1) > i && (v = 1)
    (r[u] -= r[v]) < 0 && (r[u] += m)   # table update
    n < 220 && continue                 # 165 silent values
    print((n,r[u]))                     # show (index,value) of next pseudorandom number
    x = readline(stdin)                 # wait until the ENTER key is pressed
    length(x) > 0 && break              # any other key before ENTER => exit
end
