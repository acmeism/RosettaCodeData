{ stdin } = process
sum = ( a, b ) -> a + b

display = ( messages... ) -> console.log messages...

parse = ( input ) ->
    parseInt x for x in ( x.trim() for x in input.split ' ' ) when x?.length

check = ( numbers... ) ->
    return no for x in numbers when isNaN x
    return no for x in numbers when not ( -1000 < x < 1000 )
    yes

prompt = ->
    display 'Please enter two integers between -1000 and 1000, separated by a space:'
    stdin.once 'data', ( data ) ->
        [ a, b ] = parse data
        if check a, b
            display "#{ a } + #{ b } = #{ sum a, b }"
        else
            display "Invalid input: #{ a }, #{ b }"
        do prompt
        return

# Resume input and set the incoming encoding.
stdin.resume()
stdin.setEncoding 'utf8'

# Start the main loop.
do prompt
