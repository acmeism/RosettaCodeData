type
  IExprNode = interface
    function Evaluate: real;
  end;

  NumberNode = auto class(IExprNode)
  public
    value: real;
    function Evaluate: real := value;
  end;

  BinaryOpNode = auto class(IExprNode)
  public
    op: char;
    left, right: IExprNode;

    function Evaluate: real;
    begin
      case op of
        '+': Result := left.Evaluate + right.Evaluate;
        '-': Result := left.Evaluate - right.Evaluate;
        '*': Result := left.Evaluate * right.Evaluate;
        '/': Result := left.Evaluate / right.Evaluate;
      else
        raise new Exception($'Unknown operator {op}');
      end;
    end;
  end;

  ExpressionParser = class
    s: string;
    pos: integer;

    constructor Create(input: string);
    begin
      s := input;
      pos := 1;
    end;

    function NextChar: char :=
      if pos <= s.Length then s[pos] else #0;

    procedure SkipSpaces :=
      while NextChar = ' ' do pos += 1;

    function ParseNumber: IExprNode;
    begin
      SkipSpaces;
      var start := pos;
      while NextChar.IsDigit do pos += 1;
      if NextChar = '.' then
      begin
        pos += 1;
        while NextChar.IsDigit do pos += 1;
      end;
      var value := s[start:pos].ToReal;
      Result := new NumberNode(value);
    end;

    function ParseFactor: IExprNode;
    begin
      SkipSpaces;
      if NextChar = '(' then
      begin
        pos += 1;
        Result := ParseExpr;
        SkipSpaces;
        if NextChar = ')' then
          pos += 1
        else raise new Exception('Expected )');
      end
      else
        Result := ParseNumber;
    end;

    function ParseTerm: IExprNode;
    begin
      Result := ParseFactor;
      while true do
      begin
        SkipSpaces;
        var ch := NextChar;
        if (ch = '*') or (ch = '/') then
        begin
          pos += 1;
          Result := new BinaryOpNode(ch, Result, ParseFactor);
        end
        else break;
      end;
    end;

    function ParseExpr: IExprNode;
    begin
      Result := ParseTerm;
      while true do
      begin
        SkipSpaces;
        var ch := NextChar;
        if (ch = '+') or (ch = '-') then
        begin
          pos += 1;
          Result := new BinaryOpNode(ch, Result, ParseTerm);
        end
        else break;
      end;
    end;

    function Parse: IExprNode := ParseExpr;

  end;

begin
  var inputs := [
    '2+3*(4-1)',
    '10 + 2 / 3',
    '(7+3)*(2+2)',
    '8*(5+(2-3))',
    '1/3',
    '2.5 + 4.1 * (3 - 1.1/2)'];

  foreach var expr in inputs do
  begin
    var parser := new ExpressionParser(expr);
    var tree := parser.Parse;
    Println($'{expr} = {tree.Evaluate:0.###}');
  end;
end.
