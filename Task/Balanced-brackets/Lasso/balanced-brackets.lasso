define randomparens(num::integer,open::string='[',close::string=']') => {
    local(out) = array

    with i in 1 to #num do {
        #out->insert(']', integer_random(1,#out->size || 1))
        #out->insert('[', integer_random(1,#out->size || 1))
    }
    return #out->join
}

define validateparens(input::string,open::string='[',close::string=']') => {
    local(i) = 0
    #input->foreachcharacter => {
        #1 == #open ? #i++
        #1 == #close && --#i < 0 ? return false
    }
    return #i == 0 ? true | false
}

with i in 1 to 10
let input = randomparens(#i)
select #input + ' = ' + validateparens(#input)
