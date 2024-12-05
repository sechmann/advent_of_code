let string_is_empty s = s <> ""

let parse line =
  line
  |> String.split_on_char ' '
  |> List.filter string_is_empty
  |> List.map int_of_string
  |> fun l -> match l with 
  | [x; y] -> (x, y) 
  | _ -> raise (Failure "Invalid input ")

let rec count_occurrences lst =
  match lst with
  | [] -> []
  | x :: xs ->
    let rest_counts = count_occurrences xs in
    match List.assoc_opt x rest_counts with
    | Some count -> (x, count + 1) :: List.remove_assoc x rest_counts
    | None -> (x, 1) :: rest_counts

let main input debug = 
  let tuples = input |> List.map parse in
  let (left, right) = List.fold_right (fun (x, y) (acc_x, acc_y) -> (x :: acc_x, y :: acc_y)) tuples ([], []) in
  let occurrences = count_occurrences right in

  if debug then (
  occurrences |> List.iter (fun (x, count) -> Printf.printf "debug: %d: %d\n" x count);
  left |> List.iter (fun x -> (Printf.printf "debug: %d: %d\n") x (match List.assoc_opt x occurrences with | Some count -> count*x | None -> 0));
  );

  List.map2 (fun x y -> abs(x-y)) (List.sort compare left) (List.sort  compare right)
  |> List.fold_left (+) 0 |> Printf.printf "%d\n";
  left |> List.fold_left (fun acc x -> acc + (match List.assoc_opt x occurrences with | Some count -> count*x | None -> 0)) 0|> Printf.printf "%d\n"
