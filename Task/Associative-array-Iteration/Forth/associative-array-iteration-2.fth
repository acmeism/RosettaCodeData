\ Written in ANS-Forth; tested under VFX.
\ Requires the novice package: http://www.forth.org/novice.html
\ The following should already be done:
\ include novice.4th
\ include association.4th

\ I would define high-level languages as those that allow programs to be written without explicit iteration. Iteration is a major source of bugs.
\ The example from the FFL library doesn't hide iteration, whereas this example from the novice-package does.


marker AssociationIteration.4th

\ ******
\ ****** The following defines a node in an association (each node is derived from ELEMENT).
\ ******

element
    w field .inventor
constant language           \ describes a programming language

: init-language ( inventor name node -- node )
    init-element >r
    hstr r@ .inventor !
    r> ;

: new-language ( inventor name -- node )
    language alloc
    init-language ;

: show-language ( count node -- )
    >r
    1+                      \ -- count+1
    cr  r@ .key @ count colorless type  ." invented by: "  r@ .inventor @ count type
    rdrop ;

: show-languages-forward ( handle -- )
    0                       \ -- handle count
    swap .root @  ['] show-language  walk>
    cr ." count: " .
    cr ;

: show-languages-backward ( handle -- )
    0                       \ -- handle count
    swap .root @  ['] show-language  <walk
    cr ." count: " .
    cr ;

: kill-language-attachments ( node -- )
    dup .inventor @  dealloc
    kill-key ;

: copy-language-attachments ( src dst -- )
    over .inventor @  hstr
    over .inventor !
    copy-key ;


\ ******
\ ****** The following defines the association itself (the handle).
\ ******

association
constant languages          \ describes a set of programming languages

: init-languages ( record -- record )
    >r
    ['] compare  ['] kill-language-attachments  ['] copy-language-attachments
    r> init-association ;

: new-languages ( -- record )
    languages alloc
    init-languages ;


\ ******
\ ****** The following filters one association into another, including everything that matches a particular inventor.
\ ******

: <filter-inventor> { inventor handle new-handle node -- inventor handle new-handle }
    inventor count  node .inventor @ count  compare  A=B = if
        node handle dup-element  new-handle insert  then
    inventor handle new-handle ;

: filter-inventor ( inventor handle -- new-handle )
    dup similar-association                             \ -- inventor handle new-handle
    over .root @  ['] <filter-inventor>  walk>          \ -- inventor handle new-handle
    nip nip ;

\ ******
\ ****** The following is a demonstration with some sample data.
\ ******


new-languages
    c" Moore, Chuck"                c" Forth     "      new-language  over insert
    c" Ichiah, Jean"                c" Ada       "      new-language  over insert
    c" Wirth, Niklaus"              c" Pascal    "      new-language  over insert
    c" Wirth, Niklaus"              c" Oberon    "      new-language  over insert
    c" McCarthy, John"              c" Lisp      "      new-language  over insert
    c" van Rossum, Guido"           c" Python    "      new-language  over insert
    c" Gosling, Jim"                c" Java      "      new-language  over insert
    c" Ierusalimschy, Roberto"      c" Lua       "      new-language  over insert
    c" Matsumoto, Yukihiro"         c" Ruby      "      new-language  over insert
    c" Pestov, Slava"               c" Factor    "      new-language  over insert
    c" Gosling, James"              c" Java      "      new-language  over insert
    c" Wirth, Niklaus"              c" Modula-2  "      new-language  over insert
    c" Ritchie, Dennis"             c" C         "      new-language  over insert
    c" Stroustrup, Bjarne"          c" C++       "      new-language  over insert
constant some-languages


cr .( everything in SOME-LANGUAGES ordered forward: )

some-languages show-languages-forward


cr .( everything in SOME-LANGUAGES ordered backward: )

some-languages show-languages-backward


cr .( everything in SOME-LANGUAGES invented by Wirth: )

c" Wirth, Niklaus" some-languages filter-inventor           dup show-languages-forward  kill-association


cr .( everything in SOME-LANGUAGES within 'F' and 'L': )

c" F"  c" L"  some-languages  filter within                 dup show-languages-forward  kill-association


cr .( everything in SOME-LANGUAGES not within 'F' and 'L': )

c" F"  c" L"  some-languages  filter without                dup show-languages-forward  kill-association


some-languages kill-association
