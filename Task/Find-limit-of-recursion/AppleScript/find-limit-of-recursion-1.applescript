-- recursionDepth :: () -> IO String
on recursionDepth()
    script go
        on |λ|(i)
            try
                |λ|(1 + i)
            on error
                "Recursion limit encountered at " & i
            end try
        end |λ|
    end script

    go's |λ|(0)
end recursionDepth

on run

    recursionDepth()

end run
