using Printf

function play_mh_literal{T<:Integer}(ncur::T=3, ncar::T=1)
    ncar < ncur || throw(DomainError())
    curtains = shuffle(collect(1:ncur))
    cars = curtains[1:ncar]
    goats = curtains[(ncar+1):end]
    pick = rand(1:ncur)
    isstickwin = pick in cars
    deleteat!(curtains, findin(curtains, pick))
    if !isstickwin
        deleteat!(goats, findin(goats, pick))
    end
    if length(goats) > 0 # reveal goat
        deleteat!(curtains, findin(curtains, shuffle(goats)[1]))
    else # no goats, so reveal car
        deleteat!(curtains, rand(1:(ncur-1)))
    end
    pick = shuffle(curtains)[1]
    isswitchwin = pick in cars
    return (isstickwin, isswitchwin)
end
