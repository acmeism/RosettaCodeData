with Synchronous_Fifo;
with Ada.Text_Io; use Ada.Text_Io;

 procedure Synchronous_Fifo_Test is
    package Int_Fifo is new Synchronous_Fifo(Integer);
    use Int_Fifo;
    Buffer : Fifo;

    task Writer is
       entry Stop;
    end Writer;

    task body Writer is
       Val : Positive := 1;
    begin
       loop
          select
             accept Stop;
             exit;
          else
             select
                Buffer.Push(Val);
                Val := Val + 1;
             or
                delay 1.0;
             end select;
          end select;
       end loop;
    end Writer;

    task Reader is
       entry Stop;
    end Reader;

    task body Reader is
       Val : Positive;
    begin
       loop
          select
             accept Stop;
             exit;
          else
             select
                Buffer.Pop(Val);
                Put_Line(Integer'Image(Val));
             or
                 delay 1.0;
            end select;
          end select;
       end loop;
    end Reader;
 begin
    delay 0.1;
    Writer.Stop;
    Reader.Stop;
 end Synchronous_Fifo_Test;
