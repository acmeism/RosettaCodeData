configuration DSA is
   pragma Starter (None);

   -- Server
   Server_Partition : Partition := (Server);
   procedure Run_Server is in Server_Partition;

   -- Client
   Client_Partition : Partition;
   for Client_Partition'Termination use Local_Termination;
   procedure Client;
   for Client_Partition'Main use Client;
end DSA;
