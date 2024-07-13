with Ada.Text_IO;    use Ada.Text_IO;
with Sf.Audio.Music; use Sf, Sf.Audio, Sf.Audio.Music;

procedure Play is
   Sound1    : sfMusic_Ptr;
   Sound2    : sfMusic_Ptr;
begin
   Sound1 := createFromFile ("sound1.ogg");
   Sound2 := createFromFile ("sound2.ogg");
   if Sound1 = null or Sound2 = null then
      Put_Line (Standard_Error, "Error: Sound files not found!");
      return;
   end if;

   -- Looping for both sounds
   setLoop (Sound1, sfTrue);
   setLoop (Sound2, sfTrue);

   -- Setting the volume of each sound
   setVolume (Sound1, 100.0);
   setVolume (Sound2, 75.0);

   Put_Line ("Playing Sound1 individually... ");
   play (Sound1);
   delay 5.0;

   Put_Line ("Playing Sound1 and Sound2 simultaneously... ");
   play (Sound2);
   delay 10.0;

   Put_Line ("Stopping Sound1 before the end...");
   stop (Sound1);

   Put_Line ("Playing Sound2 alone for 5 seconds...");
   delay 5.0;

   destroy (Sound1);
   destroy (Sound2);
end Play;
