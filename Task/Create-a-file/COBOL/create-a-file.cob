       identification division.
       program-id. create-a-file.

       data division.
       working-storage section.
       01 skip                 pic 9 value 2.
       01 file-name.
          05 value "/output.txt".
       01 dir-name.
          05 value "/docs".
       01 file-handle          usage binary-long.

       procedure division.
       files-main.

      *> create in current working directory
       perform create-file-and-dir

      *> create in root of file system, will fail without privilege
       move 1 to skip
       perform create-file-and-dir

       goback.

       create-file-and-dir.
      *> create file in current working dir, for read/write
       call "CBL_CREATE_FILE" using file-name(skip:) 3 0 0 file-handle
       if return-code not equal 0 then
           display "error: CBL_CREATE_FILE " file-name(skip:) ": "
                   file-handle ", " return-code upon syserr
       end-if

      *> create dir below current working dir, owner/group read/write
       call "CBL_CREATE_DIR" using dir-name(skip:)
       if return-code not equal 0 then
           display "error: CBL_CREATE_DIR " dir-name(skip:) ": "
                   return-code upon syserr
       end-if
       .

       end program create-a-file.
