uses WPF;

begin
  var mainpanel := Panels.StackPanel(200).AsMainContent;
  var b := CreateButton('Click me!');
  var lb := CreateLabel('0');
  mainpanel.AddElements(b,lb);
  var clicks := 0;
  b.Click += (o,e) -> begin
    clicks += 1;
    lb.Content := clicks;
  end;
end.
