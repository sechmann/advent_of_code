%{
open Ast
%}

%token <int> INT
%token MUL
%token LPAREN
%token RPAREN
%token EOF

%start <Ast.expr> prog

%%

prog:
  | e = expr; EOF { e }
  ;

expr:
  | i = INT { Int i }
  | e1 = expr; MUL; e2 = expr { Binop (Mul, e1, e2) }
  | LPAREN; e=expr; RPAREN {e}
  ;
