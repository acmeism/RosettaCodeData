def verify = { ruleset ->
    [withInput: { text ->
        [hasOutput: { expected ->
            def result = ruleset.interpret(text)
            println "Input: '$text' has output: '$result'"
            assert expected == result
        }]
    }]
}

def ruleset1 = markovInterpreterFor("""
# This rules file is extracted from Wikipedia:
# http://en.wikipedia.org/wiki/Markov_Algorithm
A -> apple
B -> bag
S -> shop
T -> the
the shop -> my brother
a never used -> .terminating rule""")
println ruleset1.interpret('I bought a B of As from T S.')
verify ruleset1 withInput 'I bought a bag of apples from T shop.' hasOutput 'I bought a bag of apples from my brother.'

def ruleset2 = markovInterpreterFor("""...""")
verify ruleset2 withInput 'I bought a B of As from T S.' hasOutput 'I bought a bag of apples from T shop.'

def ruleset3 = markovInterpreterFor("""...""")
verify ruleset3 withInput 'I bought a B of As W my Bgage from T S.' hasOutput 'I bought a bag of apples with my money from T shop.'

def ruleset4 = markovInterpreterFor("""...""")
verify ruleset4 withInput '_1111*11111_' hasOutput '11111111111111111111'

def ruleset5 = markovInterpreterFor("""...""")
verify ruleset5 withInput '000000A000000' hasOutput '00011H1111000'
