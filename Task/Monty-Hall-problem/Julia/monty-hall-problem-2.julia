function play_mh_clean{T<:Integer}(ncur::T=3, ncar::T=1)
    ncar < ncur || throw(DomainError())
    pick = rand(1:ncur)
    isstickwin = pick <= ncar
    pick = rand(1:(ncur-2))
    if isstickwin # remove initially picked car from consideration
        pick += 1
    end
    isswitchwin = pick <= ncar
    return (isstickwin, isswitchwin)
end
