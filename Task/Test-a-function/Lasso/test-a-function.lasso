// Taken from the Lasso entry in Palindrome page
define isPalindrome(text::string) => {

    local(_text = string(#text)) // need to make copy to get rid of reference issues

    #_text -> replace(regexp(`(?:$|\W)+`), -ignorecase)

    local(reversed = string(#_text))
    #reversed -> reverse

    return #_text == #reversed
}

// The tests
describe(::isPalindrome) => {
    it(`throws an error when not passed a string`) => {
        expect->error =>{
            isPalindrome(43)
        }
    }

    it(`returns true if the string is the same forward and backwords`) => {
        expect(isPalindrome('abba'))
    }

    it(`returns false if the string is different forward and backwords`) => {
        expect(not isPalindrome('aab'))
    }

    it(`ignores spaces and punctuation`) => {
        expect(isPalindrome(`Madam, I'm Adam`))
    }
}

// Run the tests and get the summary
// (This normally isn't in the code as the test suite is run via command-line.)
lspec->stop
