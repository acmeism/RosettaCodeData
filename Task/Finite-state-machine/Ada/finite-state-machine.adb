with Ada.Text_IO;  use Ada.Text_IO;

procedure FSM is
   type State is (Ready, Waiting, Dispensing, Refunding);
   Current : State := Ready;
   Input   : Character;
begin
   loop
      Put (State'Image (Current));
      case Current is
         when Ready =>
            Put (" D(eposit) or Q(uit)? ");
            Get_Immediate (Input);
            Put (Input);
            case Input is
               when 'q' | 'Q' => exit;
               when 'd' | 'D' => Current := Waiting;
               when others    => Put (" - invalid input");
            end case;
         when Waiting =>
            Put (" S(elect) or R(efund)? ");
            Get_Immediate (Input);
            Put (Input);
            case Input is
               when 's' | 'S' => Current := Dispensing;
               when 'r' | 'R' => Current := Refunding;
               when others    => Put (" - invalid input");
            end case;
         when Dispensing =>
            Put (" R(eady}? ");
            Get_Immediate (Input);
            Put (Input);
            case Input is
               when 'r' | 'R' => Current := Ready;
               when others    => Put (" - invalid input");
            end case;
         when Refunding =>
            Current := Ready;
      end case;
      New_Line;
   end loop;
end FSM;
