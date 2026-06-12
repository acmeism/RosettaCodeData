with Ada.Exceptions;
with Interfaces.C;
use Interfaces;

with Text_Io;

procedure Pipes is

  pragma Assertion_Policy(Check);

  type Size_T is new Long_Integer;
  type Mode_T is new Integer;
  type File_Id is new Integer;
  subtype Ssize_T is Size_T;

  Global_Tally : Ssize_T := 0;

  O_RDWR : aliased c.int := 0;   --  pragma import(C, O_RDWR, "O_RDWR");
  O_WRONLY : aliased c.int := 1; -- pragma import(C, O_WRONLY, "O_WRONLY");

  use type C.Int;

  procedure Create_Fifo(Name : String) is
    Result : C.Int := -1;
    subtype Path_Name_Type is String(Name'first..Name'last +1);
    My_Path : aliased Path_Name_Type := Name & Ascii.Nul;

    function Mkfifo(Path : access Path_Name_Type; Permission : Mode_T) return C.Int;
    pragma Import(C, Mkfifo, "mkfifo");
   begin
     Result := Mkfifo(My_Path'access, 8#660# );
   end Create_Fifo;
   -------------------------------

  function Open(Name : String; Flags : Interfaces.C.Int) return File_Id is
    subtype Path_Name_Type is String(Name'first..Name'last +1);
    My_Path : aliased Path_Name_Type := Name & Ascii.Nul;

    function cOpen(Path  : access Path_Name_Type;
                   Flags : Interfaces.C.Int;
                   Mode  : Mode_T ) return File_Id;
    pragma Import(C, cOpen, "open" );
    Result : file_id := -1;

  begin
    Result := cOpen(My_Path'access,Flags, 8#660#);
    pragma Assert(Result >= 0, "bad Open:" & Result'Image);
    return Result;
  end Open;

  -----------------------------------

  function Close( File : File_Id ) return C.Int;
  pragma import( C, Close ,"close" );

  ------------------------------------

  subtype Message_Type is String(1..4096);

  procedure Read(File : File_Id; Msg : in out Message_Type; len : out Ssize_T) is

    Message_Buffer : aliased Message_Type;
    function cRead(Fd    : File_Id;
                   Buf   : access Message_Type;
                   Count : Size_T ) return Ssize_T;
    pragma import( C, cRead , "read");
  begin
    Len := cRead(File, Message_Buffer'access, Size_T( Message_Buffer'last));
    pragma Assert(Len >= 0, "bad Read:" & Len'image);
    Msg := Message_Buffer;
  end Read;

  ------------------------------

  procedure Write(File : File_Id; Msg : in String) is

    subtype Value_Type is String(Msg'first..Msg'last +1);
    My_Value : aliased Value_Type := Msg & Ascii.Nul;

    function cWrite( Fd    : File_Id;
                     Buf   : access Value_Type;
                     Count : Size_T ) return Ssize_T;
    pragma import( C, cWrite , "write");
    dummy : Ssize_T;
  begin
    dummy := cWrite(File, My_Value'access, Size_T(My_Value'last));
    pragma Assert(dummy >= 0, "bad Write:" & dummy'image);
  end Write;

  -------------------------------

  procedure Read_Loop is
    Fd  : File_Id;
    Buf : Message_Type;
    Len : Ssize_T;
    Dummy : C.Int;
  begin
    outer : loop
      Text_Io.Put_Line ("read_loop-outer: before open");
      Fd := Open("in_pipe", O_RDWR);
      inner : loop
        Text_Io.Put_Line ("read_loop-inner: before read");
        Read(Fd, Buf, Len);
        Text_Io.Put_Line ("read_loop-inner: read" & Len'img &
                          " bytes '" & Buf(1..Integer(len)) & "'");
        exit inner when Len = 0;
        Global_Tally := Global_Tally + Len;
      end loop inner;
      Text_Io.Put_Line ("read_loop-outer:  before close");
      Dummy := Close(Fd);
    end loop outer;
  end Read_Loop;
  ------------------------------

  task Writer is
    entry Start;
  end Writer;

  task body Writer is
    Fd : File_Id;
    Dummy : C.Int;
  begin
    Text_Io.Put_Line ("task writer: wait for start");

    accept Start; -- wait here until called. Rendez-vouz is done here
    Text_Io.Put_Line ("task writer: start called");

    loop
      Text_Io.Put_Line ("task writer-loop: wait for open call by others");
      Fd := Open("out_pipe", O_WRONLY);  -- block open, until a reader comes along
      Text_Io.Put_Line ("task writer: wrote" & Global_Tally'image);
      Write(fd,Global_Tally'image);
      dummy := Close(fd);
      delay 0.01; -- force context change
    end loop;

  end Writer;
  ---------------------------------

begin
  -- Create the fifos.  It's ok if the fifos already exist;
  Create_Fifo("in_pipe");
  Create_Fifo("out_pipe");

  Writer.Start;
  Read_Loop;
exception
  when E: others =>
    declare
      Last_Exception_Name     : constant String := Ada.Exceptions.Exception_Name(E);
      Last_Exception_Messsage : constant String := Ada.Exceptions.Exception_Message(E);
    begin
      Text_Io.Put_Line ("Last_Exception_Name: " & Last_Exception_Name);
      Text_Io.Put_Line ("Last_Exception_Messsage: " & Last_Exception_Messsage);
    end;

end Pipes;

