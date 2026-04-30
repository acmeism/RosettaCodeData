with Asynchronous_Fifo;
with Ada.Text_Io; use Ada.Text_Io;

 procedure Asynchronous_Fifo_Test is
    package Int_Fifo is new Asynchronous_Fifo(Integer);
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
             Buffer.Push(Val);
             Val := Val + 1;
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
             Buffer.Pop(Val);
             Put_Line(Integer'Image(Val));
          end select;
       end loop;<syntaxhighlight lang="ada">
    end Reader;
 begin
    delay 0.1;
    Writer.Stop;
    Reader.Stop;
 end Asynchronous_Fifo_Test;
