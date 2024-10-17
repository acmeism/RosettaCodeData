using Gtk

function twoentrywindow()
    txt = "Enter Text Here"
    txtchanged = false

    win = GtkWindow("Keypress Test", 500, 100) |> (GtkFrame() |> (vbox = GtkBox(:v)))
    lab = GtkLabel("Enter some text in the first box and 7500 into the second box.")
    txtent = GtkEntry()
    set_gtk_property!(txtent,:text,"Enter Some Text Here")
    nument = GtkEntry()
    set_gtk_property!(nument,:text,"Enter the number seventy-five thousand here")
    push!(vbox, lab, txtent, nument)

    function keycall(w, event)
        strtxt = get_gtk_property(txtent, :text, String)
        numtxt = get_gtk_property(nument, :text, String)
        if strtxt != txt && occursin("75000", numtxt)
            set_gtk_property!(lab, :label, "You have accomplished the task.")
        end
    end
    signal_connect(keycall, win, "key-press-event")

    cond = Condition()
    endit(w) = notify(cond)
    signal_connect(endit, win, :destroy)
    showall(win)
    wait(cond)
end

twoentrywindow()
