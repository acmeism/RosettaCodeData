*&---------------------------------------------------------------------*
*& Report  ZEXEC_SYS_CMD
*&
*&---------------------------------------------------------------------*
*&
*&
*&---------------------------------------------------------------------*

REPORT  zexec_sys_cmd.

DATA: lv_opsys      TYPE          syst-opsys,
      lt_sxpgcotabe TYPE TABLE OF sxpgcotabe,
      ls_sxpgcotabe LIKE LINE OF  lt_sxpgcotabe,
      ls_sxpgcolist TYPE          sxpgcolist,
      lv_name       TYPE          sxpgcotabe-name,
      lv_opcommand  TYPE          sxpgcotabe-opcommand,
      lv_index      TYPE          c,
      lt_btcxpm     TYPE TABLE OF btcxpm,
      ls_btcxpm     LIKE LINE OF  lt_btcxpm
      .

* Initialize
lv_opsys = sy-opsys.
CLEAR lt_sxpgcotabe[].

IF lv_opsys EQ 'Windows NT'.
  lv_opcommand = 'dir'.
ELSE.
  lv_opcommand = 'ls'.
ENDIF.

* Check commands
SELECT * FROM sxpgcotabe INTO TABLE lt_sxpgcotabe
  WHERE opsystem  EQ lv_opsys
    AND opcommand EQ lv_opcommand.

IF lt_sxpgcotabe IS INITIAL.
  CLEAR ls_sxpgcolist.
  CLEAR lv_name.
  WHILE lv_name IS INITIAL.
* Don't mess with other users' commands
    lv_index = sy-index.
    CONCATENATE 'ZLS' lv_index INTO lv_name.
    SELECT * FROM sxpgcostab INTO ls_sxpgcotabe
      WHERE name EQ lv_name.
    ENDSELECT.
    IF sy-subrc = 0.
      CLEAR lv_name.
    ENDIF.
  ENDWHILE.
  ls_sxpgcolist-name      = lv_name.
  ls_sxpgcolist-opsystem  = lv_opsys.
  ls_sxpgcolist-opcommand = lv_opcommand.
* Create own ls command when nothing is declared
  CALL FUNCTION 'SXPG_COMMAND_INSERT'
    EXPORTING
      command                = ls_sxpgcolist
      public                 = 'X'
    EXCEPTIONS
      command_already_exists = 1
      no_permission          = 2
      parameters_wrong       = 3
      foreign_lock           = 4
      system_failure         = 5
      OTHERS                 = 6.
  IF sy-subrc <> 0.
* Implement suitable error handling here
  ELSE.
* Hooray it worked! Let's try to call it
    CALL FUNCTION 'SXPG_COMMAND_EXECUTE_LONG'
      EXPORTING
        commandname                   = lv_name
      TABLES
        exec_protocol                 = lt_btcxpm
      EXCEPTIONS
        no_permission                 = 1
        command_not_found             = 2
        parameters_too_long           = 3
        security_risk                 = 4
        wrong_check_call_interface    = 5
        program_start_error           = 6
        program_termination_error     = 7
        x_error                       = 8
        parameter_expected            = 9
        too_many_parameters           = 10
        illegal_command               = 11
        wrong_asynchronous_parameters = 12
        cant_enq_tbtco_entry          = 13
        jobcount_generation_error     = 14
        OTHERS                        = 15.
    IF sy-subrc <> 0.
* Implement suitable error handling here
      WRITE: 'Cant execute ls - '.
      CASE sy-subrc.
        WHEN 1.
          WRITE: / ' no permission!'.
        WHEN 2.
          WRITE: / ' command could not be created!'.
        WHEN 3.
          WRITE: / ' parameter list too long!'.
        WHEN 4.
          WRITE: / ' security risk!'.
        WHEN 5.
          WRITE: / ' wrong call of SXPG_COMMAND_EXECUTE_LONG!'.
        WHEN 6.
          WRITE: / ' command cant be started!'.
        WHEN 7.
          WRITE: / ' program terminated!'.
        WHEN 8.
          WRITE: / ' x_error!'.
        WHEN 9.
          WRITE: / ' parameter missing!'.
        WHEN 10.
          WRITE: / ' too many parameters!'.
        WHEN 11.
          WRITE: / ' illegal command!'.
        WHEN 12.
          WRITE: / ' wrong asynchronous parameters!'.
        WHEN 13.
          WRITE: / ' cant enqueue job!'.
        WHEN 14.
          WRITE: / ' cant create job!'.
        WHEN 15.
          WRITE: / ' unknown error!'.
        WHEN OTHERS.
          WRITE: / ' unknown error!'.
      ENDCASE.
    ELSE.
      LOOP AT lt_btcxpm INTO ls_btcxpm.
        WRITE: / ls_btcxpm.
      ENDLOOP.
    ENDIF.
  ENDIF.
ENDIF.
