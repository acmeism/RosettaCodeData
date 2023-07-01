report z_dutch_national_flag_problem.

interface sorting_problem.
  methods:
    generate_unsorted_sequence
      importing
        lenght_of_sequence       type int4
      returning
        value(unsorted_sequence) type string,

    sort_sequence
      changing
        sequence_to_be_sorted type string,

    is_sorted
      importing
        sequence_to_check type string
      returning
        value(sorted)     type abap_bool.
endinterface.


class dutch_national_flag_problem definition.
  public section.
    interfaces:
      sorting_problem.


    constants:
      begin of dutch_flag_colors,
        red   type char1 value 'R',
        white type char1 value 'W',
        blue  type char1 value 'B',
      end of dutch_flag_colors.
endclass.


class dutch_national_flag_problem implementation.
  method sorting_problem~generate_unsorted_sequence.
    data(random_int_generator) = cl_abap_random_int=>create(
      seed = cl_abap_random=>seed( )
      min = 0
      max = 2 ).

    do lenght_of_sequence - 1 times.
      data(random_int) = random_int_generator->get_next( ).

      data(next_color) = cond char1(
        when random_int eq 0 then dutch_flag_colors-red
        when random_int eq 1 then dutch_flag_colors-white
        when random_int eq 2 then dutch_flag_colors-blue ).

      unsorted_sequence = |{ unsorted_sequence }{ next_color }|.
    enddo.

    if strlen( unsorted_sequence ) > 0.
      random_int = random_int_generator->get_next( ).

      next_color = cond char1(
        when random_int eq 0 or random_int eq 2 then dutch_flag_colors-red
        when random_int eq 1 then dutch_flag_colors-white ).

      unsorted_sequence = |{ unsorted_sequence }{ next_color }|.
    endif.
  endmethod.


  method sorting_problem~sort_sequence.
    data(low_index) = 0.
    data(middle_index) = 0.
    data(high_index) = strlen( sequence_to_be_sorted ) - 1.

    while middle_index <= high_index.
      data(current_color) = sequence_to_be_sorted+middle_index(1).

      if current_color eq dutch_flag_colors-red.
        data(buffer) = sequence_to_be_sorted+low_index(1).

        sequence_to_be_sorted = replace(
          val = sequence_to_be_sorted
          off = middle_index
          len = 1
          with = buffer ).

        sequence_to_be_sorted = replace(
          val = sequence_to_be_sorted
          off = low_index
          len = 1
          with = current_color ).

        low_index = low_index + 1.

        middle_index = middle_index + 1.
      elseif current_color eq dutch_flag_colors-blue.
        buffer = sequence_to_be_sorted+high_index(1).

        sequence_to_be_sorted = replace(
          val = sequence_to_be_sorted
          off = middle_index
          len = 1
          with = buffer ).

        sequence_to_be_sorted = replace(
          val = sequence_to_be_sorted
          off = high_index
          len = 1
          with = current_color ).

        high_index = high_index - 1.
      else.
        middle_index = middle_index + 1.
      endif.
    endwhile.
  endmethod.


  method sorting_problem~is_sorted.
    sorted = abap_true.

    do strlen( sequence_to_check ) - 1 times.
      data(current_character_index) = sy-index - 1.
      data(current_color) = sequence_to_check+current_character_index(1).
      data(next_color) = sequence_to_check+sy-index(1).

      sorted = cond abap_bool(
        when ( current_color eq dutch_flag_colors-red and
               ( next_color eq current_color or
                 next_color eq dutch_flag_colors-white or
                 next_color eq dutch_flag_colors-blue ) )
             or
             ( current_color eq dutch_flag_colors-white and
               ( next_color eq current_color or
                 next_color eq dutch_flag_colors-blue ) )
             or
             ( current_color eq dutch_flag_colors-blue and
               current_color eq next_color )
        then sorted
        else abap_false ).

      check sorted eq abap_false.
      return.
    enddo.
  endmethod.
endclass.


start-of-selection.
  data dutch_national_flag_problem type ref to sorting_problem.

  dutch_national_flag_problem = new dutch_national_flag_problem( ).

  data(sequence) = dutch_national_flag_problem->generate_unsorted_sequence( 20 ).

  write:|{ sequence }, is sorted? -> { dutch_national_flag_problem->is_sorted( sequence ) }|, /.

  dutch_national_flag_problem->sort_sequence( changing sequence_to_be_sorted = sequence ).

  write:|{ sequence }, is sorted? -> { dutch_national_flag_problem->is_sorted( sequence ) }|, /.
