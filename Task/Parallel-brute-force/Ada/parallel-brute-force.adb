with Ada.Text_IO;

with CryptAda.Digests.Message_Digests.SHA_256;
with CryptAda.Digests.Hashes;
with CryptAda.Pragmatics;

procedure Brute_Force is
   use CryptAda.Digests.Message_Digests;
   use CryptAda.Digests.Hashes;
   use CryptAda.Digests;
   use CryptAda.Pragmatics;

   Wanted_Sums : constant array (1 .. 3) of String (1 .. 64) :=
     (1 => "1115dd800feaacefdf481f1f9070374a2a81e27880f187396db67958b207cbad",
      2 => "3a7bd3e2360a3d29eea436fcfb7e44c735d117c42d1c1835420b6b9942dd4f1b",
      3 => "74e1bb62f8dabb8125a58852b63bdf6eaef667cb56ac7f7cdba6d7305c50a22f");
   Wanted_Hash : constant array (1 .. 3) of Hashes.Hash :=
     (1 => Hashes.To_Hash (Wanted_Sums (1)),
      2 => Hashes.To_Hash (Wanted_Sums (2)),
      3 => Hashes.To_Hash (Wanted_Sums (3)));

   subtype Ciffer is Byte range Character'Pos ('a') .. Character'Pos ('z');
   subtype Code   is Byte_Array (1 .. 5);

   task type Worker (First : Byte) is
   end Worker;

   procedure Compare (Hash : in Hashes.Hash; Bytes : in Code) is
   begin
      for I in Wanted_Hash'Range loop
         if Hash = Wanted_Hash (I) then
            Ada.Text_IO.Put (Wanted_Sums (I) & "  ");
            for C of Bytes loop
               Ada.Text_IO.Put (Character'Val (C));
            end loop;
            Ada.Text_IO.New_Line;
         end if;
      end loop;
   end Compare;

   task body Worker is
      Handle : constant Message_Digest_Handle := SHA_256.Get_Message_Digest_Handle;
      Digest : constant Message_Digest_Ptr    := Get_Message_Digest_Ptr (Handle);
      Bytes  : Code;
      Hash   : Hashes.Hash;
   begin
      Bytes (Bytes'First) := First;

      for B2 in Ciffer'Range loop
         for B3 in Ciffer'Range loop
            for B4 in Ciffer'Range loop
               Bytes (2 .. 4) := B2 & B3 & B4;
               for B5 in Ciffer'Range loop
                  Bytes (5) := B5;
                  Digest_Start  (Digest);
                  Digest_Update (Digest, Bytes);
                  Digest_End    (Digest, Hash);
                  Compare (Hash, Bytes);
               end loop;
            end loop;
         end loop;
      end loop;
   end Worker;

   type Worker_Access is access Worker;
   Work : Worker_Access;
   pragma Unreferenced (Work);
begin
   for C in Ciffer'Range loop
      Work := new Worker (First => C);
   end loop;
end Brute_Force;
