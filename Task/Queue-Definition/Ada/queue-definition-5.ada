 package body Generic_Fifo is

    ----------
    -- Push --
    ----------

    procedure Push (The_Fifo : in out Fifo_Type; Item : in Element_Type) is
    begin
       The_Fifo.Prepend(Item);
    end Push;

    ---------
    -- Pop --
    ---------

    procedure Pop (The_Fifo : in out Fifo_Type; Item : out Element_Type) is
    begin
       if Is_Empty(The_Fifo) then
          raise Empty_Error;
       end if;
       Item := The_Fifo.Last_Element;
       The_Fifo.Delete_Last;
    end Pop;

 end Generic_Fifo;
