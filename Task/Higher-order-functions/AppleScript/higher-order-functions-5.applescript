on aHandler(aParameter)
    say aParameter
end aHandler

on receivingHandler(passedHandler)
    script o
        property h : passedHandler
    end script

    o's h("Hello")
end receivingHandler

receivingHandler(aHandler)
