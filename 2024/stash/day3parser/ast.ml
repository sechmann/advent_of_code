type bop =
  | Mul

type expr =
  | Int of int
  | Binop of bop * expr * expr
