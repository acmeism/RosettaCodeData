## Nim directly supports documentation using comments that start with two
## hashes (##). To create the documentation run ``nim doc file.nim``.
## ``nim doc2 file.nim`` is the same, but run after semantic checking, which
## allows it to process macros and output more information.
##
## These are the comments for the entire module.  We can have long descriptions
## here. Syntax is reStructuredText. Only exported symbols (*) get
## documentation created for them.
##
## Here comes a code block inside our documentation:
##
## .. code-block:: nim
##   var inputStrings : seq[string]
##   newSeq(inputStrings, 3)
##   inputStrings[0] = "The fourth"
##   inputStrings[1] = "assignment"
##   inputStrings[2] = "would crash"
##   #inputStrings[3] = "out of bounds"

type TPerson* = object
  ## This type contains a description of a person
  name: string
  age: int

var numValues*: int ## \
  ## `numValues` stores the number of values

proc helloWorld*(times: int) =
  ## A useful procedure
  for i in 1..times:
    echo "hello world"
