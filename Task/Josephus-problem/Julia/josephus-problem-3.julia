 function j2(n,k,m)
    p, i, seq=[0:n-1], 0, Int[]
    while length(p)>m
        i=(i+k-1)%length(p)
        push!(seq,splice!(p,i+1))
    end
    prt_array(x)=replace(chomp(string(x)),"\n",", ")
    @sprintf("Prisoner killing order: %s.\nSurvivors: %s",prt_array(seq),"["*prt_array(p)*"]")
end
