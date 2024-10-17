var
  lLibraryHandle: THandle;
  lDoSomething: procedure; stdcall;
begin
  lLibraryHandle := LoadLibrary('MYLIB.DLL');
  if lLibraryHandle >= 32 then { success }
  begin
    lDoSomething := GetProcAddress(lLibraryHandle, 'DoSomething');
    lDoSomething();
    FreeLibrary(lLibraryHandle);
  end;
end;
