program Visualize_a_tree;

{$APPTYPE CONSOLE}

uses
  System.SysUtils;

type
  TNode = record
    _label: string;
    children: TArray<Integer>;
  end;

  TTree = TArray<TNode>;

  TTreeHelper = record helper for TTree
    procedure AddNode(lb: string; chl: TArray<Integer> = []);
  end;

procedure Vis(t: TTree);

  procedure f(n: Integer; pre: string);
  begin
    var ch := t[n].children;
    if Length(ch) = 0 then
    begin
      Writeln('-', t[n]._label);
      exit;
    end;

    writeln('+', t[n]._label);
    var last := Length(ch) - 1;
    for var c in copy(ch, 0, last) do
    begin
      write(pre, '+-');
      f(c, pre + '¦ ');
    end;
    write(pre, '+-');
    f(ch[last], pre + '  ');
  end;

begin
  if Length(t) = 0 then
  begin
    writeln('<empty>');
    exit;
  end;

  f(0, '');
end;

{ TTreeHelper }

procedure TTreeHelper.AddNode(lb: string; chl: TArray<Integer> = []);
begin
  SetLength(self, Length(self) + 1);
  with self[High(self)] do
  begin
    _label := lb;
    if Length(chl) > 0 then
      children := copy(chl, 0, length(chl));
  end;
end;

var
  Tree: TTree;

begin
  Tree.AddNode('root', [1, 2, 3]);
  Tree.AddNode('ei', [4, 5]);
  Tree.AddNode('bee');
  Tree.AddNode('si');
  Tree.AddNode('dee');
  Tree.AddNode('y', [6]);
  Tree.AddNode('eff');

  Vis(Tree);

  {$IFNDEF UNIX} readln; {$ENDIF}
end.
