Create or replace Function fnu_fibonnaci(p_iNumber integer)
return integer
is
  nuFib  integer;
  nuP  integer;
  nuQ  integer;
Begin
  if p_iNumber is not null then
     if p_iNumber=0 then
        nuFib:=0;
     Elsif p_iNumber=1 then
            nuFib:=1;
     Else
        nuP:=0;
        nuQ:=1;
        For nuI in 2..p_iNumber loop
            nuFib:=nuP+nuQ;
            nuP:=nuQ;
            nuQ:=nuFib;
        End loop;
     End if;
  End if;
  return(nuFib);
End fnu_fibonnaci;
