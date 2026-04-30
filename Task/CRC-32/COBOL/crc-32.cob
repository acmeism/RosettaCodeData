      *> tectonics: cobc -xj crc32-zlib.cob -lz
       identification division.
       program-id. rosetta-crc32.

       environment division.
       configuration section.
       repository.
           function all intrinsic.

       data division.
       working-storage section.
       01 crc32-initial        usage binary-c-long.
       01 crc32-result         usage binary-c-long unsigned.
       01 crc32-input.
          05 value "The quick brown fox jumps over the lazy dog".
       01 crc32-hex            usage pointer.

       procedure division.
       crc32-main.

      *> libz crc32
       call "crc32" using
           by value crc32-initial
           by reference crc32-input
           by value length(crc32-input)
           returning crc32-result
           on exception
               display "error: no crc32 zlib linkage" upon syserr
       end-call
       call "printf" using "checksum: %lx" & x"0a" by value crc32-result

      *> GnuCOBOL pointers are displayed in hex by default
       set crc32-hex up by crc32-result
       display 'crc32 of "' crc32-input '" is ' crc32-hex

       goback.
       end program rosetta-crc32.
