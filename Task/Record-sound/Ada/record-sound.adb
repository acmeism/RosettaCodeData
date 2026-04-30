with Sf.Audio.SoundBufferRecorder;
with Sf.Audio.SoundBuffer;
with Ada.Text_IO;

procedure Record_Sound is
   use Sf, Sf.Audio, Ada.Text_IO;
   Sound_Buffer_Recorder : constant sfSoundBufferRecorder_Ptr := SoundBufferRecorder.create;
   Sound_Buffer : sfSoundBuffer_Ptr;
begin

   if Sound_Buffer_Recorder = null then
      Put_Line (Standard_Error, "Error: sound recorder not available!");
      return;
   end if;

   -- By default the recording is in 16-bit mono. Using the
   -- setChannelCount method you can change the number of channels
   -- used by the audio capture device to record.
   if SoundBufferRecorder.start (Sound_Buffer_Recorder, sampleRate => 44_100) /= sfTrue then
      Put_Line (Standard_Error, "Error: sound recorder cannot start!");
      return;
   end if;

   delay 10.0;
   SoundBufferRecorder.stop (Sound_Buffer_Recorder);

   Sound_Buffer := SoundBufferRecorder.getBuffer (Sound_Buffer_Recorder);
   if SoundBuffer.saveToFile (Sound_Buffer, filename => "output.ogg") /= sfTrue then
      Put_Line (Standard_Error, "Error: recorded sound could not be saved!");
   end if;

   SoundBufferRecorder.destroy (Sound_Buffer_Recorder);
end Record_Sound;
