{$mode objfpc}{$ifdef mswindows}{$apptype console}{$endif}
const
  true = 'true';
  false = 'false';
begin
  writeln(true);
  writeln(false);
end.

[ EDIT ]

See https://wiki.freepascal.org/Boolean

While you can assign values to true and false, it has now nothing to do with the boolean values....
Try with this function:

FUNCTION IsNatural ( CONST num: VARIANT ): BOOLEAN;

    BEGIN

	IsNatural := ( num > 0 );

    END;
