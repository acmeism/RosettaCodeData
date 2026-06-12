program Finite_state_machine;

{$APPTYPE CONSOLE}

type
  TState = (stReady, stWaiting, stDispense, stRefunding, stExit);

var
  state: TState = stReady;

procedure fsm();
var
  line: string;
  option: char;
begin
  Writeln('Please enter your option when prompted');
  Writeln('(any characters after the first will be ignored)'#10);
  state := stReady;
  repeat
    case state of
      stReady:
        begin
          Writeln('(D)ispense or (Q)uit : ');
          Readln(line);
          if line = '' then
            Continue;
          option := UpCase(line[1]);
          case option of
            'D':
              state := stWaiting;
            'Q':
              state := stExit;
          end;
        end;
      stWaiting:
        begin
          Writeln('OK, put your money in the slot');
          while state = stWaiting do
          begin
            Writeln('(S)elect product or choose a (R)efund : ');
            Readln(line);
            if line = '' then
              Continue;
            option := UpCase(line[1]);
            case option of
              'S':
                state := stDispense;
              'R':
                state := stRefunding;
            end;
          end;
        end;

      stDispense:
        begin
          while state = stDispense do
          begin
            Writeln('(R)emove product : '#10);
            Readln(line);
            if line = '' then
              Continue;
            option := UpCase(line[1]);
            case option of
              'R':
                state := stReady;
            end;
          end;
        end;
      stRefunding:
        begin
          Writeln('OK, refunding your money');
          state := stReady;
        end;
      stExit:
        begin
          Writeln('OK, quitting');
          state := stExit;
        end;
    end;
  until state = stExit;
end;

begin
  fsm;
end.
