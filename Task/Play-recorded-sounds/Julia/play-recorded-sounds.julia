using Distributed, Gtk, LibSndFile, MP3
using FileIO: load

function recordingplayerapp(numfiles=2)
    # create window and widgets
    win = GtkWindow("Recorded Sound Player", 400, 400) |> (GtkFrame() |> (vbox = GtkBox(:v)))
    playprocess = @async(0)
    filenames = fill("", numfiles)
    filedurations = zeros(numfiles)
    filebutton = GtkButton[]
    for i in 1:numfiles
        push!(filebutton, GtkButton("Select File $i"))
        push!(vbox, filebutton[i])
    end

    sequencebutton = GtkButton("Play In Sequence")
    simulbutton = GtkButton("Play Simultaneously")
    seqhandlerid = zero(UInt32)
    simulhandlerid = zero(UInt32)
    stopbutton = GtkButton("Stop Play")

    labelstart = GtkLabel("Start Position")
    startcontrol = GtkScale(false, 1:100)
    set_gtk_property!(startcontrol, :hexpand, true)
    adj = GtkAdjustment(startcontrol)

    labelstop = GtkLabel("Stop Position")
    endcontrol = GtkScale(false, 1:100)
    set_gtk_property!(endcontrol, :hexpand, true)
    adj = GtkAdjustment(endcontrol)

    labelrepeat = GtkLabel("Repeats")
    repeats = GtkScale(false, 0:8)
    set_gtk_property!(repeats, :hexpand, true)
    set_gtk_property!(GtkAdjustment(repeats), :value, 0)

    foreach(x -> push!(vbox, x), [sequencebutton, simulbutton, stopbutton, labelstart,
                                  startcontrol, labelstop, endcontrol, labelrepeat, repeats])
    twobox = GtkBox(:h)
    push!(vbox, twobox)

    fboxes = GtkBox[]
    volumecontrols = GtkScale[]
    startcontrols = GtkScale[]
    endcontrols = GtkScale[]
    loopcontrols = GtkScale[]
    for i in 1:numfiles
        push!(fboxes, GtkBox(:v))
        push!(twobox, fboxes[i])

        push!(volumecontrols, GtkScale(false, 0.0:0.05:1.0))
        set_gtk_property!(volumecontrols[i], :hexpand, true)
        adj = GtkAdjustment(volumecontrols[i])
        set_gtk_property!(adj, :value, 0.5)
        push!(fboxes[i], GtkLabel("Volume Stream $i"), volumecontrols[i])

        signal_connect(filebutton[i], :clicked) do widget
            filenames[i] = open_dialog("Pick a sound or music file")
            filenames[i] = replace(filenames[i], "\\" => "/")
            set_gtk_property!(filebutton[i], :label, filenames[i])
            if count(x -> x != "", filenames) > 0
                signal_handler_unblock(sequencebutton, seqhandlerid)
            end
            if count(x -> x != "", filenames) > 1
                signal_handler_unblock(simulbutton, simulhandlerid)
            end
            if occursin(r"\.mp3$", filenames[i])
                buf = load(filenames[i])
                filedurations[i] = MP3.nframes(buf) / MP3.samplerate(buf)
            else
                buf = load(filenames[i])
                filedurations[i] = LibSndFile.nframes(buf) / LibSndFile.samplerate(buf)
            end
            adj = GtkAdjustment(startcontrol)
            set_gtk_property!(adj, :lower, 0.0)
            set_gtk_property!(adj, :upper, maximum(filedurations))
            set_gtk_property!(adj, :value, 0.0)
            adj = GtkAdjustment(endcontrol)
            set_gtk_property!(adj, :lower, 0.0)
            set_gtk_property!(adj, :upper, maximum(filedurations))
            set_gtk_property!(adj, :value, maximum(filedurations))
        end
    end

    # run play after getting parameters from widgets
    function play(simul::Bool)
        args = simul ? String["-m"] : String[]
        tstart = Gtk.GAccessor.value(startcontrol)
        tend = Gtk.GAccessor.value(endcontrol)
        for i in 1:numfiles
            if filenames[i] != ""
                volume = Gtk.GAccessor.value(volumecontrols[i])
                push!(args, "-v", string(volume), filenames[i])
            end
        end
        repeat = Gtk.GAccessor.value(repeats)
        if repeat != 0
            push!(args, "repeat", string(repeat))
        end
        if !(tstart ≈ 0.0 && tend ≈ maximum(filedurations))
            push!(args, "trim", string(tstart), string(tend))
        end
        playprocess = run(`play $args`; wait=false)
        clearfornew()
    end

    function clearfornew()
        signal_handler_block(sequencebutton, seqhandlerid)
        if count(x -> x != "", filenames) > 1
            signal_handler_block(simulbutton, simulhandlerid)
        end
        filenames = fill("", numfiles)
        filedurations = zeros(numfiles)
        foreach(i -> set_gtk_property!(filebutton[i], :label, "Select File $i"), 1:numfiles)
        set_gtk_property!(GtkAdjustment(repeats), :value, 0)
        showall(win)
    end

    killplay(w) = kill(playprocess)

    playsimul(w) = play(true)
    playsequential(w) = play(false)

    seqhandlerid = signal_connect(playsequential, sequencebutton, :clicked)
    signal_handler_block(sequencebutton, seqhandlerid)
    simulhandlerid = signal_connect(playsimul, simulbutton, :clicked)
    signal_handler_block(simulbutton, simulhandlerid)
    signal_connect(killplay, stopbutton, :clicked)

    cond = Condition()
    endit(w) = notify(cond)
    signal_connect(endit, win, :destroy)
    showall(win)
    wait(cond)
end

recordingplayerapp()
