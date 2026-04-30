with Config; use Config;
with Ada.Text_IO; use Ada.Text_IO;

procedure Rosetta_Read_Cfg is
  cfg: Configuration:= Init("rosetta_read.cfg", Case_Sensitive => False, Variable_Terminator => ' ');
  fullname       : String  := cfg.Value_Of("*", "fullname");
  favouritefruit : String  := cfg.Value_Of("*", "favouritefruit");
  needspeeling   : Boolean := cfg.Is_Set("*", "needspeeling");
  seedsremoved   : Boolean := cfg.Is_Set("*", "seedsremoved");
  otherfamily    : String  := cfg.Value_Of("*", "otherfamily");
begin
  Put_Line("fullname = "       & fullname);
  Put_Line("favouritefruit = " & favouritefruit);
  Put_Line("needspeeling = "   & Boolean'Image(needspeeling));
  Put_Line("seedsremoved = "   & Boolean'Image(seedsremoved));
  Put_Line("otherfamily = "    & otherfamily);
end;
