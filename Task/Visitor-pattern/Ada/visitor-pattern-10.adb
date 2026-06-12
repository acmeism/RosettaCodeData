with Cars;
with Car_Visitors;

procedure Visitor_Pattern is
   Car       : Cars.Car := Cars.Make;
   Printer   : Car_Visitors.Print_Visitor;
   Performer : Car_Visitors.Perform_Visitor;
begin
   Car.Accept_Visitor (Printer);
   Car.Accept_Visitor (Performer);
end Visitor_Pattern;
