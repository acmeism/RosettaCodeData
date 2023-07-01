PARAMETERS: p_limit TYPE i OBLIGATORY DEFAULT 100.

AT SELECTION-SCREEN ON p_limit.
  IF p_limit LE 1.
    MESSAGE 'Limit must be higher then 1.' TYPE 'E'.
  ENDIF.

START-OF-SELECTION.
  FIELD-SYMBOLS: <fs_prime> TYPE flag.
  DATA: gt_prime TYPE TABLE OF flag,
        gv_prime TYPE flag,
        gv_i     TYPE i,
        gv_j     TYPE i.

  DO p_limit TIMES.
    IF sy-index > 1.
      gv_prime = abap_true.
    ELSE.
      gv_prime = abap_false.
    ENDIF.

    APPEND gv_prime TO gt_prime.
  ENDDO.

  gv_i = 2.
  WHILE ( gv_i <= trunc( sqrt( p_limit ) ) ).
    IF ( gt_prime[ gv_i ] EQ abap_true ).
      gv_j =  gv_i ** 2.
      WHILE ( gv_j <= p_limit ).
        gt_prime[ gv_j ] = abap_false.
        gv_j = ( gv_i ** 2 ) + ( sy-index * gv_i ).
      ENDWHILE.
    ENDIF.
    gv_i = gv_i + 1.
  ENDWHILE.

  LOOP AT gt_prime INTO gv_prime.
    IF gv_prime = abap_true.
      WRITE: / sy-tabix.
    ENDIF.
  ENDLOOP.
