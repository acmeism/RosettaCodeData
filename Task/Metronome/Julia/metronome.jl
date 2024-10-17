function metronome(bpm::Real=72, bpb::Int=4)
    s = 60.0 / bpm
    counter = 0
    while true
        counter += 1
        if counter % bpb != 0
            println("tick")
        else
            println("TICK")
        end
        sleep(s)
    end
end
