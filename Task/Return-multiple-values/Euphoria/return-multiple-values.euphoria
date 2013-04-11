include std\console.e --only for any_key, to help make running this program easy on windows GUI

integer aWholeNumber = 1
atom aFloat = 1.999999
sequence aSequence = {3, 4}
sequence result = {} --empty initialized sequence

function addmultret(integer first, atom second, sequence third)--takes three kinds of input, adds them all into one element of the..
    return (first + second + third[1]) + third[2] & (first * second * third[1]) * third[2] --..output sequence and multiplies them into..
end function --..the second element

result = addmultret(aWholeNumber, aFloat, aSequence) --call function, assign what it gets into result - {9.999999, 23.999988}
? result
any_key()
