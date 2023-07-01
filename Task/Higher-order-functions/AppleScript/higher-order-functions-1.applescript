-- This handler takes a script object (singer)
-- with another handler (call).
on sing about topic by singer
    call of singer for "Of " & topic & " I sing"
end sing

-- Define a handler in a script object,
-- then pass the script object.
script cellos
    on call for what
        say what using "Cellos"
    end call
end script
sing about "functional programming" by cellos

-- Pass a different handler. This one is a closure
-- that uses a variable (voice) from its context.
on hire for voice
    script
        on call for what
            say what using voice
        end call
    end script
end hire
sing about "closures" by (hire for "Pipe Organ")
