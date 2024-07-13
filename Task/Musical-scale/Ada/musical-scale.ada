pragma Ada_2022;
with Ada.Numerics;                      use Ada.Numerics;
with Ada.Numerics.Elementary_Functions; use Ada.Numerics.Elementary_Functions;
with Ada.Sequential_IO;
with Interfaces;                        use Interfaces;

procedure Musical_Scale is
   package Byte_IO is new Ada.Sequential_IO (Unsigned_8); use Byte_IO;

   SAMPLE_RATE : constant Unsigned_32 := 44100;
   DURATION    : constant Unsigned_32 := 8;
   DATA_LENGTH : constant Unsigned_32 := SAMPLE_RATE * DURATION;
   WAV_HDR_LEN : constant Integer     := 44;
   FILE_SIZE_8 : constant Unsigned_32 := Unsigned_32 (WAV_HDR_LEN) + DATA_LENGTH + 4;

   type Byte_Arr is array (Positive range <>) of Unsigned_8;
   Wav_Header : constant Byte_Arr (1 .. WAV_HDR_LEN) := [
      Character'Pos ('R'), Character'Pos ('I'), Character'Pos ('F'), Character'Pos ('F'),
      Unsigned_8 (FILE_SIZE_8 and 16#ff#),
      Unsigned_8 (Shift_Right (FILE_SIZE_8, 8) and 16#ff#),
      Unsigned_8 (Shift_Right (FILE_SIZE_8, 16) and 16#ff#),
      Unsigned_8 (Shift_Right (FILE_SIZE_8, 24) and 16#ff#),
      Character'Pos ('W'), Character'Pos ('A'), Character'Pos ('V'), Character'Pos ('E'),
      Character'Pos ('f'), Character'Pos ('m'), Character'Pos ('t'), Character'Pos (' '),
      16#10#, 0, 0, 0, 1, 0, 1, 0, 16#44#, 16#ac#, 0, 0, 16#44#, 16#ac#, 0, 0, 1, 0, 8, 0,
      Character'Pos ('d'), Character'Pos ('a'), Character'Pos ('t'), Character'Pos ('a'),
      Unsigned_8 (DATA_LENGTH and 16#ff#),
      Unsigned_8 (Shift_Right (DATA_LENGTH, 8) and 16#ff#),
      Unsigned_8 (Shift_Right (DATA_LENGTH, 16) and 16#ff#),
      Unsigned_8 (Shift_Right (DATA_LENGTH, 24) and 16#ff#)
   ];
   MIDI_Header : constant Byte_Arr (1 .. 22) := [
      Character'Pos ('M'), Character'Pos ('T'), Character'Pos ('h'), Character'Pos ('d'),
      0, 0, 0, 6, 0, 0, 0, 1, 0, 96, --  File header
      Character'Pos ('M'), Character'Pos ('T'), Character'Pos ('r'), Character'Pos ('k'),
      0, 0, 0, 8 * 8 + 4             -- Track header
   ];
   MIDI_Trailer : constant Byte_Arr := [0, 16#ff#, 16#2f#, 0];
   type Freq_Arr is array (Positive range <>) of Float;
   Freqs : constant Freq_Arr := [261.63, 293.67, 329.63, 349.23, 392.0, 440.0, 493.88, 523.25];
   Notes : constant Byte_Arr := [60, 62, 64, 65, 67, 69, 71, 72];
   Note_On_Off : Byte_Arr    := [0, 16#90#, 0, 16#40#, 16#60#, 16#80#, 0, 0];

   Wav_File, MIDI_File : File_Type;
   Omega               : Float;

   procedure Write_Arr (File : File_Type; Arr : Byte_Arr) is
   begin
      for B of Arr loop
         Write (File, B);
      end loop;
   end Write_Arr;

begin
   Create (Wav_File, Out_File, "scale.wav");
   Write_Arr (Wav_File, Wav_Header);
   for Freq of Freqs loop
      Omega := 2.0 * Pi * Freq;
      for Tick in 0 .. Integer (DATA_LENGTH) / 8 loop
         Write (Wav_File, Unsigned_8 (32.0 * (Sin (Omega  * Float (Tick) / Float (SAMPLE_RATE)) + 1.0)));
      end loop;
   end loop;
   Close (Wav_File);

   Create (MIDI_File, Out_File, "scale.mid");
   Write_Arr (MIDI_File, MIDI_Header);
   for Note of Notes loop
      Note_On_Off (3) := Note;
      Note_On_Off (7) := Note;
      Write_Arr (MIDI_File, Note_On_Off);
   end loop;
   Write_Arr (MIDI_File, MIDI_Trailer);
   Close (MIDI_File);
end Musical_Scale;
