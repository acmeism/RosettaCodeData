"""
    First nterms terms of the first 2..max_nstep -step Padovan sequences.
"""
function nstep_Padovan(max_nstep=8, nterms=15)
    start = [[], [1, 1, 1]]     # for n=0 and n=1 (hidden).
    for n in 2:max_nstep
        this = start[n][1:n+1]     # Initialise from last
        while length(this) < nterms
            push!(this, sum(this[end - i] for i in 1:n))
        end
        push!(start, this)
    end
    return start[3:end]
end

function print_Padovan_seq(p)
    println(strip("""
:::: {| style="text-align: left;" border="4" cellpadding="2" cellspacing="2"
|+ Padovan <math>n</math>-step sequences
|- style="background-color: rgb(255, 204, 255);"
! <math>n</math> !! Values
|-
          """))
    for (n, seq) in enumerate(p)
        println("| $n || $(replace(string(seq[2:end]), r"[ a-zA-Z\[\]]+" => "")), ...\n|-")
    end
    println("|}")
end

print_Padovan_seq(nstep_Padovan())
