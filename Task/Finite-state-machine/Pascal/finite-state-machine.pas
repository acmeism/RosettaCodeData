{
   fsm1.pas

   Copyright 2018 Trevor Pearson <trevor @ nb-LadyNada co uk >

   This program is free software; you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation; either version 2 of the License, or
   (at your option) any later version.

   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.

   You should have received a copy of the GNU General Public License
   along with this program; if not, write to the Free Software
   Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston,
   MA 02110-1301, USA.

   Implementing a simulation of a vending machine using a finite state
   machine. I have used the classic table based method and added a
   * little extra stuff to give the routines something to do.


}



program fsm1.pas;

uses sysutils;


type

    state = (Null,Ready,Waiting,Refund,Dispense,Stop);
    event = (Epsilon := 1,Deposit,Select,Cancel,Remove,Quit,Error);
	Item = record
	     Name : string[12];
		 Stock: shortint;
		 price: currency;
	end;


var
    amountPaid, itemPrice , changeDue: currency;
    I,J : integer;
	machineState: state;
	newState: state;
	machineEvent: event;
	entry:string;
	vend : array[0..4,0..4] of Item;
	machine : array[1..7,1..7] of state;

	{ The following routines implement the transitions }

procedure TOready();

var
 i,j : integer;

begin

    { Always set the state of a state machine as the first thing you do
	We also set the event to epsiion we can allways set it to error if there is a problem}

	machineState := Ready;
	machineEvent := Epsilon;

	{ Now do whatever we need to to transition into this state and check for errors}

    Writeln('            Trevors vending machine');
    Writeln('');
    WriteLn ('        A          B           C            D' );
    for i:=1 to 2 do begin
        write(i,'    ');
        for j:=1 to 4 do begin
	        write(vend[j,i].Name,' ':(12-length(vend[j,i].Name)));
        end;
	    WriteLn();
		Write('       ');
	    for j:=1 to 4 do begin
	        write('£',vend[j,i].price:4:2,'      ');
        end;
	    Writeln('');
    end;

	{ We should have delt with money }
	if (amountPaid > 0) then  machineEvent := Error;
	if (changeDue > 0) then  machineEvent := Error;

end;

procedure TOwaiting();
begin
	machineState := Waiting;
	if ((machineEvent = Select) and (amountPaid >= itemPrice)) then machineEvent := Epsilon;
	if ((machineEvent = Deposit) and (amountPaid >= itemPrice)) then machineEvent := Epsilon;
	
end;

procedure TOrefund();

begin
	machineState := Refund;
    machineEvent := Epsilon;

     if (amountPaid > 0) then changeDue := amountPaid;
     WriteLn('REFUNDING >> £' , changeDue:2:2);
     changeDue := 0;
     amountPaid := 0;
end;

procedure TOdispense();
begin
   machineState := Dispense;

   if (amountPaid >= vend[I,J].price) then  begin
        machineEvent := Remove;
       changeDue := amountPaid - vend[I,J].price ;
       amountPaid := 0;
       vend[I,J].Stock := vend[I,J].Stock - 1;
       WriteLn('Vending  >>',vend[I,J].Name);
    end
    else machineState := Waiting;
end;

procedure TOstop();
begin
	machineState := Stop;
	machineEvent := Epsilon;
	{ There should not be any transaction in process }
	if ((amountPaid >0) or (changeDue >0)) then machineEvent := Error;
	
end;



procedure Init;
var k,l: integer;
begin


   { Lets pretend we have some stuff in this machine }

    vend[0,0].Name := 'Dummy';
    vend[0,0].Stock := 0;
    vend[0,0].price := 9999;

    vend[1,1].Name := 'Snickers';
	vend[1,1].Stock := 12;
	vend[1,1].price := 0.50;

    vend[2,1].Name := 'Aero';
	vend[2,1].Stock := 12;
	vend[2,1].price := 0.50;

	vend[3,1].Name := 'Bounty';
	vend[3,1].Stock := 10;
	vend[3,1].price := 0.75;

	vend[4,1].Name := 'Creme egg';
	vend[4,1].Stock := 15;
	vend[4,1].price := 0.60;

	vend[1,2].Name := 'Coke-Cola';
	vend[1,2].Stock := 6;
	vend[1,2].price := 1.10;

	vend[2,2].Name := 'Pepsi';
	vend[2,2].Stock := 6;
	vend[2,2].price := 1.25;

	vend[3,2].Name := '7 up';
	vend[3,2].Stock := 6;
	vend[3,2].price := 1.15;

	vend[4,2].Name := 'Dr Pepper';
	vend[4,2].Stock := 6;
	vend[4,2].price := 1.99;

   { Set up the state table }

    for k :=1 to 7 do begin
	   for l :=1 to 6 do machine[k,l] := Null;
    end;

	machine[ord(Ready),ord(Deposit)] := Waiting;
	machine[ord(Waiting),ord(Deposit)] := Dispense;
	machine[ord(Waiting),ord(Select)] := Dispense;
	machine[ord(Waiting),ord(Cancel)] := Refund;
	machine[ord(Dispense),ord(Remove)] := Refund;
	machine[ord(Dispense),ord(Error)] := Refund;
	machine[ord(Refund),ord(epsilon)] := Ready;
	machine[ord(Ready),ord(Select)] := Waiting;
	machine[ord(Ready),ord(Quit)] := Stop;

   { There should be no money entered so no change is due
   * set itemPrice to a huge dummy amount}

   amountPaid := 0;
   changeDue := 0;
   itemPrice := 999;
   I:= 0;
   J:=0;
end;



begin
    Init;
    TOready;
 { Here comes the magic bit ... We check for events and if an event
 * occurs we look up on the table to see if we need to transition to
 * another state. If we do we call the TO_xxxxx procedure. BUT we do
 * this in the other order to check for machine generated events like
 * Error and Epsilon. }
   repeat
       newState := machine[ord(machineState),ord(machineEvent)];
	   case (newState) of
	      Ready : TOready;
		  Waiting : TOwaiting;
		  Dispense : Todispense;
		  Refund: Torefund;
		  Stop: TOStop;
	   end;


{ We get some user input and assign an event to it
* If the user enters a number we convert it to currency and set a
* deposit event If we have a letter we are making a selection }
       if (machineState = Ready) or (machineState = Waiting) then begin
           WriteLn;
	       Writeln('Enter Selectian A1..D4');
	       Writeln('or deposit amount e.g, 0.20 -- 20p piece.');
	       Write('Or X to cancel, Q to stop this machine :');
	       ReadLn (entry);
	       if ((entry = 'q') or (entry = 'Q')) then machineEvent := Quit;
	       if ((entry = 'x') or (entry = 'X')) then machineEvent := Cancel;
	       if ((entry[1] in ['a'..'d']) or (entry[1] in ['A'..'D'])) then machineEvent:= Select;
	       if (entry[1] in ['0'..'9']) then  begin
	           machineEvent := Deposit;
	           amountPaid := StrToCurr(entry);
	       end;
	       if (machineEvent = Select) then begin
	           I := ord(entry[1]) - 64;
	           if (I > 5) then I := I - 32;
	           J := ord(entry[2]) - ord('0');
	        end;
	
       end;
   until machineEvent = Quit;

end.

