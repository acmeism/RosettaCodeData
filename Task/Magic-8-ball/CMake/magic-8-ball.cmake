CMAKE_MINIMUM_REQUIRED(VERSION 3.6)

PROJECT(EightBall)

SET(CMAKE_DISABLE_SOURCE_CHANGES ON)
SET(CMAKE_DISABLE_IN_SOURCE_BUILD ON)

LIST(APPEND RESPONSES "It is certain." "It is decidedly so." "Without a doubt.")
LIST(APPEND RESPONSES "Yes - definitely." "You may rely on it.")
LIST(APPEND RESPONSES "As I see it yes." "Most likely." "Outlook good.")
LIST(APPEND RESPONSES "Yes." "Signs point to yes." "Reply hazy try again.")
LIST(APPEND RESPONSES "Ask again later." "Better not tell you now.")
LIST(APPEND RESPONSES "Cannot predict now." "Concentrate and ask again.")
LIST(APPEND RESPONSES "Don't count on it." "My reply is no.")
LIST(APPEND RESPONSES "My sources say no." "Outlook not so good." "Very doubtful.")

FUNCTION(RANDOM_RESPONSE)
    STRING(RANDOM LENGTH 1 ALPHABET 01 TENS)
    STRING(RANDOM LENGTH 1 ALPHABET 0123456789 UNITS)
    MATH(EXPR INDEX "${TENS}${UNITS}")
    LIST(GET RESPONSES ${INDEX} RESPONSE)
    MESSAGE(STATUS "Question: ${QUESTION}")
    MESSAGE(STATUS "Response: ${RESPONSE}")
ENDFUNCTION(RANDOM_RESPONSE)

OPTION(QUESTION "User's input question" "")

MESSAGE("===================== 8 Ball =====================")
IF(NOT QUESTION)
    MESSAGE(STATUS "Welcome to 8 ball! Please provide a question ")
    MESSAGE(STATUS "using the flag -DQUESTION=\"my question\"")
ELSE()
    RANDOM_RESPONSE()
ENDIF()
MESSAGE("==================================================")


ADD_CUSTOM_TARGET(${PROJECT_NAME} ALL)
