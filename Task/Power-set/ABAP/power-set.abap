report z_powerset.

interface set.
  methods:
    add_element
      importing
        element_to_be_added type any
      returning
        value(new_set)      type ref to set,

    remove_element
      importing
        element_to_be_removed type any
      returning
        value(new_set)        type ref to set,

    contains_element
      importing
        element_to_be_found type any
      returning
        value(contains)     type abap_bool,

    get_size
      returning
        value(size) type int4,

    is_equal
      importing
        set_to_be_compared_with type ref to set
      returning
        value(equal)            type abap_bool,

    get_elements
      exporting
        elements type any table,

    stringify
      returning
        value(stringified_set) type string.
endinterface.


class string_set definition.
  public section.
    interfaces:
      set.


    methods:
      constructor
        importing
          elements type stringtab optional,

      build_powerset
        returning
          value(powerset) type ref to string_set.


  private section.
    data elements type stringtab.
endclass.


class string_set implementation.
  method constructor.
    loop at elements into data(element).
      me->set~add_element( element ).
    endloop.
  endmethod.


  method set~add_element.
    if not line_exists( me->elements[ table_line = element_to_be_added ] ).
      append element_to_be_added to me->elements.
    endif.

    new_set = me.
  endmethod.


  method set~remove_element.
    if line_exists( me->elements[ table_line = element_to_be_removed ] ).
      delete me->elements where table_line = element_to_be_removed.
    endif.

    new_set = me.
  endmethod.


  method set~contains_element.
    contains = cond abap_bool(
      when line_exists( me->elements[ table_line = element_to_be_found ] )
      then abap_true
      else abap_false ).
  endmethod.


  method set~get_size.
    size = lines( me->elements ).
  endmethod.


  method set~is_equal.
    if set_to_be_compared_with->get_size( ) ne me->set~get_size( ).
      equal = abap_false.

      return.
    endif.

    loop at me->elements into data(element).
      if not set_to_be_compared_with->contains_element( element ).
        equal = abap_false.

        return.
      endif.
    endloop.

    equal = abap_true.
  endmethod.


  method set~get_elements.
    elements = me->elements.
  endmethod.


  method set~stringify.
    stringified_set = cond string(
      when me->elements is initial
      then `∅`
      when me->elements eq value stringtab( ( `∅` ) )
      then `{ ∅ }`
      else reduce string(
        init result = `{ `
        for element in me->elements
        next result = cond string(
          when element eq ``
          then |{ result }∅, |
          when strlen( element ) eq 1 and element ne `∅`
          then |{ result }{ element }, |
          else |{ result }\{{ element }\}, | ) ) ).

    stringified_set = replace(
      val = stringified_set
      regex = `, $`
      with = ` }`).
  endmethod.


  method build_powerset.
    data(powerset_elements) = value stringtab( ( `` ) ).

    loop at me->elements into data(element).
      do lines( powerset_elements ) times.
        if powerset_elements[ sy-index ] ne `∅`.
          append |{ powerset_elements[ sy-index ] }{ element }| to powerset_elements.
        else.
          append element to powerset_elements.
        endif.
      enddo.
    endloop.

    powerset = new string_set( powerset_elements ).
  endmethod.
endclass.


start-of-selection.
  data(set1) = new string_set( ).
  data(set2) = new string_set( ).
  data(set3) = new string_set( ).

  write: |𝑷( { set1->set~stringify( ) } ) -> { set1->build_powerset( )->set~stringify( ) }|, /.

  set2->set~add_element( `∅` ).
  write: |𝑷( { set2->set~stringify( ) } ) -> { set2->build_powerset( )->set~stringify( ) }|, /.

  set3->set~add_element( `1` )->add_element( `2` )->add_element( `3` )->add_element( `3` )->add_element( `4`
    )->add_element( `4` )->add_element( `4` ).
  write: |𝑷( { set3->set~stringify( ) } ) -> { set3->build_powerset( )->set~stringify( ) }|, /.
