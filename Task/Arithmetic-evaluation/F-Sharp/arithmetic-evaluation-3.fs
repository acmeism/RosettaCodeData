%{
open AbstractSyntaxTree
%}

%start Expr

// terminal tokens
%token <int> INT
%token PLUS MINUS TIMES DIVIDE LPAREN RPAREN
%token EOF

// associativity and precedences
%left PLUS MINUS
%left TIMES DIVIDE

// return type of Expr
%type <Expression> Expr

%%

Expr: INT                     { Int $1 }
    | Expr PLUS Expr          { Plus ($1, $3) }
    | Expr MINUS Expr         { Minus ($1, $3) }
    | Expr TIMES Expr         { Times ($1, $3) }
    | Expr DIVIDE Expr        { Divide ($1, $3) }
    | LPAREN Expr RPAREN      { $2 }
