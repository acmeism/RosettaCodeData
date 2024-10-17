procedure HaltAndCatchFire;
begin
raise Exception.Create('Burning to the ground');
end;
