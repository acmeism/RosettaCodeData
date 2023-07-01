#!/usr/bin/instantfpc
//program ArrayLength;

{$mode objfpc}{$H+}

uses SysUtils, Classes;

const
  Fruits : array[0..1] of String = ('apple', 'orange');

begin
   WriteLn('Length of Fruits by function : ', Length(Fruits));
   WriteLn('Length of Fruits by bounds : ', High(Fruits) - Low(Fruits) + 1);
END.
