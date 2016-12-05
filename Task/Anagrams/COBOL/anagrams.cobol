      *> TECTONICS
      *>   wget http://www.puzzlers.org/pub/wordlists/unixdict.txt
      *>   or visit https://sourceforge.net/projects/souptonuts/files
      *>   or snag ftp://ftp.openwall.com/pub/wordlists/all.gz
      *>      for a 5 million all language word file (a few phrases)
      *>   cobc -xj anagrams.cob [-DMOSTWORDS -DMOREWORDS -DALLWORDS]
      *> ***************************************************************
       identification division.
       program-id. anagrams.

       environment division.
       configuration section.
       repository.
           function all intrinsic.

       input-output section.
       file-control.
           select words-in
           assign to wordfile
           organization is line sequential
           status is words-status
           .

       REPLACE ==:LETTERS:== BY ==42==.

       data division.
       file section.
       fd words-in record is varying from 1 to :LETTERS: characters
                             depending on word-length.
       01 word-record.
          05 word-data         pic x occurs 0 to :LETTERS: times
                                     depending on word-length.

       working-storage section.
       >>IF ALLWORDS DEFINED
       01 wordfile     constant as "/usr/local/share/dict/all.words".
       01 max-words    constant as 4802100.

       >>ELSE-IF MOSTWORDS DEFINED
       01 wordfile     constant as "/usr/local/share/dict/linux.words".
       01 max-words    constant as 628000.

       >>ELSE-IF MOREWORDS DEFINED
       01 wordfile     constant as "/usr/share/dict/words".
       01 max-words    constant as 100000.

       >>ELSE
       01 wordfile     constant as "unixdict.txt".
       01 max-words    constant as 26000.
       >>END-IF

      *> The 5 million word file needs to restrict the word length
       >>IF ALLWORDS DEFINED
       01 max-letters          constant as 26.
       >>ELSE
       01 max-letters          constant as :LETTERS:.
       >>END-IF

       01 word-length          pic 99 comp-5.
       01 words-status         pic xx.
          88 ok-status         values '00' thru '09'.
          88 eof-status        value '10'.

      *> sortable word by letter table
       01 letter-index         usage index.
       01 letter-table.
          05 letters           occurs 1 to max-letters times
                               depending on word-length
                               ascending key letter
                               indexed by letter-index.
             10 letter         pic x.

      *> table of words
       01 sorted-index         usage index.
       01 word-table.
          05 word-list         occurs 0 to max-words times
                               depending on word-tally
                               ascending key sorted-word
                               indexed by sorted-index.
             10 match-count    pic 999 comp-5.
             10 this-word      pic x(max-letters).
             10 sorted-word    pic x(max-letters).
       01 sorted-display       pic x(10).

       01 interest-table.
          05 interest-list     pic 9(8) comp-5
                               occurs 0 to max-words times
                               depending on interest-tally.

       01 outer                pic 9(8) comp-5.
       01 inner                pic 9(8) comp-5.
       01 starter              pic 9(8) comp-5.
       01 ender                pic 9(8) comp-5.
       01 word-tally           pic 9(8) comp-5.
       01 interest-tally       pic 9(8) comp-5.
       01 tally-display        pic zz,zzz,zz9.

       01 most-matches         pic 99 comp-5.
       01 matches              pic 99 comp-5.
       01 match-display        pic z9.

      *> timing display
       01 time-stamp.
          05 filler            pic x(11).
          05 timer-hours       pic 99.
          05 filler            pic x.
          05 timer-minutes     pic 99.
          05 filler            pic x.
          05 timer-seconds     pic 99.
          05 filler            pic x.
          05 timer-subsec      pic v9(6).
       01 timer-elapsed        pic 9(6)v9(6).
       01 timer-value          pic 9(6)v9(6).
       01 timer-display        pic zzz,zz9.9(6).

      *> ***************************************************************
       procedure division.
       main-routine.

       >>IF ALLWORDS DEFINED
           display "** Words limited to " max-letters " letters **"
       >>END-IF

       perform show-time

       perform load-words
       perform find-most
       perform display-result

       perform show-time
       goback
       .

      *> ***************************************************************
       load-words.
       open input words-in
       if not ok-status then
           display "error opening " wordfile upon syserr
           move 1 to return-code
           goback
       end-if

       perform until exit
           read words-in
           if eof-status then exit perform end-if
           if not ok-status then
               display wordfile " read error: " words-status upon syserr
           end-if

           if word-length equal zero then exit perform cycle end-if

       >>IF ALLWORDS DEFINED
           move min(word-length, max-letters) to word-length
       >>END-IF

           add 1 to word-tally
           move word-record to this-word(word-tally) letter-table
           sort letters ascending key letter
           move letter-table to sorted-word(word-tally)
       end-perform

       move word-tally to tally-display
       display trim(tally-display) " words" with no advancing

       close words-in
       if not ok-status then
           display "error closing " wordfile upon syserr
           move 1 to return-code
       end-if

      *> sort word list by anagram check field
       sort word-list ascending key sorted-word
       .

      *> first entry in a list will end up with highest match count
       find-most.
       perform varying outer from 1 by 1 until outer > word-tally
           move 1 to matches
           add 1 to outer giving starter
           perform varying inner from starter by 1
                   until sorted-word(inner) not equal sorted-word(outer)
               add 1 to matches
           end-perform
           if matches > most-matches then
               move matches to most-matches
               initialize interest-table all to value
               move 0 to interest-tally
           end-if
           move matches to match-count(outer)
           if matches = most-matches then
               add 1 to interest-tally
               move outer to interest-list(interest-tally)
           end-if
       end-perform
       .

      *> only display the words with the most anagrams
       display-result.
       move interest-tally to tally-display
       move most-matches to match-display
       display ", most anagrams: " trim(match-display)
               ", with " trim(tally-display) " set" with no advancing
       if interest-tally not equal 1 then
           display "s" with no advancing
       end-if
       display " of interest"

       perform varying outer from 1 by 1 until outer > interest-tally
           move sorted-word(interest-list(outer)) to sorted-display
           display sorted-display
                   " [" trim(this-word(interest-list(outer)))
              with no advancing
           add 1 to interest-list(outer) giving starter
           add most-matches to interest-list(outer) giving ender
           perform varying inner from starter by 1
               until inner = ender
                   display ", " trim(this-word(inner))
                      with no advancing
           end-perform
           display "]"
       end-perform
       .

      *> elapsed time
       show-time.
       move formatted-current-date("YYYY-MM-DDThh:mm:ss.ssssss")
         to time-stamp
       compute timer-value = timer-hours * 3600 + timer-minutes * 60
                             + timer-seconds + timer-subsec
       if timer-elapsed = 0 then
           display time-stamp
           move timer-value to timer-elapsed
       else
           if timer-value < timer-elapsed then
               add 86400 to timer-value
           end-if
           subtract timer-elapsed from timer-value
           move timer-value to timer-display
           display time-stamp ", " trim(timer-display) " seconds"
       end-if
       .

       end program anagrams.
