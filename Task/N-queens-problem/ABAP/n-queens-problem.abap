TYPES: BEGIN OF gty_matrix,
         1  TYPE c,
         2  TYPE c,
         3  TYPE c,
         4  TYPE c,
         5  TYPE c,
         6  TYPE c,
         7  TYPE c,
         8  TYPE c,
         9  TYPE c,
         10 TYPE c,
       END OF gty_matrix,
       gty_t_matrix TYPE STANDARD TABLE OF gty_matrix INITIAL SIZE 8.

DATA: gt_matrix TYPE gty_t_matrix,
      gs_matrix TYPE gty_matrix,
      gv_count  TYPE i VALUE 0,
      gv_solut  TYPE i VALUE 0.


SELECTION-SCREEN BEGIN OF BLOCK b01 WITH FRAME TITLE text-b01.
PARAMETERS: p_number TYPE i OBLIGATORY DEFAULT 8.
SELECTION-SCREEN END OF BLOCK b01.

" Filling empty table
START-OF-SELECTION.
  DO p_number TIMES.
    APPEND gs_matrix TO gt_matrix.
  ENDDO.

" Recursive Function
  PERFORM fill_matrix USING gv_count 1 1 CHANGING gt_matrix.
  BREAK-POINT.
*&---------------------------------------------------------------------*
*&      Form  FILL_MATRIX
*----------------------------------------------------------------------*
FORM fill_matrix  USING    p_count TYPE i
                           p_i     TYPE i
                           p_j     TYPE i
                  CHANGING p_matrix TYPE gty_t_matrix.

  DATA: lv_i      TYPE i,
        lv_j      TYPE i,
        lv_result TYPE c LENGTH 1,
        lt_matrix TYPE gty_t_matrix,
        lv_count  TYPE i,
        lv_value  TYPE c.

  lt_matrix[] = p_matrix[].
  lv_count = p_count.
  lv_i = p_i.
  lv_j = p_j.

  WHILE lv_i LE p_number.
    WHILE lv_j LE p_number.
      CLEAR lv_result.
      PERFORM check_position USING lv_i lv_j CHANGING lv_result lt_matrix.
      IF lv_result NE 'X'.
        MOVE 'X' TO lv_value.
        PERFORM get_position USING lv_i lv_j 'U' CHANGING lv_value lt_matrix.
        ADD 1 TO lv_count.
        IF lv_count EQ p_number.
          PERFORM show_matrix USING lt_matrix.
        ELSE.
          PERFORM fill_matrix USING lv_count lv_i lv_j CHANGING lt_matrix.
        ENDIF.
        lv_value = space.
        PERFORM get_position USING lv_i lv_j 'U' CHANGING lv_value lt_matrix.
        SUBTRACT 1 FROM lv_count.
      ENDIF.
      ADD 1 TO lv_j.
    ENDWHILE.
    ADD 1 TO lv_i.
    lv_j = 1.
  ENDWHILE.
ENDFORM.                    " FILL_MATRIX

*&---------------------------------------------------------------------*
*&      Form  CHECK_POSITION
*&---------------------------------------------------------------------*
FORM check_position  USING value(p_i)  TYPE i
                           value(p_j)  TYPE i
                     CHANGING p_result TYPE c
                              p_matrix TYPE gty_t_matrix.

  PERFORM get_position USING p_i p_j 'R' CHANGING p_result p_matrix.
  CHECK p_result NE 'X'.

  PERFORM check_horizontal USING p_i p_j CHANGING p_result p_matrix.
  CHECK p_result NE 'X'.

  PERFORM check_vertical USING p_i p_j CHANGING p_result p_matrix.
  CHECK p_result NE 'X'.

  PERFORM check_diagonals USING p_i p_j CHANGING p_result p_matrix.

ENDFORM.                    " CHECK_POSITION

*&---------------------------------------------------------------------*
*&      Form  GET_POSITION
*&---------------------------------------------------------------------*
FORM get_position  USING value(p_i)      TYPE i
                         value(p_j)      TYPE i
                         value(p_action) TYPE c
                      CHANGING p_result  TYPE c
                               p_matrix  TYPE gty_t_matrix.

  FIELD-SYMBOLS: <fs_lmatrix> TYPE gty_matrix,
                 <fs_lfield> TYPE any.

  READ TABLE p_matrix ASSIGNING <fs_lmatrix> INDEX p_i.
  ASSIGN COMPONENT p_j OF STRUCTURE <fs_lmatrix> TO <fs_lfield>.

  CASE p_action.
    WHEN 'U'.
      <fs_lfield> = p_result.
    WHEN 'R'.
      p_result = <fs_lfield>.
    WHEN OTHERS.
  ENDCASE.

ENDFORM.                    " GET_POSITION

*&---------------------------------------------------------------------*
*&      Form  CHECK_HORIZONTAL
*&---------------------------------------------------------------------*
FORM check_horizontal  USING value(p_i)      TYPE i
                             value(p_j)      TYPE i
                          CHANGING p_result  TYPE c
                                   p_matrix  TYPE gty_t_matrix.
  DATA: lv_j TYPE i,
        ls_matrix TYPE gty_matrix.

  FIELD-SYMBOLS <fs> TYPE c.

  lv_j = 1.
  READ TABLE p_matrix INTO ls_matrix INDEX p_i.
  WHILE lv_j LE p_number.
    ASSIGN COMPONENT lv_j OF STRUCTURE ls_matrix TO <fs>.
    IF <fs> EQ 'X'.
      p_result = 'X'.
      RETURN.
    ENDIF.
    ADD 1 TO lv_j.
  ENDWHILE.
ENDFORM.                    " CHECK_HORIZONTAL

*&---------------------------------------------------------------------*
*&      Form  CHECK_VERTICAL
*&---------------------------------------------------------------------*
FORM check_vertical  USING value(p_i)      TYPE i
                           value(p_j)      TYPE i
                        CHANGING p_result  TYPE c
                                 p_matrix  TYPE gty_t_matrix.
  DATA: lv_i TYPE i,
        ls_matrix TYPE gty_matrix.

  FIELD-SYMBOLS <fs> TYPE c.

  lv_i = 1.
  WHILE lv_i LE p_number.
    READ TABLE p_matrix INTO ls_matrix INDEX lv_i.
    ASSIGN COMPONENT p_j OF STRUCTURE ls_matrix TO <fs>.
    IF <fs> EQ 'X'.
      p_result = 'X'.
      RETURN.
    ENDIF.
    ADD 1 TO lv_i.
  ENDWHILE.
ENDFORM.                    " CHECK_VERTICAL

*&---------------------------------------------------------------------*
*&      Form  CHECK_DIAGONALS
*&---------------------------------------------------------------------*
FORM check_diagonals  USING value(p_i)      TYPE i
                            value(p_j)      TYPE i
                         CHANGING p_result  TYPE c
                                  p_matrix  TYPE gty_t_matrix.
  DATA: lv_dx TYPE i,
        lv_dy TYPE i.

* I++ J++ (Up Right)
  lv_dx = 1.
  lv_dy = 1.
  PERFORM check_diagonal USING p_i p_j lv_dx lv_dy CHANGING p_result p_matrix.
  CHECK p_result NE 'X'.

* I-- J-- (Left Down)
  lv_dx = -1.
  lv_dy = -1.
  PERFORM check_diagonal USING p_i p_j lv_dx lv_dy CHANGING p_result p_matrix.
  CHECK p_result NE 'X'.

* I++ J-- (Right Down)
  lv_dx = 1.
  lv_dy = -1.
  PERFORM check_diagonal USING p_i p_j lv_dx lv_dy CHANGING p_result p_matrix.
  CHECK p_result NE 'X'.

* I-- J++ (Left Up)
  lv_dx = -1.
  lv_dy = 1.
  PERFORM check_diagonal USING p_i p_j lv_dx lv_dy CHANGING p_result p_matrix.
  CHECK p_result NE 'X'.
ENDFORM.                    " CHECK_DIAGONALS

*&---------------------------------------------------------------------*
*&      Form  CHECK_DIAGONAL
*&---------------------------------------------------------------------*
FORM check_diagonal  USING value(p_i)      TYPE i
                            value(p_j)      TYPE i
                            value(p_dx)      TYPE i
                            value(p_dy)      TYPE i
                         CHANGING p_result  TYPE c
                                  p_matrix  TYPE gty_t_matrix.
  DATA: lv_i TYPE i,
        lv_j TYPE i,
        ls_matrix TYPE gty_matrix.

  FIELD-SYMBOLS <fs> TYPE c.

  lv_i = p_i.
  lv_j = p_j.
  WHILE 1 EQ 1.
    ADD: p_dx TO lv_i, p_dy TO lv_j.

    IF p_dx EQ 1.
      IF lv_i GT p_number. EXIT. ENDIF.
    ELSE.
      IF lv_i LT 1. EXIT. ENDIF.
    ENDIF.

    IF p_dy EQ 1.
      IF lv_j GT p_number. EXIT. ENDIF.
    ELSE.
      IF lv_j LT 1. EXIT. ENDIF.
    ENDIF.

    READ TABLE p_matrix INTO ls_matrix INDEX lv_i.
    ASSIGN COMPONENT lv_j OF STRUCTURE ls_matrix TO <fs>.
    IF <fs> EQ 'X'.
      p_result = 'X'.
      RETURN.
    ENDIF.
  ENDWHILE.
ENDFORM.                    " CHECK_DIAGONAL
*&---------------------------------------------------------------------*
*&      Form  SHOW_MATRIX
*----------------------------------------------------------------------*
FORM show_matrix USING p_matrix TYPE gty_t_matrix.
  DATA: lt_matrix TYPE gty_t_matrix,
        lv_j      TYPE i VALUE 1,
        lv_colum  TYPE string VALUE '-'.

  FIELD-SYMBOLS: <fs_matrix> TYPE gty_matrix,
                 <fs_field>  TYPE c.

  ADD 1 TO gv_solut.

  WRITE:/ 'Solution: ', gv_solut.

  DO p_number TIMES.
    CONCATENATE lv_colum '----' INTO lv_colum.
  ENDDO.

  LOOP AT p_matrix ASSIGNING <fs_matrix>.
    IF sy-tabix EQ 1.
      WRITE:/ lv_colum.
    ENDIF.
    WRITE:/ '|'.
    DO p_number TIMES.
      ASSIGN COMPONENT lv_j OF STRUCTURE <fs_matrix> TO <fs_field>.
      IF <fs_field> EQ space.
        WRITE: <fs_field> ,'|'.
      ELSE.
        WRITE: <fs_field> COLOR 2 HOTSPOT ON,'|'.
      ENDIF.
      ADD 1 TO lv_j.
    ENDDO.
    lv_j = 1.
    WRITE: / lv_colum.
  ENDLOOP.

  SKIP 1.
ENDFORM.                    " SHOW_MATRIX
