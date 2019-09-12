report z_bitwise_operations.

class hex_converter definition.
  public section.
    class-methods:
      to_binary
        importing
          hex_value           type x
        returning
          value(binary_value) type string,

      to_decimal
        importing
          hex_value            type x
        returning
          value(decimal_value) type int4.
endclass.


class hex_converter implementation.
  method to_binary.
    data(number_of_bits) = xstrlen( hex_value ) * 8.

    do number_of_bits times.
      get bit sy-index of hex_value into data(bit).

      binary_value = |{ binary_value }{ bit }|.
    enddo.
  endmethod.


  method to_decimal.
    decimal_value = hex_value.
  endmethod.
endclass.


class missing_bitwise_operations definition.
  public section.
    class-methods:
      arithmetic_shift_left
        importing
          old_value   type x
          change_with type x
        exporting
          new_value   type x,

      arithmetic_shift_right
        importing
          old_value   type x
          change_with type x
        exporting
          new_value   type x,

      logical_shift_left
        importing
          old_value   type x
          change_with type x
        exporting
          new_value   type x,

      logical_shift_right
        importing
          old_value   type x
          change_with type x
        exporting
          new_value   type x,

      rotate_left
        importing
          old_value   type x
          change_with type x
        exporting
          new_value   type x,

      rotate_right
        importing
          old_value   type x
          change_with type x
        exporting
          new_value   type x.
endclass.


class missing_bitwise_operations implementation.
  method arithmetic_shift_left.
    clear new_value.

    new_value = old_value * 2 ** change_with.
  endmethod.


  method arithmetic_shift_right.
    clear new_value.

    new_value = old_value div 2 ** change_with.
  endmethod.


  method logical_shift_left.
    clear new_value.

    data(bits) = hex_converter=>to_binary( old_value ).

    data(length_of_bit_sequence) = strlen( bits ).

    bits = shift_left(
      val = bits
      places = change_with ).

    while strlen( bits ) < length_of_bit_sequence.
      bits = |{ bits }0|.
    endwhile.

    do strlen( bits ) times.
      data(index) = sy-index - 1.

      data(current_bit) = bits+index(1).

      if current_bit eq `1`.
        set bit sy-index of new_value.
      endif.
    enddo.
  endmethod.


  method logical_shift_right.
    clear new_value.

    data(bits) = hex_converter=>to_binary( old_value ).

    data(length_of_bit_sequence) = strlen( bits ).

    bits = shift_right(
      val = bits
      places = change_with ).

    while strlen( bits ) < length_of_bit_sequence.
      bits = |0{ bits }|.
    endwhile.

    do strlen( bits ) times.
      data(index) = sy-index - 1.

      data(current_bit) = bits+index(1).

      if current_bit eq `1`.
        set bit sy-index of new_value.
      endif.
    enddo.
  endmethod.


  method rotate_left.
    clear new_value.

    data(bits) = hex_converter=>to_binary( old_value ).

    bits = shift_left(
      val = bits
      circular = change_with ).

    do strlen( bits ) times.
      data(index) = sy-index - 1.

      data(current_bit) = bits+index(1).

      if current_bit eq `1`.
        set bit sy-index of new_value.
      endif.
    enddo.
  endmethod.


  method rotate_right.
    clear new_value.

    data(bits) = hex_converter=>to_binary( old_value ).

    bits = shift_right(
      val = bits
      circular = change_with ).

    do strlen( bits ) times.
      data(index) = sy-index - 1.

      data(current_bit) = bits+index(1).

      if current_bit eq `1`.
        set bit sy-index of new_value.
      endif.
    enddo.
  endmethod.
endclass.


start-of-selection.
  data:
    a      type x length 4 value 255,
    b      type x length 4 value 2,
    result type x length 4.

  write: |a         -> { a }, { hex_converter=>to_binary( a ) }, { hex_converter=>to_decimal( a ) }|, /.

  write: |b         -> { b }, { hex_converter=>to_binary( b ) }, { hex_converter=>to_decimal( b ) }|, /.

  result = a bit-and b.
  write: |a & b     -> { result }, { hex_converter=>to_binary( result ) }, { hex_converter=>to_decimal( result ) }|, /.

  result = a bit-or b.
  write: |a \| b     -> { result }, { hex_converter=>to_binary( result ) }, { hex_converter=>to_decimal( result ) }|, /.

  result = a bit-xor b.
  write: |a ^ b     -> { result }, { hex_converter=>to_binary( result ) }, { hex_converter=>to_decimal( result ) }|, /.

  result = bit-not a.
  write: |~a        -> { result }, { hex_converter=>to_binary( result ) }, { hex_converter=>to_decimal( result ) }|, /.

  missing_bitwise_operations=>arithmetic_shift_left(
    exporting
      old_value = bit-not a
      change_with = b
    importing
      new_value = result ).
  write: |~a << b   -> { result }, { hex_converter=>to_binary( result ) }, { hex_converter=>to_decimal( result ) }|, /.

  missing_bitwise_operations=>arithmetic_shift_right(
    exporting
      old_value = bit-not a
      change_with = b
    importing
      new_value = result ).
  write: |~a >> b   -> { result }, { hex_converter=>to_binary( result ) }, { hex_converter=>to_decimal( result ) }|, /.

  missing_bitwise_operations=>logical_shift_left(
    exporting
      old_value = a
      change_with = b
    importing
      new_value = result ).
  write: |a <<< b   -> { result }, { hex_converter=>to_binary( result ) }, { hex_converter=>to_decimal( result ) }|, /.

  missing_bitwise_operations=>logical_shift_right(
    exporting
      old_value = bit-not a
      change_with = b
    importing
      new_value = result ).
  write: |~a >>> b  -> { result }, { hex_converter=>to_binary( result ) }, { hex_converter=>to_decimal( result ) }|, /.

  missing_bitwise_operations=>rotate_left(
    exporting
      old_value = bit-not a
      change_with = b
    importing
      new_value = result ).
  write: |~a rotl b -> { result }, { hex_converter=>to_binary( result ) }, { hex_converter=>to_decimal( result ) }|, /.

  missing_bitwise_operations=>rotate_right(
    exporting
      old_value = a
      change_with = b
    importing
      new_value = result ).
  write: |a rotr b  -> { result }, { hex_converter=>to_binary( result ) }, { hex_converter=>to_decimal( result ) }|, /.
