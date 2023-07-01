*&---------------------------------------------------------------------*
*& Report ZCONWAYS_GAME_OF_LIFE
*&---------------------------------------------------------------------*
*& by Marcelo Bovo
*&---------------------------------------------------------------------*
report zconways_game_of_life line-size 174 no standard page heading
                             line-count 40.

parameters: p_char type c default '#',
            p_pos  type string.

class lcl_game_of_life definition.

  public section.

    data: x_max      type i value 174,
          y_max      type i value 40,
          character  type c value abap_true,
          x          type i,
          y          type i,
          pos        type string,
          offlimits  type i value 9998,
          grid(9999) type c. " every X_MAX characters on grid equals one line on screen

    data: o_random_y type ref to cl_abap_random_int,
          o_random_x type ref to cl_abap_random_int.

    methods: constructor,
      play,
      initial_position,
      initial_grid,
      write,
      change_grid.

endclass.

class lcl_game_of_life implementation.
  method constructor.
    o_random_y = cl_abap_random_int=>create( seed = cl_abap_random=>create( conv i( sy-uzeit ) )->intinrange( low = 1 high = 999999 )
                                             min  = 1
                                             max = y_max ).

    o_random_x = cl_abap_random_int=>create( seed = cl_abap_random=>create( conv i( |{ sy-datum(4) }{ sy-uzeit }| ) )->intinrange( low = 1 high = 999999 )
                                             min  = 1
                                             max = x_max ).

  endmethod.

  method play.

    "fill initial data ramdonly if user hasnt typed any coordenates
    if pos is initial.
      initial_position( ).
    endif.

    initial_grid( ).

    write( ).

  endmethod.

  method initial_position.
    do cl_abap_random_int=>create( "seed = conv i( sy-uzeit )
                                   min  = 50
                                   max = 800 )->get_next( ) times.
      data(lv_index) = sy-index.

      x = o_random_x->get_next( ).
      y = o_random_y->get_next( ).

      p_pos = |{ p_pos }{ switch char1( lv_index when '1' then space else ';' ) }{ y },{ x }|.
    enddo.
  endmethod.

  method initial_grid.

    "Split coordenates
    split p_pos at ';' into table data(lt_pos_inicial) .

    "Sort By Line(Easy to read)
    sort lt_pos_inicial.

    loop at lt_pos_inicial assigning field-symbol(<pos_inicial>).

      split <pos_inicial> at ',' into data(y_char) data(x_char).

      x = x_char.
      y = y_char.

      "Ensure maximum coordenates are not surpassed
      x = cond #( when x <= x_max then x
                   else o_random_x->get_next( ) ).

      y = cond #( when y <= y_max then y
                   else o_random_y->get_next( ) ).

      "Write on string grid
      "Every x_max lines represent one line(Y) on the grid
      data(grid_xy) = ( x_max * y ) + x - x_max - 1.
      grid+grid_xy(1) = character.

    endloop.

  endmethod.

  method write.

    skip to line 1.

    "Write every line on screen
    do y_max times.
      data(lv_index) = sy-index - 1.

      "Write whole line(current line plus number of maximum X characters)
      data(grid_xy) = ( lv_index * x_max ).

      write / grid+grid_xy(x_max) no-gap.

      if grid+grid_xy(x_max) is initial.
        skip.
      endif.

    enddo.

    change_grid( ).

  endmethod.

  method change_grid.

    data(grid_aux) = grid.
    clear grid_aux.
    data(grid_size) = strlen( grid ).

    "Validate neighbours based on previous written grid
    "ABC
    "D.F
    "GHI
    do grid_size + x_max times.

      "Doens't write anything beyond borders
      check sy-index <= x_max * y_max.

      data(grid_xy) = sy-index - 1.

      data(neighbours) = 0.

      "Current Line neighbours
      data(d) = grid_xy - 1.
      data(f) = grid_xy + 1.

      "Line above neighbours
      data(b) = grid_xy - x_max.
      data(a) = b - 1.
      data(c) = b + 1.

      "Line Bellow neighbours
      data(h) = grid_xy + x_max.
      data(g) = h - 1.
      data(i) = h + 1.

      "Previous Neighbours
      neighbours += cond #( when a < 0 then 0 else cond #( when grid+a(1) is not initial then 1 else 0 )   ).
      neighbours += cond #( when b < 0 then 0 else cond #( when grid+b(1) is not initial then 1 else 0 )   ).
      neighbours += cond #( when c < 0 then 0 else cond #( when grid+c(1) is not initial then 1 else 0 )   ).
      neighbours += cond #( when d < 0 then 0 else cond #( when grid+d(1) is not initial then 1 else 0 )   ).

      "Next Neighbours
      neighbours += cond #( when f > grid_size then 0 else cond #( when grid+f(1) is not initial then 1 else 0 )   ).
      neighbours += cond #( when g > grid_size then 0 else cond #( when grid+g(1) is not initial then 1 else 0 )   ).
      neighbours += cond #( when h > grid_size then 0 else cond #( when grid+h(1) is not initial then 1 else 0 )   ).
      neighbours += cond #( when i > grid_size then 0 else cond #( when grid+i(1) is not initial then 1 else 0 )   ).

      grid_aux+grid_xy(1) = cond #( when  neighbours = 3 or (  neighbours = 2  and grid+grid_xy(1) = character )
                                     then character
                                    else space ).

    enddo.

    grid = grid_aux.

  endmethod.
endclass.

start-of-selection.

  set pf-status 'STANDARD_FULLSCREEN'. "Use &REFRESH button with F8 Shortcut to go to next generation

  data(lo_prog) = new lcl_game_of_life( ).
  lo_prog->character = p_char.
  lo_prog->pos = p_pos.
  lo_prog->play( ).

at user-command.

  case sy-ucomm.
    when 'REFR' or '&REFRESH'.
      sy-lsind = 1. "Prevents LIST_TOO_MANY_LEVELS DUMP
      lo_prog->write( ).
    when others.
      leave list-processing.
  endcase.
