script aScript
    on aHandler(aParameter)
        say aParameter
    end aHandler
end script

on receivingHandler(passedScript)
    passedScript's aHandler("Hello")
end receivingHandler

receivingHandler(aScript)
