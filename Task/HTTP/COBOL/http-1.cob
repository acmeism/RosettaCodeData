COBOL  >>SOURCE FORMAT IS FIXED
       identification division.
       program-id. curl-rosetta.

       environment division.
       configuration section.
       repository.
           function read-url
           function all intrinsic.

       data division.
       working-storage section.

       copy "gccurlsym.cpy".

       01 web-page             pic x(16777216).
       01 curl-status          usage binary-long.

       01 cli                  pic x(7) external.
          88 helping           values "-h", "-help", "help", spaces.
          88 displaying        value "display".
          88 summarizing       value "summary".

      *> ***************************************************************
       procedure division.
       accept cli from command-line
       if helping then
           display "./curl-rosetta [help|display|summary]"
           goback
       end-if

      *>
      *> Read a web resource into fixed ram.
      *>   Caller is in charge of sizing the buffer,
      *>     (or getting trickier with the write callback)
      *> Pass URL and working-storage variable,
      *>   get back libcURL error code or 0 for success

       move read-url("http://www.rosettacode.org", web-page)
         to curl-status

       perform check
       perform show

       goback.
      *> ***************************************************************

      *> Now tesing the result, relying on the gccurlsym
      *>   GnuCOBOL Curl Symbol copy book
       check.
       if curl-status not equal zero then
           display
               curl-status " "
               CURLEMSG(curl-status) upon syserr
       end-if
       .

      *> And display the page
       show.
       if summarizing then
           display "Length: " stored-char-length(web-page)
       end-if
       if displaying then
           display trim(web-page trailing) with no advancing
       end-if
       .

       REPLACE ALSO ==:EXCEPTION-HANDLERS:== BY
       ==
      *> informational warnings and abends
       soft-exception.
         display space upon syserr
         display "--Exception Report-- " upon syserr
         display "Time of exception:   " current-date upon syserr
         display "Module:              " module-id upon syserr
         display "Module-path:         " module-path upon syserr
         display "Module-source:       " module-source upon syserr
         display "Exception-file:      " exception-file upon syserr
         display "Exception-status:    " exception-status upon syserr
         display "Exception-location:  " exception-location upon syserr
         display "Exception-statement: " exception-statement upon syserr
       .

       hard-exception.
           perform soft-exception
           stop run returning 127
       .
       ==.

       end program curl-rosetta.
      *> ***************************************************************

      *> ***************************************************************
      *>
      *> The function hiding all the curl details
      *>
      *> Purpose:   Call libcURL and read into memory
      *> ***************************************************************
       identification division.
       function-id. read-url.

       environment division.
       configuration section.
       repository.
           function all intrinsic.

       data division.
       working-storage section.

       copy "gccurlsym.cpy".

       replace also ==:CALL-EXCEPTION:== by
       ==
           on exception
               perform hard-exception
       ==.

       01 curl-handle          usage pointer.
       01 callback-handle      usage procedure-pointer.
       01 memory-block.
          05 memory-address    usage pointer sync.
          05 memory-size       usage binary-long sync.
          05 running-total     usage binary-long sync.
       01 curl-result          usage binary-long.

       01 cli                  pic x(7) external.
          88 helping           values "-h", "-help", "help", spaces.
          88 displaying        value "display".
          88 summarizing       value "summary".

       linkage section.
       01 url                  pic x any length.
       01 buffer               pic x any length.
       01 curl-status          usage binary-long.

      *> ***************************************************************
       procedure division using url buffer returning curl-status.
       if displaying or summarizing then
           display "Read: " url upon syserr
       end-if

      *> initialize libcurl, hint at missing library if need be
       call "curl_global_init" using by value CURL_GLOBAL_ALL
           on exception
               display
                   "need libcurl, link with -lcurl" upon syserr
               stop run returning 1
       end-call

      *> initialize handle
       call "curl_easy_init" returning curl-handle
           :CALL-EXCEPTION:
       end-call
       if curl-handle equal NULL then
           display "no curl handle" upon syserr
           stop run returning 1
       end-if

      *> Set the URL
       call "curl_easy_setopt" using
           by value curl-handle
           by value CURLOPT_URL
           by reference concatenate(trim(url trailing), x"00")
           :CALL-EXCEPTION:
       end-call

      *> follow all redirects
       call "curl_easy_setopt" using
           by value curl-handle
           by value CURLOPT_FOLLOWLOCATION
           by value 1
           :CALL-EXCEPTION:
       end-call

      *> set the call back to write to memory
       set callback-handle to address of entry "curl-write-callback"
       call "curl_easy_setopt" using
           by value curl-handle
           by value CURLOPT_WRITEFUNCTION
           by value callback-handle
           :CALL-EXCEPTION:
       end-call

      *> set the curl handle data handling structure
       set memory-address to address of buffer
       move length(buffer) to memory-size
       move 1 to running-total

       call "curl_easy_setopt" using
           by value curl-handle
           by value CURLOPT_WRITEDATA
           by value address of memory-block
           :CALL-EXCEPTION:
       end-call

      *> some servers demand an agent
       call "curl_easy_setopt" using
           by value curl-handle
           by value CURLOPT_USERAGENT
           by reference concatenate("libcurl-agent/1.0", x"00")
           :CALL-EXCEPTION:
       end-call

      *> let curl do all the hard work
       call "curl_easy_perform" using
           by value curl-handle
           returning curl-result
           :CALL-EXCEPTION:
       end-call

      *> the call back will handle filling ram, return the result code
       move curl-result to curl-status

      *> curl clean up, more important if testing cookies
       call "curl_easy_cleanup" using
           by value curl-handle
           returning omitted
           :CALL-EXCEPTION:
       end-call

       goback.

       :EXCEPTION-HANDLERS:

       end function read-url.
      *> ***************************************************************

      *> ***************************************************************
      *> Supporting libcurl callback
       identification division.
       program-id. curl-write-callback.

       environment division.
       configuration section.
       repository.
           function all intrinsic.

       data division.
       working-storage section.
       01 real-size            usage binary-long.

      *> libcURL will pass a pointer to this structure in the callback
       01 memory-block         based.
          05 memory-address    usage pointer sync.
          05 memory-size       usage binary-long sync.
          05 running-total     usage binary-long sync.

       01 content-buffer       pic x(65536) based.
       01 web-space            pic x(16777216) based.
       01 left-over            usage binary-long.

       linkage section.
       01 contents             usage pointer.
       01 element-size         usage binary-long.
       01 element-count        usage binary-long.
       01 memory-structure     usage pointer.

      *> ***************************************************************
       procedure division
           using
              by value contents
              by value element-size
              by value element-count
              by value memory-structure
          returning real-size.

       set address of memory-block to memory-structure
       compute real-size = element-size * element-count end-compute

      *> Fence off the end of buffer
       compute
           left-over = memory-size - running-total
       end-compute
       if left-over > 0 and < real-size then
           move left-over to real-size
       end-if

      *> if there is more buffer, and data not zero length
       if (left-over > 0) and (real-size > 1) then
           set address of content-buffer to contents
           set address of web-space to memory-address

           move content-buffer(1:real-size)
             to web-space(running-total:real-size)

           add real-size to running-total
       else
           display "curl buffer sizing problem" upon syserr
       end-if

       goback.
       end program curl-write-callback.
