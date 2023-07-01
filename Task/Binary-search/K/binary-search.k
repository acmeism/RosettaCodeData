bs:{[a;t]
    if[0=#a; :_n];
    m:_(#a)%2;
    if[t>a@m
        tmp:_f[(m+1) _ a;t]
        :[_n~tmp; :_n; :1+m+tmp]]
    if[t<a@m
        :_f[m#a;t]]
    :m
}

  v:8 30 35 45 49 77 79 82 87 97
  {bs[v;x]}' v
0 1 2 3 4 5 6 7 8 9
