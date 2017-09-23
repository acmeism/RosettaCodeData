for (var dpa=[1,0,0], n=2; n<=20000; n+=1) {
    for (var ds=0, d=1, e=n/2+1; d<e; d+=1) if (n%d==0) ds+=d
    dpa[ds<n ? 0 : ds==n ? 1 : 2]+=1
}
document.write('Deficient:',dpa[0], ', Perfect:',dpa[1], ', Abundant:',dpa[2], '<br>' )
