-- Bacon cipher
with Ada.Text_IO;             use Ada.Text_IO;
with Ada.Strings.Unbounded;   use Ada.Strings.Unbounded;
with Ada.Characters.Handling; use Ada.Characters.Handling;
with Ada.Strings.Fixed;       use Ada.Strings.Fixed;
with Ada.Containers.Ordered_Maps;

procedure Main is
   subtype encode_str is String (1 .. 5);
   subtype lower_case is Character range 'a' .. 'z';
   subtype Upper_case is Character range 'A' .. 'Z';
   package Alphabet is new Ada.Containers.Ordered_Maps
     (Key_Type => Character, Element_Type => encode_str);
   use Alphabet;

   blank : constant Character := ' ';

   Bacon : Map;

   function encode (Plain_Text : String; Message : String) return String is
      plain_lower : String := To_Lower (Plain_Text);
      temp        : Unbounded_String;
      msg_lower   : String := To_Lower (Message);
      str         : encode_str;

   begin
      for c of plain_lower loop
         if c in lower_case then
            str := Bacon.Element (c);
         else
            str := Bacon.Element (blank);
         end if;
         Append (Source => temp, New_Item => str);
      end loop;

      declare
         encoded : String   := To_String (temp);
         Count   : Positive := encoded'First;
         result  : Unbounded_String;
      begin
         for c of msg_lower loop
            exit when Count > encoded'last;
            if c in lower_case then
               if encoded (Count) = 'A' then
                  Append (Source => result, New_Item => c);
               else
                  Append (Source => result, New_Item => To_Upper (c));
               end if;
               Count := Count + 1;
            else
               Append (Source => result, New_Item => c);
            end if;
         end loop;
         return To_String (result);
      end;
   end encode;

   function Index (Item : Map; Pattern : encode_str) return Character is
      result : Character := ' ';
      value  : encode_str;
   begin
      for key in lower_case loop
         value := Item.Element (key);
         if value = Pattern then
            result := key;
            exit;
         end if;
      end loop;
      return result;
   end Index;

   function decode (Message : String) return String is
      encoded : Unbounded_String;
   begin
      for c of Message loop
         if c in lower_case then
            Append (Source => encoded, New_Item => 'A');
         elsif c in Upper_case then
            Append (Source => encoded, New_Item => 'B');
         end if;
      end loop;

      declare
         encoded_string : String   := To_String (encoded);
         idx            : Positive := encoded_string'First;
         Result         : Unbounded_String;
         c              : Character;
         str            : encode_str;

      begin
         loop
            str := encoded_string (idx .. idx + 4);
            c   := Index (Item => Bacon, Pattern => str);
            Append (Source => Result, New_Item => c);
            idx := idx + 5;
            exit when idx + 4 > encoded_string'Last;
         end loop;
         return To_String (Result);
      end;
   end decode;

   P_Text : String := "the quick brown fox jumps over the lazy dog";
   P_Msg  : String :=
     "bacon's cipher is a method of steganography created by francis bacon. " &
     "this task is to implement a program for encryption and decryption of " &
     "plaintext using the simple alphabet of the baconian cipher or some " &
     "other kind of representation of this alphabet (make anything signify anything). " &
     "the baconian alphabet may optionally be extended to encode all lower " &
     "case characters individually and/or adding a few punctuation characters " &
     "such as the space.";

begin
   Bacon.Insert (Key => 'a', New_Item => "AAAAA");
   Bacon.Insert (Key => 'b', New_Item => "AAAAB");
   Bacon.Insert (Key => 'c', New_Item => "AAABA");
   Bacon.Insert (Key => 'd', New_Item => "AAABB");
   Bacon.Insert (Key => 'e', New_Item => "AABAA");
   Bacon.Insert (Key => 'f', New_Item => "AABAB");
   Bacon.Insert (Key => 'g', New_Item => "AABBA");
   Bacon.Insert (Key => 'h', New_Item => "AABBB");
   Bacon.Insert (Key => 'i', New_Item => "ABAAA");
   Bacon.Insert (Key => 'j', New_Item => "ABAAB");
   Bacon.Insert (Key => 'k', New_Item => "ABABA");
   Bacon.Insert (Key => 'l', New_Item => "ABABB");
   Bacon.Insert (Key => 'm', New_Item => "ABBAA");
   Bacon.Insert (Key => 'n', New_Item => "ABBAB");
   Bacon.Insert (Key => 'o', New_Item => "ABBBA");
   Bacon.Insert (Key => 'p', New_Item => "ABBBB");
   Bacon.Insert (Key => 'q', New_Item => "BAAAA");
   Bacon.Insert (Key => 'r', New_Item => "BAAAB");
   Bacon.Insert (Key => 's', New_Item => "BAABA");
   Bacon.Insert (Key => 't', New_Item => "BAABB");
   Bacon.Insert (Key => 'u', New_Item => "BABAA");
   Bacon.Insert (Key => 'v', New_Item => "BABAB");
   Bacon.Insert (Key => 'w', New_Item => "BABBA");
   Bacon.Insert (Key => 'x', New_Item => "BABBB");
   Bacon.Insert (Key => 'y', New_Item => "BBAAA");
   Bacon.Insert (Key => 'z', New_Item => "BBAAB");
   Bacon.Insert (Key => blank, New_Item => "BBBAA");

   declare
      ciphertext : String := encode (Plain_Text => P_Text, Message => P_Msg);
   begin
      Put_Line ("Cipher text:");
      Put_Line (ciphertext);
      New_Line;
      Put_Line ("Hidden text:");
      Put_Line (decode (ciphertext));
   end;
end Main;
