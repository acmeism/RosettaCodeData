function mh_results{T<:Integer}(ncur::T, ncar::T,
                                nruns::T, play_mh::Function)
    stickwins = 0
    switchwins = 0
    for i in 1:nruns
        (isstickwin, isswitchwin) = play_mh(ncur, ncar)
        if isstickwin
            stickwins += 1
        end
        if isswitchwin
            switchwins += 1
        end
    end
    return (stickwins/nruns, switchwins/nruns)
end

function mh_analytic{T<:Integer}(ncur::T, ncar::T)
    stickodds = ncar/ncur
    switchodds = (ncar - stickodds)/(ncur-2)
    return (stickodds, switchodds)
end

function show_odds{T<:Real}(a::T, b::T)
    @sprintf "   %.1f   %.1f     %.2f" 100.0*a 100*b 1.0*b/a
end

function show_simulation{T<:Integer}(ncur::T, ncar::T, nruns::T)
    println()
    print("Simulating a ", ncur, " door, ", ncar, " car ")
    println("Monty Hall problem with ", nruns, " runs.\n")

    println("   Solution   Stick  Switch  Improvement")

    (a, b) = mh_results(ncur, ncar, nruns, play_mh_literal)
    println(@sprintf("%10s: ", "Literal"), show_odds(a, b))

    (a, b) = mh_results(ncur, ncar, nruns, play_mh_clean)
    println(@sprintf("%10s: ", "Clean"), show_odds(a, b))

    (a, b) = mh_analytic(ncur, ncar)
    println(@sprintf("%10s: ", "Analytic"), show_odds(a, b))
    println()
    return nothing
end
