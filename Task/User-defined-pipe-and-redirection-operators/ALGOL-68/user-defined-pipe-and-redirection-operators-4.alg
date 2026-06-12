#!/usr/local/bin/a68g --script #
# First define what kind of record (aka LINE) we are piping and filtering #
FORMAT line fmt = $xg$;
MODE
  LINE = STRING,
  PAGE = FLEX[0]LINE,
  BOOK = FLEX[0]PAGE;

PR READ "Iterator_pipe_page.a68" PR
PR READ "Iterator_pipe_operators.a68" PR
PR READ "Iterator_pipe_utilities.a68" PR

PAGE list of computer scientists = (
  "Wil van der Aalst - business process management, process mining, Petri nets",
  "Hal Abelson - intersection of computing and teaching",
  "Serge Abiteboul - database theory",
  "Samson Abramsky - game semantics",
  "Leonard Adleman - RSA, DNA computing",
  "Manindra Agrawal - polynomial-time primality testing",
  "Luis von Ahn - human-based computation",
  "Alfred Aho - compilers book, the 'a' in AWK",
  "Stephen R. Bourne - Bourne shell, portable ALGOL 68C compiler",
  "Kees Koster - ALGOL 68",
  "Lambert Meertens - ALGOL 68, ABC (programming language)",
  "Peter Naur - BNF, ALGOL 60",
  "Guido van Rossum - Python (programming language)",
  "Adriaan van Wijngaarden - Dutch pioneer; ARRA, ALGOL",
  "Dennis E. Wisnosky - Integrated Computer-Aided Manufacturing (ICAM), IDEF",
  "Stephen Wolfram - Mathematica",
  "William Wulf - compilers",
  "Edward Yourdon - Structured Systems Analysis and Design Method",
  "Lotfi Zadeh - fuzzy logic",
  "Arif Zaman - Pseudo-random number generator",
  "Albert Zomaya - Australian pioneer of scheduling in parallel and distributed systems",
  "Konrad Zuse - German pioneer of hardware and software"
);

PAGE algol pioneers list, the scientists list;
PAGE aa;

# Now do a bit of plumbing: #
cat((
    head(4, ) <  list of computer scientists,
    cat(READ list of computer scientists) =: grep("ALGOL", ) =: tee(WRITE algol pioneers list),
    tail(4, READ list of computer scientists)
  )) =: sort =: uniq =: tee(WRITE the scientists list) =: grep("aa", ) >> aa;

# Finally check the result: #
print((
  "Pioneer: ", aa, newline,
  "Number of Algol pioneers: ", whole( UPB algol pioneers list, 0 ), newline,
  "Number of scientists: ", whole( UPB the scientists list, 0 ), newline
))
