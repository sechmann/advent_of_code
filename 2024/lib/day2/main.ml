let rec remove_element_at lst index =
  match lst with
  | x :: xs ->
    if index = 0 then xs
    else x :: remove_element_at xs (index - 1)
  | [] -> []

(* generate list of all permutations of a list with different element removed in each list *)
let permutations lst =
    List.init (List.length lst) (fun i -> remove_element_at lst i)

let count_true lst =
  List.fold_left (fun acc x -> if x then acc + 1 else acc) 0 lst

let parse line =
  line
  |> String.split_on_char ' '
  |> List.map int_of_string

let in_range x =
  x >= 1 && x <= 3

let inc x y = x < y && in_range(abs(x-y))
let dec x y = x > y && in_range(abs(x-y))

let rec validate op row =
  match row with
  | x :: y :: tail ->
    if op x y then validate op (y :: tail)
    else false
  | _ :: [] -> true
  | [] -> true

let validate_p1 row =
  validate inc row || validate dec row

let validate_p2 row =
  row :: permutations row
    |> List.map validate_p1
    |> List.filter (fun x -> x)
    |> List.length > 0

let main input debug =
  let parsed = input |> List.map parse in

  if debug then (
    List.iter (fun numbers -> List.iter (fun x -> Printf.printf "%d " x) numbers) parsed;
    
    let valid = parsed |> List.map validate_p1 in
    let valid_p2 = parsed |> List.map validate_p2 in

    valid |> List.iter (fun x -> Printf.printf "p1: %b\n" x);
    Printf.printf "\n";
    valid_p2 |> List.iter (fun x -> Printf.printf "p2: %b\n" x);
    Printf.printf "\n";

    valid |> count_true |> Printf.printf "p1: example valid: %d\n";
    valid_p2 |> count_true |> Printf.printf "p2: example valid: %d\n";
  ) else (
    parsed |> List.map validate_p1 |> count_true |> Printf.printf "p1: input valid: %d\n";
    parsed |> List.map validate_p2 |> count_true |> Printf.printf "p2: input valid: %d\n";
  )
