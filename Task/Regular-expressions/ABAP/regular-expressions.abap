DATA: text TYPE string VALUE 'This is a Test'.

FIND FIRST OCCURRENCE OF REGEX 'is' IN text.
IF sy-subrc = 0.
  cl_demo_output=>write( 'Regex matched' ).
ENDIF.

REPLACE ALL OCCURRENCES OF REGEX '[t|T]est' IN text WITH 'Regex'.

cl_demo_output=>write( text ).
cl_demo_output=>display( ).
