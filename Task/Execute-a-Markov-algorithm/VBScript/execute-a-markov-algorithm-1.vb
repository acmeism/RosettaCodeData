class markovparser

    dim aRules
    public property let ruleset( sBlock )
        dim i
        aRules = split( sBlock, vbNewLine )
        '~ remove blank lines from end of array
        do while aRules( ubound( aRules ) ) = vbnullstring
            redim preserve aRules( ubound( aRules ) - 1 )
        loop
        '~ parse array
        for i = lbound( aRules ) to ubound( aRules )
            if left( aRules( i ), 1 ) = "#" then
                aRules( i ) = Array( vbnullstring, aRules(i))
            else
                aRules( i ) = Split( aRules( i ), " -> ", 2 )
            end if
        next
    end property

    public function apply( sArg )
        dim ruleapplied
        dim terminator
        dim was
        dim i
        dim repl
        dim changes

        ruleapplied = true
        terminator = false

        do while ruleapplied and (not terminator)
            changes = 0
            was = sArg
            for i = lbound( aRules ) to ubound( aRules )
                repl = aRules(i)(1)
                if left( repl, 1 ) = "." then
                    terminator = true
                    repl = mid( repl, 2 )
                end if
                sArg = replace( sArg, aRules(i)(0), repl)
                if was <> sArg then
                    changes = changes + 1
                    if changes = 1 then
                        exit for
                    end if
                end if
                if terminator then
                    exit for
                end if
            next
            if changes = 0 then
                ruleapplied = false
            end if
        loop
        apply = sArg
    end function

    sub dump
        dim i
        for i = lbound( aRules ) to ubound( aRules )
            wscript.echo eef(aRules(i)(0)=vbnullstring,aRules(i)(1),aRules(i)(0)& " -> " & aRules(i)(1))  & eef( left( aRules(i)(1), 1 ) = ".", " #terminator", "" )
        next
    end sub

    private function eef( bCond, sExp1, sExp2 )
        if bCond then
            eef = sExp1
        else
            eef = sExp2
        end if
    end function
end class
