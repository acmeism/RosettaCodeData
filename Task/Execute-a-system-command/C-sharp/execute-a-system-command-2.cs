using System;

  class Execute {
     static void Main() {
         System.Diagnostics.Process proc = new System.Diagnostics.Process();
         proc.EnableRaisingEvents=false;
         proc.StartInfo.FileName="ls";
         proc.Start();
    }
 }
