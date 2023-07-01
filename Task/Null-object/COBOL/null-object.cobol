       identification division.
       program-id. null-objects.
       remarks. test with cobc -x -j null-objects.cob

       data division.
       working-storage section.
       01 thing-not-thing      usage pointer.

      *> call a subprogram
      *>   with one null pointer
      *>   an omitted parameter
      *>   and expect void return (callee returning omitted)
      *>   and do not touch default return-code (returning nothing)
       procedure division.
       call "test-null" using thing-not-thing omitted returning nothing
       goback.
       end program null-objects.

      *> Test for pointer to null (still a real thing that takes space)
      *>   and an omitted parameter, (call frame has placeholder)
      *>   and finally, return void, (omitted)
       identification division.
       program-id. test-null.

       data division.
       linkage section.
       01 thing-one            usage pointer.
       01 thing-two            pic x.

       procedure division using
           thing-one
           optional thing-two
           returning omitted.

       if thing-one equal null then
           display "thing-one pointer to null" upon syserr
       end-if

       if thing-two omitted then
           display "no thing-two was passed" upon syserr
       end-if
       goback.
       end program test-null.
