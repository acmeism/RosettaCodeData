#!/usr/bin/instantfpc
//program ABCProblem;

{$mode objfpc}{$H+}

uses SysUtils, Classes;

const
  // every couple of chars is a block
  // remove one by replacing its 2 chars by 2 spaces
  Blocks =  'BO XK DQ CP NA GT RE TG QD FS JW HU VI AN OB ER FS LY PC ZM';
  BlockSize = 3;

function can_make_word(Str: String): boolean;
var
  wkBlocks: string = Blocks;
  c: Char;
  iPos : Integer;
begin
  // all chars to uppercase
  Str := UpperCase(Str);
  Result := Str <> '';
  if Result then
  begin
    for c in Str do
    begin
      iPos := Pos(c, wkBlocks);
      if (iPos > 0) then
      begin
        // Char found
        wkBlocks[iPos] := ' ';
        // Remove the other face
        if (iPos mod BlockSize = 1) then
          wkBlocks[iPos + 1] := ' '
        else
          wkBlocks[iPos - 1] := ' ';
      end
      else
      begin
        //  missed
        Result := False;
        break;
      end;
    end;
  end;
  // Debug...
  //WriteLn(Blocks);
  //WriteLn(wkBlocks);
End;

procedure TestABCProblem(Str: String);
const
  boolStr : array[boolean] of String = ('False', 'True');
begin
  WriteLn(Format('>>> can_make_word("%s")%s%s', [Str, LineEnding, boolStr[can_make_word(Str)]]));
End;

begin
  TestABCProblem('A');
  TestABCProblem('BARK');
  TestABCProblem('BOOK');
  TestABCProblem('TREAT');
  TestABCProblem('COMMON');
  TestABCProblem('SQUAD');
  TestABCProblem('CONFUSE');
END.
