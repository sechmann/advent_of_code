{
open Parser
}

let white = [' ' '\t']+
let digit = ['0'-'9']
let int = '-'? digit+
let letter = ['a'-'z' 'A'-'Z']
let id = letter+
let junk = '.'

rule read =
  parse
  | white { read lexbuf }
  | "(" { LPAREN }
  | ")" { RPAREN }
  | "mul" { MUL }
  | int { INT (int_of_string (Lexing.lexeme lexbuf)) }
  | junk { read lexbuf }
  | eof { EOF }

