with Ada.Text_IO;
with Ada.IO_Exceptions;
with GNAT.Sockets;
procedure echo_server_multi is
-- Multiple socket connections example based on Rosetta Code echo server.

   Tasks_To_Create : constant := 3; -- simultaneous socket connections.

-------------------------------------------------------------------------------
-- Use stack to pop the next free task index. When a task finishes its
-- asynchronous (no rendezvous) phase, it pushes the index back on the stack.
   type Integer_List is array (1..Tasks_To_Create) of integer;
   subtype Counter is integer range 0 .. Tasks_To_Create;
   subtype Index is integer range 1 .. Tasks_To_Create;
   protected type Info is
      procedure Push_Stack (Return_Task_Index : in Index);
      procedure Initialize_Stack;
      entry Pop_Stack (Get_Task_Index : out Index);
   private
      Task_Stack   : Integer_List; -- Stack of free-to-use tasks.
      Stack_Pointer: Counter := 0;
   end Info;

   protected body Info is
      procedure Push_Stack (Return_Task_Index : in Index) is
      begin -- Performed by tasks that were popped, so won't overflow.
         Stack_Pointer := Stack_Pointer + 1;
         Task_Stack(Stack_Pointer) := Return_Task_Index;
      end;

      entry Pop_Stack (Get_Task_Index : out Index) when Stack_Pointer /= 0 is
      begin -- guarded against underflow.
         Get_Task_Index := Task_Stack(Stack_Pointer);
         Stack_Pointer := Stack_Pointer -  1;
      end;

      procedure Initialize_Stack is
      begin
         for I in Task_Stack'range loop
            Push_Stack (I);
         end loop;
      end;
   end Info;

   Task_Info : Info;

-------------------------------------------------------------------------------
   task type SocketTask is
      -- Rendezvous the setup, which sets the parameters for entry Echo.
      entry Setup (Connection : GNAT.Sockets.Socket_Type;
                   Client     : GNAT.Sockets.Sock_Addr_Type;
                   Channel    : GNAT.Sockets.Stream_Access;
                   Task_Index : Index);
      -- Echo accepts the asynchronous phase, i.e. no rendezvous. When the
      -- communication is over, push the task number back on the stack.
      entry Echo;
   end SocketTask;

   task body SocketTask is
      my_Connection : GNAT.Sockets.Socket_Type;
      my_Client     : GNAT.Sockets.Sock_Addr_Type;
      my_Channel    : GNAT.Sockets.Stream_Access;
      my_Index      : Index;
   begin
      loop -- Infinitely reusable
         accept Setup (Connection : GNAT.Sockets.Socket_Type;
                       Client  : GNAT.Sockets.Sock_Addr_Type;
                       Channel : GNAT.Sockets.Stream_Access;
                       Task_Index   : Index) do
            -- Store parameters and mark task busy.
            my_Connection := Connection;
            my_Client     := Client;
            my_Channel    := Channel;
            my_Index      := Task_Index;
         end;

         accept Echo; -- Do the echo communications.
         begin
            Ada.Text_IO.Put_Line ("Task " & integer'image(my_Index));
            loop
               Character'Output (my_Channel, Character'Input(my_Channel));
            end loop;
         exception
            when Ada.IO_Exceptions.End_Error =>
              Ada.Text_IO.Put_Line ("Echo " & integer'image(my_Index) & " end");
            when others =>
              Ada.Text_IO.Put_Line ("Echo " & integer'image(my_Index) & " err");
         end;
         GNAT.Sockets.Close_Socket (my_Connection);
         Task_Info.Push_Stack (my_Index); -- Return to stack of unused tasks.
      end loop;
   end SocketTask;

-------------------------------------------------------------------------------
-- Setup the socket receiver, initialize the task stack, and then loop,
-- blocking on Accept_Socket, using Pop_Stack for the next free task from the
-- stack, waiting if necessary.
   task type SocketServer (my_Port : GNAT.Sockets.Port_Type) is
      entry Listen;
   end SocketServer;

   task body SocketServer is
   Receiver   : GNAT.Sockets.Socket_Type;
   Connection : GNAT.Sockets.Socket_Type;
   Client     : GNAT.Sockets.Sock_Addr_Type;
   Channel    : GNAT.Sockets.Stream_Access;
   Worker     : array (1..Tasks_To_Create) of SocketTask;
   Use_Task   : Index;

   begin
      accept Listen;
      GNAT.Sockets.Create_Socket (Socket => Receiver);
      GNAT.Sockets.Set_Socket_Option
        (Socket => Receiver,
         Level  => GNAT.Sockets.Socket_Level,
         Option => (Name    => GNAT.Sockets.Reuse_Address, Enabled => True));
      GNAT.Sockets.Bind_Socket
        (Socket  => Receiver,
         Address => (Family => GNAT.Sockets.Family_Inet,
                     Addr   => GNAT.Sockets.Inet_Addr ("127.0.0.1"),
                     Port   => my_Port));
      GNAT.Sockets.Listen_Socket (Socket => Receiver);
      Task_Info.Initialize_Stack;
Find: loop -- Block for connection and take next free task.
         GNAT.Sockets.Accept_Socket
           (Server  => Receiver,
            Socket  => Connection,
            Address => Client);
         Ada.Text_IO.Put_Line ("Connect " & GNAT.Sockets.Image(Client));
         Channel := GNAT.Sockets.Stream (Connection);
         Task_Info.Pop_Stack(Use_Task); -- Protected guard waits if full house.
         -- Setup the socket in this task in rendezvous.
         Worker(Use_Task).Setup(Connection,Client, Channel,Use_Task);
         -- Run the asynchronous task for the socket communications.
         Worker(Use_Task).Echo; -- Start echo loop.
      end loop Find;
   end SocketServer;

   Echo_Server : SocketServer(my_Port => 12321);

-------------------------------------------------------------------------------
begin
   Echo_Server.Listen;
end echo_server_multi;
