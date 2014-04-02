 function j(n,k)
    p, i, seq=[0:n-1], 0, Int[]
    while !isempty(p)
        i=(i+k-1)%length(p)
        push!(seq,splice!(p,i+1))
    end
    @sprintf("Prisoner killing order: %s.\nSurvivor: %i",replace(chomp(string(seq[1:end-1])),"\n",", "),seq[end])
end
