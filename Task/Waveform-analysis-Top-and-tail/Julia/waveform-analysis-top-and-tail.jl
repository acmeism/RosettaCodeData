using FileIO, Gtk, LibSndFile, Printf

function dB(buf, i, channels, cutoff=0.001)
    xsum = sum(buf[k, j] * buf[k, j] for j in 1:channels, k in i-1:i+1)
    sigmean = xsum / (channels * 3)
    return sigmean < cutoff ? -60.0 : 20 * log(10, sigmean)
end

function silencecropperapp()
    win = GtkWindow("Sound File Silence Cropping Tool", 800, 200) |> (GtkFrame() |> (vbox = GtkBox(:v)))
    infilename, outfilename, modifyinputfile, trimmable = "", "", false, true
    outchoices = Vector{GtkRadioButton}(undef, 2)
    outchoices[1] = GtkRadioButton("Crop the Input File In-Place", active=true)
    outchoices[2] = GtkRadioButton(outchoices[1], "Copy Output to File Chosen Below")
    inbutton = GtkButton("Click to Choose Input File")

    senslabel = GtkLabel("Threshold (db)")
    thresholdslider = GtkScale(false, -40.0:10.0)
    adj = GtkAdjustment(thresholdslider)
    push!(vbox, outchoices[1], outchoices[2], inbutton, senslabel, thresholdslider)

    crop = Vector{GtkRadioButton}(undef, 3)
    crop[1] = GtkRadioButton("Crop File at Beginning")
    crop[2] = GtkRadioButton(crop[1], "Crop File at End")
    crop[3] = GtkRadioButton(crop[2], "Crop Both Ends", active=true)
    cropchoice() = [get_gtk_property(b, :active, Bool) for b in crop]

    trimfilebutton = GtkButton("Trim!")
    push!(vbox, crop[1], crop[2], crop[3], trimfilebutton)

    hbox = GtkBox(:h)
    textentry = GtkEntry()
    set_gtk_property!(textentry, :expand, true)
    set_gtk_property!(textentry, :text, "Set Output File")
    pickoutfilebutton = GtkButton("Choose Existing File for Output")
    push!(hbox, textentry, pickoutfilebutton)
    push!(vbox, hbox)

    function reinitialize()
        infilename, outfilename, modifyinputfile, trimmable = "", "", true, true
        set_gtk_property!(trimfilebutton, :label, "Trim!")
        toggleoutputactive(win)
    end
    function toggleoutputactive(w)
        if get_gtk_property(outchoices[2], :active, Bool)
            set_gtk_property!(textentry, :editable, true)
            set_gtk_property!(textentry, :text, "Set Output File")
            modifyinputfile = false
        elseif get_gtk_property(outchoices[1], :active, Bool)
            set_gtk_property!(textentry, :editable, false)
            set_gtk_property!(textentry, :text, "Set Output File")
            outfilename = ""
            modifyinputfile = true
        end
    end
    function pickinput(w)
        filename = open_dialog("Pick a sound or music file to be trimmed.")
        if filesize(filename) > 0
            infilename = filename
            set_gtk_property!(inbutton, :label, infilename)
        end
        trimbuttonlabel(win)
    end
    function pickoutput(w)
        if get_gtk_property(outchoices[2], :active, Bool)
            outfilename = open_dialog("Pick Output File To Be Overwritten.")
            set_gtk_property!(textentry, :text, outfilename)
            show(textentry)
        end
    end
    function trimbuttonlabel(w)
        tstart, tend, tboth = cropchoice()
        toggleoutputactive(win)
        if filesize(infilename) > 0
            scut, ecut, b, nframes, fs = getsilence(get_gtk_property(adj, :value, Float64))
            if (tboth && scut <= 1 && ecut >= nframes) ||
                (tstart && scut <= 1) || (tend && ecut >= nframes)
                set_gtk_property!(trimfilebutton, :label, "Nothing to trim.")
                trimmable = false
            else
                text = @sprintf("Trim %7.2f seconds at front and %7.2f seconds at back.",
                    (scut - 1) / fs, (nframes - ecut) / fs)
                set_gtk_property!(trimfilebutton, :label, text)
                trimmable = true
            end
        else
            set_gtk_property!(trimfilebutton, :label, "Trim!")
        end
    end
    function trimsilence(w)
        if trimmable
            if modifyinputfile
                outfilename = infilename
            elseif outfilename == ""
                s = get_gtk_property(textentry, :text, String)
                outfilename = s != "Set Output File" ? s :
                    open_dialog("Pick or enter a file for output")
            end
            if filesize(outfilename) <= 0 || ask_dialog("Really change file $infilename?")
                scut, ecut, buf, n, fs = getsilence(get_gtk_property(adj, :value, Float64))
                FileIO.save(outfilename, buf[scut:ecut, :])
                info_dialog("File $outfilename saved: $(filesize(outfilename)) bytes.", win)
                reinitialize()
            end
        end
    end
    function getsilence(threshold, granularity=0.1)
        buf = load(infilename)
        (buflen, channels) = size(buf)
        startcut, endcut = 0, buflen
        nframes = LibSndFile.nframes(buf)
        fs = LibSndFile.samplerate(buf)
        cchoices = cropchoice()
        if cchoices[1] || cchoices[3]
            pos = findfirst(i -> dB(buf, i, channels) > threshold, 2:buflen-1)
            if pos == nothing
                # all below threshold
                return buflen, 0, buf, nframes, fs
            else
                startcut = Int(floor(((pos / fs) - (pos / fs) % granularity) * fs))
                startcut = startcut < 1 ? 1 : startcut
            end
        end
        if cchoices[2] || cchoices[3]
            pos = findlast(i -> dB(buf, i, channels) > threshold, 2:buflen-1)
            if pos != nothing
                endcut = Int(ceil((granularity + (pos / fs) - (pos / fs) % granularity) * fs))
                endcut = endcut > nframes ? nframes : endcut
            end
        end
        return startcut, endcut, buf, nframes, fs
    end

    foreach(i -> signal_connect(toggleoutputactive, outchoices[i], :clicked), 1:2)
    foreach(i -> signal_connect(trimbuttonlabel, crop[i], :clicked), 1:3)
    signal_connect(pickoutput, pickoutfilebutton, :clicked)
    setfromtext(w) = (outfilename = get_gtk_property(textentry, :text, String))
    signal_connect(pickinput, inbutton, :clicked)
    signal_connect(trimsilence, trimfilebutton, :clicked)
    toggleoutputactive(win)

    cond = Condition()
    endit(w) = notify(cond)
    signal_connect(endit, win, :destroy)
    showall(win)
    wait(cond)
end

silencecropperapp()
