select
   accept Wake_Up (Parameters : Work_Item) do
      Current_Work_Item := Parameters;
   end;
   Process (Current_Work_Item);
or accept Shut_Down;
   exit;       -- Shut down requested
end select;
