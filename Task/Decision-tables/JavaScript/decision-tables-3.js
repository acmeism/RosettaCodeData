  function Ask(q) {
    WScript.StdOut.Write(q);
    WScript.StdOut.Write(" [Y/N]?");
    var ans = WScript.StdIn.ReadLine();
    ans = ans.substr(0, 1).toUpperCase() === "Y" ? "Y" : "N";
    return ans;
  }
  function Tell(w) {
    WScript.Echo(w);
  }

  function Check_the_power_cable() {
    Tell("Check the power cable.");
  }
  function Check_the_printer_computer_cable() {
    Tell("Check the printer-computer cable.");
  }
  function Ensure_printer_software_is_installed() {
    Tell("Ensure printer software is installed.");
  }
  function Check_replace_ink() {
    Tell("Check/replace ink.");
  }
  function Check_for_paper_jam() {
    Tell("Check for paper jam.");
  }

  function Printer_Prints() {
    return Ask("Printer prints");
  }
  function A_red_light_is_flashing() {
    return Ask("A red light is flashing");
  }
  function Printer_is_recognized_by_computer() {
    return Ask("Printer is recognized by computer");
  }

  var DT = new DecTab()
  .Conditions(
    Printer_Prints,
    A_red_light_is_flashing,
    Printer_is_recognized_by_computer)
  .RulesActions(["N", "Y", "N"], [Check_the_printer_computer_cable, Ensure_printer_software_is_installed, Check_replace_ink])
  .RulesActions(["N", "Y", "Y"], [Check_replace_ink, Check_for_paper_jam])
  .RulesActions(["N", "N", "N"], [Check_the_power_cable, Check_the_printer_computer_cable, Ensure_printer_software_is_installed])
  .RulesActions(["N", "N", "Y"], [Check_for_paper_jam])
  .RulesActions(["Y", "Y", "N"], [Ensure_printer_software_is_installed, Check_replace_ink])
  .RulesActions(["Y", "Y", "Y"], [Check_replace_ink])
  .RulesActions(["Y", "N", "N"], [Ensure_printer_software_is_installed])
  .RulesActions(["Y", "N", "Y"], [])
  .Decide();
