declare
  fun {GetPage Url}
     F = {New Open.file init(url:Url)}
     Contents = {F read(list:$ size:all)}
  in
     {F close}
     Contents
  end
in
  {System.showInfo {GetPage "http://www.rosettacode.org"}}
