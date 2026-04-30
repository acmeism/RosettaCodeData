with Ada.Interrupts; use Ada.Interrupts;
with Ada.Interrupts.Names; use Ada.Interrupts.Names;

package Sigint_Handler is
      protected Handler is
      entry Wait;
      procedure Handle;
      pragma Interrupt_Handler(Handle);
      pragma Attach_Handler(Handle, Sigint);
      private
      Call_Count : Natural := 0;
   end Handler;

end Sigint_Handler;
