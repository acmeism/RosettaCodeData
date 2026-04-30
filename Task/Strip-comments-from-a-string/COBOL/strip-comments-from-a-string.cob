       identification division.
       program-id. StripComments.

       data division.
       working-storage section.
       01  line-text              pic x(64).

       procedure division.
       main.
           move "apples, pears # and bananas" to line-text
           perform show-striped-text

           move "apples, pears ; and bananas" to line-text
           perform show-striped-text

           stop run
           .
       show-striped-text.
           unstring line-text delimited by "#" or ";" into line-text
           display quote, function trim(line-text), quote
           .
