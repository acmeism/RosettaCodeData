/* ------------------------------------------------------------------------------------------------------

                                               Copyright (c) 2004 - Gal Zsolt (CalmoSoft)

   ------------------------------------------------------------------------------------------------------ */

implement playDialog
    open core, vpiDomains, vpiOldDomains, resourceIdentifiers

    facts
        thisWin : vpiDomains::windowHandle := erroneous.

    clauses
        show(Parent):-
            _ = vpi::winCreateDynDialog(Parent, controlList, eventHandler, gui_api::lNull).

/* ------------------------------------------------------------------------------------------------------ */

    predicates
        eventHandler : vpiDomains::ehandler.
    clauses
        eventHandler(Win, Event) = Result :-
            Result = generatedEventHandler(Win, Event).

/* ------------------------------------------------------------------------------------------------------ */


    predicates
        onDestroy : vpiOldDomains::destroyHandler.
    clauses
        onDestroy() = vpiOldDomains::defaultHandling() :-
            thisWin := erroneous.

/* ------------------------------------------------------------------------------------------------------ */

    predicates
        onControlCancel : vpiOldDomains::controlHandler.
    clauses
        onControlCancel(_Ctrl, _CtrlType, _CtrlWin, _CtrlInfo) = vpiOldDomains::handled(gui_api::rNull) :-
            file::save("game.dba",gameDB),
            retractall(table(_,_)),
            retractall(gameplay(_,_)),
            retractall(empty_cell(_)),
            retractall(cell(_,_)),
            retractall(cellnr(_,_)),
            retractall(good(_,_,_)),
            vpi::winDestroy(thisWin).

/* ------------------------------------------------------------------------------------------------------ */

 predicates
        onUpdate : vpiOldDomains::updateHandler.
    clauses
        onUpdate(Rectangle) = vpiOldDomains::defaultHandling():-
            vpi::winClear( thisWin,Rectangle,0x808040),
            !.

/* ------------------------------------------------------------------------------------------------------ */

    class facts - gameDB
        table:(integer,string).
        gameplay:(integer,integer).
        empty_cell:(integer).

    class facts
        cell:(integer,vpiDomains::windowHandle).
        cellnr:(integer,integer).

/* ------------------------------------------------------------------------------------------------------ */

    class facts
        step_nr:integer:=0.

    predicates
        onCreate : vpiOldDomains::createHandler.
    clauses
        onCreate(_CreationData) = vpiOldDomains::defaultHandling():-
            retractall(table(_,_)),
            retractall(gameplay(_,_)),
            retractall(empty_cell(_)),
            retractall(cell(_,_)),
            retractall(cellnr(_,_)),
            retractall(good(_,_,_)),

            scrollbars_init(),
            cellhandle_init(),
            empty:=16,
            good_cell(0),
            table_save(),
            step_nr:=0,
            fail.
        onCreate(_CreationData) = vpiOldDomains::defaultHandling().

/* ------------------------------------------------------------------------------------------------------ */

    facts
        vsbarr : vpiDomains::windowHandle := erroneous.
        vsbarl : vpiDomains::windowHandle := erroneous.
        hsbart : vpiDomains::windowHandle := erroneous.
        hsbarb : vpiDomains::windowHandle := erroneous.

    predicates
        scrollbars_init:().
    clauses
        scrollbars_init():-
            vsbarr := vpi::winGetCtlHandle(thisWin,idc_sbvr),
            vsbarl := vpi::winGetCtlHandle(thisWin,idc_sbvl),
            hsbart := vpi::winGetCtlHandle(thisWin,idc_sbht),
            hsbarb := vpi::winGetCtlHandle(thisWin,idc_sbhb),


            vpi::winSetScrollRange(vsbarr,sb_Ctl,1,4),
            vpi::winSetScrollProportion(vsbarr,sb_Ctl,1),
            vpi::winSetScrollPos(vsbarr,sb_Ctl,4),

            vpi::winSetScrollRange(vsbarl,sb_Ctl,1,4),
            vpi::winSetScrollProportion(vsbarl,sb_Ctl,1),
            vpi::winSetScrollPos(vsbarl,sb_Ctl,4),

            vpi::winSetScrollRange(hsbart,sb_Ctl,1,4),
            vpi::winSetScrollProportion(hsbart,sb_Ctl,1),
            vpi::winSetScrollPos(hsbart,sb_Ctl,4),

            vpi::winSetScrollRange(hsbarb,sb_Ctl,1,4),
            vpi::winSetScrollProportion(hsbarb,sb_Ctl,1),
            vpi::winSetScrollPos(hsbarb,sb_Ctl,4).

/* ------------------------------------------------------------------------------------------------------ */

    class facts
        cell1 : vpiDomains::windowHandle := erroneous.
        cell2 : vpiDomains::windowHandle := erroneous.
        cell3 : vpiDomains::windowHandle := erroneous.
        cell4 : vpiDomains::windowHandle := erroneous.
        cell5 : vpiDomains::windowHandle := erroneous.
        cell6 : vpiDomains::windowHandle := erroneous.
        cell7 : vpiDomains::windowHandle := erroneous.
        cell8 : vpiDomains::windowHandle := erroneous.
        cell9 : vpiDomains::windowHandle := erroneous.
        cell10 : vpiDomains::windowHandle := erroneous.
        cell11 : vpiDomains::windowHandle := erroneous.
        cell12 : vpiDomains::windowHandle := erroneous.
        cell13 : vpiDomains::windowHandle := erroneous.
        cell14 : vpiDomains::windowHandle := erroneous.
        cell15 : vpiDomains::windowHandle := erroneous.
        cell16 : vpiDomains::windowHandle := erroneous.

    predicates
        cell_handle:().
    clauses
        cell_handle():-
            cell1:=vpi::winGetCtlHandle(thisWin,idc_cell1),
            cell2:=vpi::winGetCtlHandle(thisWin,idc_cell2),
            cell3:=vpi::winGetCtlHandle(thisWin,idc_cell3),
            cell4:=vpi::winGetCtlHandle(thisWin,idc_cell4),
            cell5:=vpi::winGetCtlHandle(thisWin,idc_cell5),
            cell6:=vpi::winGetCtlHandle(thisWin,idc_cell6),
            cell7:=vpi::winGetCtlHandle(thisWin,idc_cell7),
            cell8:=vpi::winGetCtlHandle(thisWin,idc_cell8),
            cell9:=vpi::winGetCtlHandle(thisWin,idc_cell9),
            cell10:=vpi::winGetCtlHandle(thisWin,idc_cell10),
            cell11:=vpi::winGetCtlHandle(thisWin,idc_cell11),
            cell12:=vpi::winGetCtlHandle(thisWin,idc_cell12),
            cell13:=vpi::winGetCtlHandle(thisWin,idc_cell13),
            cell14:=vpi::winGetCtlHandle(thisWin,idc_cell14),
            cell15:=vpi::winGetCtlHandle(thisWin,idc_cell15),
            cell16:=vpi::winGetCtlHandle(thisWin,idc_cell16).

/* ------------------------------------------------------------------------------------------------------ */

    predicates
        cellhandle_init:().
    clauses
        cellhandle_init():-
            retractall(cell(_,_)),
            cell_handle(),

            assert(cell(1,cell1)),
            assert(cell(2,cell2)),
            assert(cell(3,cell3)),
            assert(cell(4,cell4)),
            assert(cell(5,cell5)),
            assert(cell(6,cell6)),
            assert(cell(7,cell7)),
            assert(cell(8,cell8)),
            assert(cell(9,cell9)),
            assert(cell(10,cell10)),
            assert(cell(11,cell11)),
            assert(cell(12,cell12)),
            assert(cell(13,cell13)),
            assert(cell(14,cell14)),
            assert(cell(15,cell15)),
            assert(cell(16,cell16)).

/* ------------------------------------------------------------------------------------------------------ */

    class facts
        good_nr:integer:=0.
        good:(integer,integer,integer) nondeterm.
        empty:integer:=16.

    predicates
        good_cell:(integer) multi.
    clauses
        good_cell(16):-!.
        good_cell(Number):-
            NumberNew = Number+1,
            good_nr:=0,
            good_above(NumberNew),                    % movable cells above empty cell
            good_before(NumberNew),                    % movable cells before empty cell
            good_after(NumberNew),                       % movable cells after empty cell
            good_under(NumberNew),                      % movable cells under empty cell
            assert(cellnr(NumberNew,good_nr)),       % number of movable cells around the empty cell
            good_cell(NumberNew).

/* ------------------------------------------------------------------------------------------------------ */

    predicates
        good_above:(integer).
    clauses
        good_above(Number):-
            Number > 4,                                             % movable cells above empty cell
            good_nr:= good_nr+1,
            assert(good(Number,good_nr,Number-4)),
            fail.
        good_above(_).

/* ------------------------------------------------------------------------------------------------------ */

    predicates
        good_before:(integer).
    clauses
        good_before(Number):-
            (Number mod 4) <> 1,                               % movable cells before empty cell
            good_nr:= good_nr+1,
            assert(good(Number,good_nr,Number-1)),
            fail.
        good_before(_).

/* ------------------------------------------------------------------------------------------------------ */

    predicates
        good_after:(integer).
    clauses
        good_after(Number):-
            (Number mod 4) > 0,                                   % movable cells after empty cell
            good_nr:= good_nr+1,
            assert(good(Number,good_nr,Number+1)),
            fail.
        good_after(_).

/* ------------------------------------------------------------------------------------------------------ */

    predicates
        good_under:(integer).
    clauses
        good_under(Number):-
            Number < 13,                                               % movable cells under empty cell
            good_nr:= good_nr+1,
            assert(good(Number,good_nr,Number+4)),
            fail.
        good_under(_).

/* ------------------------------------------------------------------------------------------------------ */

    predicates
        cell_click:(integer).

    clauses
        cell_click(NrCell):-
            good(empty,_,NrCell),
            cell(empty,EmptyHandle),
            cell(NrCell,NrCellHandle),
            EmptyNr = vpi::winGetText(NrCellHandle),
            vpi::winSetText(EmptyHandle,EmptyNr),
            vpi::winSetText(NrCellHandle,""),
            empty:=NrCell,
            step_nr := step_nr + 1,
            Bingo = vpi::winGetCtlHandle(thisWin,idc_bingo),
            vpi::winSetText(  Bingo, ""),
            vpi::winSetState(Bingo,[wsf_Invisible]),
            bingo(),

            % VerVal = uncheckedConvert(integer, math::floor((empty-1)/4)+1),
            % HorVal = uncheckedConvert(integer, math::floor((empty-1) mod 4)+1),

            VerVal = math::floor((empty-1)/4)+1,
            HorVal = math::floor((empty-1) mod 4)+1,

            vpi::winSetScrollPos(vsbarr,sb_Ctl,VerVal),
            vpi::winSetScrollPos(vsbarl,sb_Ctl,VerVal),
            vpi::winSetScrollPos(hsbart,sb_Ctl,HorVal),
            vpi::winSetScrollPos(hsbarb,sb_Ctl,HorVal),

            Step = vpi::winGetCtlHandle(thisWin,idc_step),
            vpi::winSetText(Step,toString(step_nr)),

            assert(gameplay(step_nr,NrCell)),

            fail.
        cell_click(_).

/* ------------------------------------------------------------------------------------------------------ */

    predicates
        cell_click_play:(integer).

    clauses
        cell_click_play(NrCell):-
            good(empty,_,NrCell),
            cell(empty,EmptyHandle),
            cell(NrCell,NrCellHandle),
            EmptyNr = vpi::winGetText(NrCellHandle),
            vpi::winSetText(EmptyHandle,EmptyNr),
            vpi::winSetText(NrCellHandle,""),
            empty:=NrCell,
            Bingo = vpi::winGetCtlHandle(thisWin,idc_bingo),
            vpi::winSetText(Bingo, ""),
            vpi::winSetState(Bingo,[wsf_Invisible]),
            bingo(),

            % VerVal = uncheckedConvert(integer,math::floor((empty-1)/4)+1),
            % HorVal = uncheckedConvert(integer,math::floor((empty-1) mod 4)+1),

            VerVal = math::floor((empty-1)/4)+1,
            HorVal = math::floor((empty-1) mod 4)+1,

            vpi::winSetScrollPos(vsbarr,sb_Ctl,VerVal),
            vpi::winSetScrollPos(vsbarl,sb_Ctl,VerVal),
            vpi::winSetScrollPos(hsbart,sb_Ctl,HorVal),
            vpi::winSetScrollPos(hsbarb,sb_Ctl,HorVal),

            programControl::sleep(1000),

            fail.
        cell_click_play(_).

/* ------------------------------------------------------------------------------------------------------ */

    predicates
        onControlmix : vpiOldDomains::controlHandler.
    clauses
        onControlmix(_CtrlID, _CtrlType, _CtrlWin, _CtrlInfo) = vpiOldDomains::handled(gui_api::rNull):-
            step_nr:=0,
            cell_reset(),
            mix_cells(0),
            Play = vpi::winGetCtlHandle(thisWin,idc_play),
            vpi::winSetState(Play,[wsf_Disabled]),
            Bingo = vpi::winGetCtlHandle(thisWin,idc_bingo),
            vpi::winSetText(Bingo, ""),
            vpi::winSetState(Bingo,[wsf_Invisible]),
            step_nr:=0,
            Step = vpi::winGetCtlHandle(thisWin,idc_step),
            vpi::winSetText(Step,toString(step_nr)),
            table_save(),
            retractall(gameplay(_,_)),
            fail.

        onControlmix(_CtrlID, _CtrlType, _CtrlWin, _CtrlInfo) = vpiOldDomains::handled(gui_api::rNull).

/* ------------------------------------------------------------------------------------------------------ */

    class facts
        rand_nr:integer:=0.
        mix_nr:integer:=300.

    predicates
        mix_cells:(integer) multi.

    clauses
        mix_cells(mix_nr):-!.
        mix_cells(Number):-
            NumberNew = Number+1,
            cellnr(empty,CellNr),
            RandomNr = (math::random(1315) mod CellNr) + 1,
            rand_nr := RandomNr,
            good(empty,rand_nr, I),
            cell_click(I),
            mix_cells(NumberNew).
        mix_cells(_).

/* ------------------------------------------------------------------------------------------------------ */

    predicates
        table_save:().
    clauses
        table_save():-
            retractall(table(_,_)),
            retractall(empty_cell(_)),
            assert(empty_cell(empty)),

            assert(table(1,vpi::winGetText(cell1))),
            assert(table(2,vpi::winGetText(cell2))),
            assert(table(3,vpi::winGetText(cell3))),
            assert(table(4,vpi::winGetText(cell4))),
            assert(table(5,vpi::winGetText(cell5))),
            assert(table(6,vpi::winGetText(cell6))),
            assert(table(7,vpi::winGetText(cell7))),
            assert(table(8,vpi::winGetText(cell8))),
            assert(table(9,vpi::winGetText(cell9))),
            assert(table(10,vpi::winGetText(cell10))),
            assert(table(11,vpi::winGetText(cell11))),
            assert(table(12,vpi::winGetText(cell12))),
            assert(table(13,vpi::winGetText(cell13))),
            assert(table(14,vpi::winGetText(cell14))),
            assert(table(15,vpi::winGetText(cell15))),
            assert(table(16,vpi::winGetText(cell16))).

/* ------------------------------------------------------------------------------------------------------ */

    predicates
        onControlreset : vpiOldDomains::controlHandler.
    clauses
        onControlreset(_CtrlID, _CtrlType, _CtrlWin, _CtrlInfo) = vpiOldDomains::handled(gui_api::rNull):-
                              cell_reset().

/* ------------------------------------------------------------------------------------------------------ */
    predicates
        cell_reset:().
    clauses
        cell_reset():-
            vpi::winSetText(cell1,"1"),
            vpi::winSetText(cell2,"2"),
            vpi::winSetText(cell3,"3"),
            vpi::winSetText(cell4,"4"),
            vpi::winSetText(cell5,"5"),
            vpi::winSetText(cell6,"6"),
            vpi::winSetText(cell7,"7"),
            vpi::winSetText(cell8,"8"),
            vpi::winSetText(cell9,"9"),
            vpi::winSetText(cell10,"10"),
            vpi::winSetText(cell11,"11"),
            vpi::winSetText(cell12,"12"),
            vpi::winSetText(cell13,"13"),
            vpi::winSetText(cell14,"14"),
            vpi::winSetText(cell15,"15"),
            vpi::winSetText(cell16,""),

            vpi::winSetScrollPos(vsbarr,sb_Ctl,4),
            vpi::winSetScrollPos(vsbarl,sb_Ctl,4),
            vpi::winSetScrollPos(hsbart,sb_Ctl,4),
            vpi::winSetScrollPos(hsbarb,sb_Ctl,4),

            empty:=16,
            step_nr:=0,
            Step = vpi::winGetCtlHandle(thisWin,idc_step),
            vpi::winSetText(Step,toString(step_nr)),
            Bingo = vpi::winGetCtlHandle(thisWin,idc_bingo),
            vpi::winSetText(Bingo, ""),
            vpi::winSetState(Bingo,[wsf_Invisible]),
            Play = vpi::winGetCtlHandle(thisWin,idc_play),
            vpi::winSetState(Play,[wsf_Disabled]),
            retractall(gameplay(_,_)),
            table_save().

/* ------------------------------------------------------------------------------------------------------ */

    predicates
        bingo:().

    clauses
        bingo():-
            toString(1) = vpi::winGetText(cell1),
            toString(2) = vpi::winGetText(cell2),
            toString(3) = vpi::winGetText(cell3),
            toString(4) = vpi::winGetText(cell4),
            toString(5) = vpi::winGetText(cell5),
            toString(6) = vpi::winGetText(cell6),
            toString(7) = vpi::winGetText(cell7),
            toString(8) = vpi::winGetText(cell8),
            toString(9) = vpi::winGetText(cell9),
            toString(10) = vpi::winGetText(cell10),
            toString(11) = vpi::winGetText(cell11),
            toString(12) = vpi::winGetText(cell12),
            toString(13) = vpi::winGetText(cell13),
            toString(14) = vpi::winGetText(cell14),
            toString(15) = vpi::winGetText(cell15),
            "" = vpi::winGetText(cell16),

            Bingo = vpi::winGetCtlHandle(thisWin,idc_bingo),
            vpi::winSetState(Bingo,[wsf_Visible]),
            vpi::winSetText(Bingo, "BINGO !"),

            Step = vpi::winGetCtlHandle(thisWin,idc_step),
            vpi::winSetText(Step,toString(step_nr)),

            fail.
 bingo().

/* ------------------------------------------------------------------------------------------------------ */

    facts
        fileName:string:="".

    predicates
        onControlsave : vpiOldDomains::controlHandler.
    clauses
        onControlsave(_CtrlID, _CtrlType, _CtrlWin, _CtrlInfo) = vpiOldDomains::handled(gui_api::rNull):-
            try
            	FileName = vpiCommonDialogs::getFileName(fileName, ["All files", "*.game"], "Save game as", [dlgfn_Save], "", _)
            catch _ do
            	fail
            end try,
            !,
            file::save(FileName,gameDB).

        onControlsave(_CtrlID, _CtrlType, _CtrlWin, _CtrlInfo)= vpiOldDomains::handled(gui_api::rNull).

/* ------------------------------------------------------------------------------------------------------ */

    predicates
        onControlopen : vpiOldDomains::controlHandler.
    clauses
        onControlopen(_CtrlID, _CtrlType, _CtrlWin, _CtrlInfo) = vpiOldDomains::handled(gui_api::rNull):-
            try
            	FileName = vpiCommonDialogs::getFileName("game_", ["All files", "*.game"], "Open game file", [], "", _)
            catch _ do
            	fail
            end try,
            !,
            retractall(table(_,_)),
            retractall(gameplay(_,_)),
            retractall(empty_cell(_)),
            file::consult(FileName,gameDB),
            play_display(),
            Play = vpi::winGetCtlHandle(thisWin,idc_play),
            vpi::winSetState(Play,[wsf_Enabled]),
            Bingo = vpi::winGetCtlHandle(thisWin,idc_bingo),
            vpi::winSetState(Bingo,[wsf_Invisible]),
            vpi::winSetText(Bingo, ""),
            step_nr:=0,
            Step = vpi::winGetCtlHandle(thisWin,idc_step),
            vpi::winSetText(Step,toString(step_nr)).

        onControlopen(_CtrlID, _CtrlType, _CtrlWin, _CtrlInfo) = vpiOldDomains::handled(gui_api::rNull).

/* ------------------------------------------------------------------------------------------------------ */

    predicates
        play_display:().
    clauses
        play_display():-

            table(1,Cell1),
            table(2,Cell2),
            table(3,Cell3),
            table(4,Cell4),
            table(5,Cell5),
            table(6,Cell6),
            table(7,Cell7),
            table(8,Cell8),
            table(9,Cell9),
            table(10,Cell10),
            table(11,Cell11),
            table(12,Cell12),
            table(13,Cell13),
            table(14,Cell14),
            table(15,Cell15),
            table(16,Cell16),

            vpi::winSetText(cell1,Cell1),
            vpi::winSetText(cell2,Cell2),
            vpi::winSetText(cell3,Cell3),
            vpi::winSetText(cell4,Cell4),
            vpi::winSetText(cell5,Cell5),
            vpi::winSetText(cell6,Cell6),
            vpi::winSetText(cell7,Cell7),
            vpi::winSetText(cell8,Cell8),
            vpi::winSetText(cell9,Cell9),
            vpi::winSetText(cell10,Cell10),
            vpi::winSetText(cell11,Cell11),
            vpi::winSetText(cell12,Cell12),
            vpi::winSetText(cell13,Cell13),
            vpi::winSetText(cell14,Cell14),
            vpi::winSetText(cell15,Cell15),
            vpi::winSetText(cell16,Cell16),

            empty_cell(Empty_Cell),
            empty:=Empty_Cell,

            fail.
        play_display().

/* ------------------------------------------------------------------------------------------------------ */

    predicates
        onControlplay : vpiOldDomains::controlHandler.
    clauses

        onControlplay(_CtrlID, _CtrlType, _CtrlWin, _CtrlInfo) = vpiOldDomains::handled(gui_api::rNull):-
            Play = vpi::winGetCtlHandle(thisWin,idc_play),
            vpi::winSetState(Play,[wsf_Disabled]),
            gameplay(Nr,Nr_cell),
            cell_click_play(Nr_cell),
            Step = vpi::winGetCtlHandle(thisWin,idc_step),
            vpi::winSetText(Step,toString(Nr)),
            fail.

        onControlplay(_CtrlID, _CtrlType, _CtrlWin, _CtrlInfo) = vpiOldDomains::handled(gui_api::rNull).

/* ------------------------------------------------------------------------------------------------------ */

    predicates
        onControlsbvr : vpiOldDomains::controlHandler.               % Sets the right vertical scrollbar
    clauses
        onControlsbvr(_CtrlID, _CtrlType, _CtrlWin,scroll(sc_LineDown,_)) = vpiOldDomains::handled(gui_api::rNull):-
            Sbarvalr = vpi::winGetScrollPos(vsbarr,sb_Ctl)+1,
            Sbarvalr < 5,
            cell_click(empty+4),
            vpi::winSetScrollPos(vsbarr,sb_Ctl, Sbarvalr),
            vpi::winSetScrollPos(vsbarl,sb_Ctl, Sbarvalr),
            fail.

        onControlsbvr(_CtrlID, _CtrlType, _CtrlWin,scroll(sc_LineUp,_)) = vpiOldDomains::handled(gui_api::rNull):-
            Sbarvalr = vpi::winGetScrollPos(vsbarr,sb_Ctl)-1,
            Sbarvalr > 0,
            cell_click(empty-4),
            vpi::winSetScrollPos(vsbarr,sb_Ctl, Sbarvalr),
            vpi::winSetScrollPos(vsbarl,sb_Ctl, Sbarvalr),
            fail.

        onControlsbvr(_CtrlID, _CtrlType, _CtrlWin, _CtrlInfo) = vpiOldDomains::handled(gui_api::rNull).


/* ------------------------------------------------------------------------------------------------------ */

    predicates
        onControlsbvl : vpiOldDomains::controlHandler.                  % Sets the left vertical scrollbar
    clauses
        onControlsbvl(_CtrlID, _CtrlType, _CtrlWin,scroll(sc_LineDown,_)) = vpiOldDomains::handled(gui_api::rNull):-
            Sbarvall = vpi::winGetScrollPos(vsbarl,sb_Ctl)+1,
            Sbarvall < 5,
            cell_click(empty+4),
            vpi::winSetScrollPos(vsbarl,sb_Ctl, Sbarvall),
            vpi::winSetScrollPos(vsbarr,sb_Ctl, Sbarvall),
            fail.

        onControlsbvl(_CtrlID, _CtrlType, _CtrlWin,scroll(sc_LineUp,_)) = vpiOldDomains::handled(gui_api::rNull):-
            Sbarvall = vpi::winGetScrollPos(vsbarl,sb_Ctl)-1,
            Sbarvall > 0,
            cell_click(empty-4),
            vpi::winSetScrollPos(vsbarl,sb_Ctl, Sbarvall),
            vpi::winSetScrollPos(vsbarr,sb_Ctl, Sbarvall),
            fail.

        onControlsbvl(_CtrlID, _CtrlType, _CtrlWin, _CtrlInfo) = vpiOldDomains::handled(gui_api::rNull).

/* ------------------------------------------------------------------------------------------------------ */

    predicates
        onControlsbht : vpiOldDomains::controlHandler.             % Sets the top horizontal scrollbar
    clauses
        onControlsbht(_CtrlID, _CtrlType, _CtrlWin,scroll(sc_LineDown,_)) = vpiOldDomains::handled(gui_api::rNull):-
            Sbarvalt = vpi::winGetScrollPos(hsbart,sb_Ctl)+1,
            Sbarvalt < 5,
            cell_click(empty+1),
            vpi::winSetScrollPos(hsbart,sb_Ctl, Sbarvalt),
            vpi::winSetScrollPos(hsbarb,sb_Ctl, Sbarvalt),
            fail.

        onControlsbht(_CtrlID, _CtrlType, _CtrlWin,scroll(sc_LineUp,_)) = vpiOldDomains::handled(gui_api::rNull):-
            Sbarvalt = vpi::winGetScrollPos(hsbart,sb_Ctl)-1,
            Sbarvalt > 0,
            cell_click(empty-1),
            vpi::winSetScrollPos(hsbart,sb_Ctl, Sbarvalt),
            vpi::winSetScrollPos(hsbarb,sb_Ctl, Sbarvalt),
            fail.

        onControlsbht(_CtrlID, _CtrlType, _CtrlWin, _CtrlInfo) = vpiOldDomains::handled(gui_api::rNull).

/* ------------------------------------------------------------------------------------------------------ */

    predicates
        onControlsbhb : vpiOldDomains::controlHandler.       % Sets the bottom horizontal scrollbar
    clauses
        onControlsbhb(_CtrlID, _CtrlType, _CtrlWin,scroll(sc_LineDown,_)) = vpiOldDomains::handled(gui_api::rNull):-
            Sbarvalb = vpi::winGetScrollPos(hsbarb,sb_Ctl)+1,
            Sbarvalb < 5,
            cell_click(empty+1),
            vpi::winSetScrollPos(hsbarb,sb_Ctl, Sbarvalb),
            vpi::winSetScrollPos(hsbart,sb_Ctl, Sbarvalb),
            fail.

        onControlsbhb(_CtrlID, _CtrlType, _CtrlWin,scroll(sc_LineUp,_)) = vpiOldDomains::handled(gui_api::rNull):-
            Sbarvalb = vpi::winGetScrollPos(hsbarb,sb_Ctl)-1,
            Sbarvalb > 0,
            cell_click(empty-1),
            vpi::winSetScrollPos(hsbarb,sb_Ctl, Sbarvalb),
            vpi::winSetScrollPos(hsbart,sb_Ctl, Sbarvalb),
            fail.

        onControlsbhb(_CtrlID, _CtrlType, _CtrlWin, _CtrlInfo) = vpiOldDomains::handled(gui_api::rNull).

/* ------------------------------------------------------------------------------------------------------ */

    predicates
        onControlcell1 : vpiOldDomains::controlHandler.
    clauses
        onControlcell1(_CtrlID, _CtrlType, _CtrlWin, _CtrlInfo) = vpiOldDomains::handled(gui_api::rNull):-
            cell_click(1).

/* ------------------------------------------------------------------------------------------------------ */


    predicates
        onControlcell2 : vpiOldDomains::controlHandler.
    clauses
        onControlcell2(_CtrlID, _CtrlType, _CtrlWin, _CtrlInfo) = vpiOldDomains::handled(gui_api::rNull):-
            cell_click(2).

/* ------------------------------------------------------------------------------------------------------ */

    predicates
        onControlcell3 : vpiOldDomains::controlHandler.
    clauses
        onControlcell3(_CtrlID, _CtrlType, _CtrlWin, _CtrlInfo) = vpiOldDomains::handled(gui_api::rNull):-
            cell_click(3).

/* ------------------------------------------------------------------------------------------------------ */

    predicates
        onControlcell4 : vpiOldDomains::controlHandler.
    clauses
        onControlcell4(_CtrlID, _CtrlType, _CtrlWin, _CtrlInfo) = vpiOldDomains::handled(gui_api::rNull):-
            cell_click(4).

/* ------------------------------------------------------------------------------------------------------ */

    predicates
        onControlcell5 : vpiOldDomains::controlHandler.
    clauses
        onControlcell5(_CtrlID, _CtrlType, _CtrlWin, _CtrlInfo) = vpiOldDomains::handled(gui_api::rNull):-
            cell_click(5).

/* ------------------------------------------------------------------------------------------------------ */

    predicates
        onControlcell6 : vpiOldDomains::controlHandler.
    clauses
        onControlcell6(_CtrlID, _CtrlType, _CtrlWin, _CtrlInfo) = vpiOldDomains::handled(gui_api::rNull):-
            cell_click(6).

/* ------------------------------------------------------------------------------------------------------ */

    predicates
        onControlcell7 : vpiOldDomains::controlHandler.
    clauses
        onControlcell7(_CtrlID, _CtrlType, _CtrlWin, _CtrlInfo) = vpiOldDomains::handled(gui_api::rNull):-
            cell_click(7).

/* ------------------------------------------------------------------------------------------------------ */

    predicates
        onControlcell8 : vpiOldDomains::controlHandler.
    clauses
        onControlcell8(_CtrlID, _CtrlType, _CtrlWin, _CtrlInfo) = vpiOldDomains::handled(gui_api::rNull):-
            cell_click(8).

/* ------------------------------------------------------------------------------------------------------ */

    predicates
        onControlcell9 : vpiOldDomains::controlHandler.
    clauses
        onControlcell9(_CtrlID, _CtrlType, _CtrlWin, _CtrlInfo) = vpiOldDomains::handled(gui_api::rNull):-
            cell_click(9).

/* ------------------------------------------------------------------------------------------------------ */

    predicates
        onControlcell10 : vpiOldDomains::controlHandler.
    clauses
        onControlcell10(_CtrlID, _CtrlType, _CtrlWin, _CtrlInfo) = vpiOldDomains::handled(gui_api::rNull):-
            cell_click(10).

/* ------------------------------------------------------------------------------------------------------ */

    predicates
        onControlcell11 : vpiOldDomains::controlHandler.
    clauses
        onControlcell11(_CtrlID, _CtrlType, _CtrlWin, _CtrlInfo) = vpiOldDomains::handled(gui_api::rNull):-
            cell_click(11).

/* ------------------------------------------------------------------------------------------------------ */

    predicates
        onControlcell12 : vpiOldDomains::controlHandler.
    clauses
        onControlcell12(_CtrlID, _CtrlType, _CtrlWin, _CtrlInfo) = vpiOldDomains::handled(gui_api::rNull):-
            cell_click(12).

/* ------------------------------------------------------------------------------------------------------ */

    predicates
        onControlcell13 : vpiOldDomains::controlHandler.
    clauses
        onControlcell13(_CtrlID, _CtrlType, _CtrlWin, _CtrlInfo) = vpiOldDomains::handled(gui_api::rNull):-
            cell_click(13).

/* ------------------------------------------------------------------------------------------------------ */

    predicates
        onControlcell14 : vpiOldDomains::controlHandler.
    clauses
        onControlcell14(_CtrlID, _CtrlType, _CtrlWin, _CtrlInfo) = vpiOldDomains::handled(gui_api::rNull):-
            cell_click(14).

/* ------------------------------------------------------------------------------------------------------ */

    predicates
        onControlcell15 : vpiOldDomains::controlHandler.
    clauses
        onControlcell15(_CtrlID, _CtrlType, _CtrlWin, _CtrlInfo) = vpiOldDomains::handled(gui_api::rNull):-
            cell_click(15).

/* ------------------------------------------------------------------------------------------------------ */

    predicates
        onControlcell16 : vpiOldDomains::controlHandler.
    clauses
        onControlcell16(_CtrlID, _CtrlType, _CtrlWin, _CtrlInfo) = vpiOldDomains::handled(gui_api::rNull):-
            cell_click(16).

/* ------------------------------------------------------------------------------------------------------ */

    % This code is maintained by the VDE do not update it manually, 22:12:35-14.3.2004
    constants
        dialogType : vpiDomains::wintype = wd_Modal.
        title : string = "playDialog".
        rectangle : vpiDomains::rct = rct(200,40,359,263).
        dialogFlags : vpiDomains::wsflags = [wsf_Close,wsf_TitleBar].
        dialogFont = "MS Sans Serif".
        dialogFontSize = 8.

    constants
        controlList : vpiDomains::windef_list =
            [
            dlgFont(wdef(dialogType, rectangle, title, u_DlgBase),
                    dialogFont, dialogFontSize, dialogFlags),
            ctl(wdef(wc_PushButton,rct(40,166,67,178),"&Mix",u_DlgBase),idc_mix,[wsf_Group,wsf_TabStop]),
            ctl(wdef(wc_PushButton,rct(67,166,94,178),"&Reset",u_DlgBase),idc_reset,[wsf_Group,wsf_TabStop]),
            ctl(wdef(wc_PushButton,rct(40,178,67,190),"&Save",u_DlgBase),idc_save,[wsf_Group,wsf_TabStop]),
            ctl(wdef(wc_PushButton,rct(94,178,121,190),"&Open",u_DlgBase),idc_open,[wsf_Group,wsf_TabStop]),
            ctl(wdef(wc_PushButton,rct(40,190,121,202),"&Play",u_DlgBase),idc_play,[wsf_Group,wsf_TabStop,wsf_Disabled]),
            ctl(wdef(wc_PushButton,rct(94,166,121,178),"&Exit",u_DlgBase),idc_cancel,[wsf_Group,wsf_TabStop]),
            ctl(wdef(wc_PushButton,rct(40,40,60,60),"1",u_DlgBase),idc_cell1,[wsf_Group]),
            ctl(wdef(wc_PushButton,rct(60,40,80,60),"2",u_DlgBase),idc_cell2,[wsf_Group]),
            ctl(wdef(wc_PushButton,rct(80,40,100,60),"3",u_DlgBase),idc_cell3,[wsf_Group]),
            ctl(wdef(wc_PushButton,rct(100,40,120,60),"4",u_DlgBase),idc_cell4,[wsf_Group]),
            ctl(wdef(wc_PushButton,rct(40,60,60,80),"5",u_DlgBase),idc_cell5,[wsf_Group]),
            ctl(wdef(wc_PushButton,rct(60,60,80,80),"6",u_DlgBase),idc_cell6,[wsf_Group]),
            ctl(wdef(wc_PushButton,rct(80,60,100,80),"7",u_DlgBase),idc_cell7,[wsf_Group]),
            ctl(wdef(wc_PushButton,rct(100,60,120,80),"8",u_DlgBase),idc_cell8,[wsf_Group]),
            ctl(wdef(wc_PushButton,rct(40,80,60,100),"9",u_DlgBase),idc_cell9,[wsf_Group]),
            ctl(wdef(wc_PushButton,rct(60,80,80,100),"10",u_DlgBase),idc_cell10,[wsf_Group]),
            ctl(wdef(wc_PushButton,rct(80,80,100,100),"11",u_DlgBase),idc_cell11,[wsf_Group]),
            ctl(wdef(wc_PushButton,rct(100,80,120,100),"12",u_DlgBase),idc_cell12,[wsf_Group]),
            ctl(wdef(wc_PushButton,rct(40,100,60,120),"13",u_DlgBase),idc_cell13,[wsf_Group]),
            ctl(wdef(wc_PushButton,rct(60,100,80,120),"14",u_DlgBase),idc_cell14,[wsf_Group]),
            ctl(wdef(wc_PushButton,rct(80,100,100,120),"15",u_DlgBase),idc_cell15,[wsf_Group]),
            ctl(wdef(wc_PushButton,rct(100,100,120,120),"",u_DlgBase),idc_cell16,[wsf_Group]),
            ctl(wdef(wc_HScroll,rct(30,18,130,30),"",u_DlgBase),idc_sbht,[]),
            ctl(wdef(wc_VScroll,rct(130,30,142,130),"",u_DlgBase),idc_sbvr,[]),
            ctl(wdef(wc_HScroll,rct(30,130,130,142),"",u_DlgBase),idc_sbhb,[]),
            ctl(wdef(wc_VScroll,rct(18,30,30,130),"",u_DlgBase),idc_sbvl,[]),
            ctl(wdef(wc_PushButton,rct(67,178,94,190),"",u_DlgBase),idc_step,[wsf_Group]),
            ctl(wdef(wc_PushButton,rct(40,154,121,166),"",u_DlgBase),idc_bingo,[wsf_Group,wsf_Invisible])
            ].

    predicates
        generatedEventHandler : vpiDomains::ehandler.
    clauses
        generatedEventHandler(Win, e_create(_)) = _ :-
            thisWin := Win,
            fail.
        generatedEventHandler(_Win, e_Create(CreationData)) = Result :-
            handled(Result) = onCreate(CreationData).
        generatedEventHandler(_Win, e_Update(Rectangle)) = Result :-
            handled(Result) = onUpdate(Rectangle).
        generatedEventHandler(_Win, e_Control(idc_cancel, CtrlType, CtrlWin, CtlInfo)) = Result :-
            handled(Result) = onControlCancel(idc_cancel, CtrlType, CtrlWin, CtlInfo).
        generatedEventHandler(_Win, e_Control(idc_mix, CtrlType, CtrlWin, CtlInfo)) = Result :-
            handled(Result) = onControlmix(idc_mix, CtrlType, CtrlWin, CtlInfo).
        generatedEventHandler(_Win, e_Control(idc_reset, CtrlType, CtrlWin, CtlInfo)) = Result :-
            handled(Result) = onControlreset(idc_reset, CtrlType, CtrlWin, CtlInfo).
        generatedEventHandler(_Win, e_Control(idc_sbvr, CtrlType, CtrlWin, CtlInfo)) = Result :-
            handled(Result) = onControlsbvr(idc_sbvr, CtrlType, CtrlWin, CtlInfo).
        generatedEventHandler(_Win, e_Control(idc_sbvl, CtrlType, CtrlWin, CtlInfo)) = Result :-
            handled(Result) = onControlsbvl(idc_sbvl, CtrlType, CtrlWin, CtlInfo).
        generatedEventHandler(_Win, e_Control(idc_sbhb, CtrlType, CtrlWin, CtlInfo)) = Result :-
            handled(Result) = onControlsbhb(idc_sbhb, CtrlType, CtrlWin, CtlInfo).
        generatedEventHandler(_Win, e_Control(idc_sbht, CtrlType, CtrlWin, CtlInfo)) = Result :-
            handled(Result) = onControlsbht(idc_sbht, CtrlType, CtrlWin, CtlInfo).
        generatedEventHandler(_Win, e_Control(idc_save, CtrlType, CtrlWin, CtlInfo)) = Result :-
            handled(Result) = onControlsave(idc_save, CtrlType, CtrlWin, CtlInfo).
        generatedEventHandler(_Win, e_Control(idc_open, CtrlType, CtrlWin, CtlInfo)) = Result :-
            handled(Result) = onControlopen(idc_open, CtrlType, CtrlWin, CtlInfo).
        generatedEventHandler(_Win, e_Control(idc_play, CtrlType, CtrlWin, CtlInfo)) = Result :-
            handled(Result) = onControlplay(idc_play, CtrlType, CtrlWin, CtlInfo).
        generatedEventHandler(_Win, e_Control(idc_cell1, CtrlType, CtrlWin, CtlInfo)) = Result :-
            handled(Result) = onControlcell1(idc_cell1, CtrlType, CtrlWin, CtlInfo).
        generatedEventHandler(_Win, e_Control(idc_cell10, CtrlType, CtrlWin, CtlInfo)) = Result :-
            handled(Result) = onControlcell10(idc_cell10, CtrlType, CtrlWin, CtlInfo).
        generatedEventHandler(_Win, e_Control(idc_cell11, CtrlType, CtrlWin, CtlInfo)) = Result :-
            handled(Result) = onControlcell11(idc_cell11, CtrlType, CtrlWin, CtlInfo).
        generatedEventHandler(_Win, e_Control(idc_cell12, CtrlType, CtrlWin, CtlInfo)) = Result :-
            handled(Result) = onControlcell12(idc_cell12, CtrlType, CtrlWin, CtlInfo).
        generatedEventHandler(_Win, e_Control(idc_cell13, CtrlType, CtrlWin, CtlInfo)) = Result :-
            handled(Result) = onControlcell13(idc_cell13, CtrlType, CtrlWin, CtlInfo).
        generatedEventHandler(_Win, e_Control(idc_cell14, CtrlType, CtrlWin, CtlInfo)) = Result :-
            handled(Result) = onControlcell14(idc_cell14, CtrlType, CtrlWin, CtlInfo).
        generatedEventHandler(_Win, e_Control(idc_cell15, CtrlType, CtrlWin, CtlInfo)) = Result :-
            handled(Result) = onControlcell15(idc_cell15, CtrlType, CtrlWin, CtlInfo).
        generatedEventHandler(_Win, e_Control(idc_cell16, CtrlType, CtrlWin, CtlInfo)) = Result :-
            handled(Result) = onControlcell16(idc_cell16, CtrlType, CtrlWin, CtlInfo).
        generatedEventHandler(_Win, e_Control(idc_cell2, CtrlType, CtrlWin, CtlInfo)) = Result :-
            handled(Result) = onControlcell2(idc_cell2, CtrlType, CtrlWin, CtlInfo).
        generatedEventHandler(_Win, e_Control(idc_cell3, CtrlType, CtrlWin, CtlInfo)) = Result :-
            handled(Result) = onControlcell3(idc_cell3, CtrlType, CtrlWin, CtlInfo).
        generatedEventHandler(_Win, e_Control(idc_cell4, CtrlType, CtrlWin, CtlInfo)) = Result :-
            handled(Result) = onControlcell4(idc_cell4, CtrlType, CtrlWin, CtlInfo).
        generatedEventHandler(_Win, e_Control(idc_cell5, CtrlType, CtrlWin, CtlInfo)) = Result :-
            handled(Result) = onControlcell5(idc_cell5, CtrlType, CtrlWin, CtlInfo).
        generatedEventHandler(_Win, e_Control(idc_cell6, CtrlType, CtrlWin, CtlInfo)) = Result :-
            handled(Result) = onControlcell6(idc_cell6, CtrlType, CtrlWin, CtlInfo).
        generatedEventHandler(_Win, e_Control(idc_cell7, CtrlType, CtrlWin, CtlInfo)) = Result :-
            handled(Result) = onControlcell7(idc_cell7, CtrlType, CtrlWin, CtlInfo).
        generatedEventHandler(_Win, e_Control(idc_cell8, CtrlType, CtrlWin, CtlInfo)) = Result :-
            handled(Result) = onControlcell8(idc_cell8, CtrlType, CtrlWin, CtlInfo).
        generatedEventHandler(_Win, e_Control(idc_cell9, CtrlType, CtrlWin, CtlInfo)) = Result :-
            handled(Result) = onControlcell9(idc_cell9, CtrlType, CtrlWin, CtlInfo).
        generatedEventHandler(_Win, e_Destroy()) = Result :-
            handled(Result) = onDestroy().
    % end of automatic code
end implement playDialog
