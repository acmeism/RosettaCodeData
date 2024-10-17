uses PlotWPF,GraphWPF;

begin
  Window.SetSize(600,600);
  var seq := Range(0,20,0.1);
  var xx := seq.Select(t -> t * Cos(t));
  var yy := seq.Select(t -> t * Sin(t));
  LineGraphWPF.Create(xx,yy,Colors.Black);
end.
