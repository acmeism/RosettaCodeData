report z_stack.

interface stack.
  methods:
    push
      importing
        new_element      type any
      returning
        value(new_stack) type ref to stack,

    pop
      exporting
        top_element      type any
      returning
        value(new_stack) type ref to stack,

    empty
      returning
        value(is_empty) type abap_bool,

    peek
      exporting
        top_element type any,

    get_size
      returning
        value(size) type int4,

    stringify
      returning
        value(stringified_stack) type string.
endinterface.


class character_stack definition.
  public section.
    interfaces:
      stack.


    methods:
      constructor
        importing
          characters type string optional.


  private section.
    data:
      characters type string.
endclass.


class character_stack implementation.
  method stack~push.
    characters = |{ new_element }{ characters }|.

    new_stack = me.
  endmethod.


  method stack~pop.
    if not me->stack~empty( ).
      top_element = me->characters(1).

      me->characters = me->characters+1.
    endif.

    new_stack = me.
  endmethod.


  method stack~empty.
    is_empty = xsdbool( strlen( me->characters ) eq 0 ).
  endmethod.


  method stack~peek.
    check not me->stack~empty( ).

    top_element = me->characters(1).
  endmethod.


  method stack~get_size.
    size = strlen( me->characters ).
  endmethod.


  method stack~stringify.
    stringified_stack = cond string(
      when me->stack~empty( )
      then `empty`
      else me->characters ).
  endmethod.


  method constructor.
    check characters is not initial.

    me->characters = characters.
  endmethod.
endclass.


class integer_stack definition.
  public section.
    interfaces:
      stack.


    methods:
      constructor
        importing
          integers type int4_table optional.


  private section.
    data:
      integers type int4_table.
endclass.


class integer_stack implementation.
  method stack~push.
    append new_element to me->integers.

    new_stack = me.
  endmethod.


  method stack~pop.
    if not me->stack~empty( ).
      top_element = me->integers[ me->stack~get_size( ) ].

      delete me->integers index me->stack~get_size( ).
    endif.

    new_stack = me.
  endmethod.


  method stack~empty.
    is_empty = xsdbool( lines( me->integers ) eq 0 ).
  endmethod.


  method stack~peek.
    check not me->stack~empty( ).

    top_element = me->integers[ lines( me->integers ) ].
  endmethod.


  method stack~get_size.
    size = lines( me->integers ).
  endmethod.


  method stack~stringify.
    stringified_stack = cond string(
      when me->stack~empty( )
      then `empty`
      else reduce string(
        init stack = ``
        for integer in me->integers
        next stack = |{ integer }{ stack }| ) ).
  endmethod.


  method constructor.
    check integers is not initial.

    me->integers = integers.
  endmethod.
endclass.


start-of-selection.
  data:
    stack1        type ref to stack,
    stack2        type ref to stack,
    stack3        type ref to stack,

    top_character type char1,
    top_integer   type int4.

  stack1 = new character_stack( ).
  stack2 = new integer_stack( ).
  stack3 = new integer_stack( ).

  write: |Stack1 = { stack1->stringify( ) }|, /.
  stack1->push( 'a' )->push( 'b' )->push( 'c' )->push( 'd' ).
  write: |push a, push b, push c, push d -> Stack1 = { stack1->stringify( ) }|, /.
  stack1->pop( )->pop( importing top_element = top_character ).
  write: |pop, pop and return element -> { top_character }, Stack1 = { stack1->stringify( ) }|, /, /.

  write: |Stack2 = { stack2->stringify( ) }|, /.
  stack2->push( 1 )->push( 2 )->push( 3 )->push( 4 ).
  write: |push 1, push 2, push 3, push 4 -> Stack2 = { stack2->stringify( ) }|, /.
  stack2->pop( )->pop( importing top_element = top_integer ).
  write: |pop, pop and return element -> { top_integer }, Stack2 = { stack2->stringify( ) }|, /, /.

  write: |Stack3 = { stack3->stringify( ) }|, /.
  stack3->pop( ).
  write: |pop -> Stack3 = { stack3->stringify( ) }|, /, /.
