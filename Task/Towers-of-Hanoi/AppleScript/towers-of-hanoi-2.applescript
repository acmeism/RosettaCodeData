on hanoi(n, source, target)
    set t1 to tab & "tower 1: " & tab
    set t2 to tab & "tower 2: " & tab
    set t3 to tab & "tower 3: " & tab

    script o
        property m : 0
        property tower1 : {}
        property tower2 : {}
        property tower3 : {}
        property towerRefs : {a reference to tower1, a reference to tower2, a reference to tower3}
        property process : missing value

        on |move|(n, source, target)
            set aux to 6 - source - target
            repeat with n from n to 2 by -1 -- Tail call elimination repeat.
                |move|(n - 1, source, aux)
                set end of item target of my towerRefs to n
                tell item source of my towerRefs to set its contents to reverse of rest of its reverse
                set m to m + 1
                set end of my process to ¬
                    {(m as text) & ". move disc " & n & (" from tower " & source) & (" to tower " & target & ":"), ¬
                        t1 & tower1, ¬
                        t2 & tower2, ¬
                        t3 & tower3}
                tell source
                    set source to aux
                    set aux to it
                end tell
            end repeat
            -- Specific code for n = 1:
            set end of item target of my towerRefs to 1
            tell item source of my towerRefs to set its contents to reverse of rest of its reverse
            set m to m + 1
            set end of my process to ¬
                {(m as text) & ". move disc 1 from tower " & source & (" to tower " & target & ":"), ¬
                    t1 & tower1, ¬
                    t2 & tower2, ¬
                    t3 & tower3}
        end |move|
    end script

    repeat with i from n to 1 by -1
        set end of item source of o's towerRefs to i
    end repeat

    set astid to AppleScript's text item delimiters
    set AppleScript's text item delimiters to ", "
    set o's process to {"Starting with " & n & (" discs on tower " & (source & ":")), ¬
        t1 & o's tower1, t2 & o's tower2, t3 & o's tower3}
    if (n > 0) then tell o to |move|(n, source, target)
    set end of o's process to "That's it!"
    set AppleScript's text item delimiters to linefeed
    set process to o's process as text
    set AppleScript's text item delimiters to astid

    return process
end hanoi

-- Test:
set numberOfDiscs to 3
set sourceTower to 1
set destinationTower to 2
hanoi(numberOfDiscs, sourceTower, destinationTower)
