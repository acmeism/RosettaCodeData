Declare
  /*====================================================================================================
  -- For     :  https://rosettacode.org/
  -- --
  -- Task    : Factorial
  -- Method  : iterative
  -- Language: PL/SQL
  --
  -- 2020-12-30 by alvalongo
  ====================================================================================================*/
  --
  function fnuFactorial(inuValue   integer)
  return number
  is
    nuFactorial number;
  Begin
    if inuValue is not null then
       nuFactorial:=1;
       --
       if inuValue>=1 then
          --
          For nuI in 1..inuValue loop
              nuFactorial:=nuFactorial*nuI;
          end loop;
          --
       End if;
       --
    End if;
    --
    return(nuFactorial);
  End fnuFactorial;
BEGIN
  For nuJ in 0..100 loop
      Dbms_Output.Put_Line('Factorial('||nuJ||')='||fnuFactorial(nuJ));
  End loop;
END;
