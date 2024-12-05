let main input debug =
  let text = String.concat "" input in
  let re = Re.compile Re.(seq [str "mul("; group(rep1(digit)); char ','; group(rep1(digit)); char ')']) in
  let matches text =
    text
    |> Re.all re
    |> List.map (fun m -> (
      Re.Group.get m 1 |> int_of_string,
      Re.Group.get m 2 |> int_of_string
    )) in

  let split_do = Re.compile Re.(str("do()")) in
  let strip = Re.compile Re.( str("don't()")) in
  let parts = Re.split split_do text in
  let stripped = List.fold_left (fun acc part ->
    acc ^ "\n\n" ^ (Re.split strip part |> List.hd)
  ) (List.hd parts |> Re.split strip |> List.hd) (List.tl parts) in

  text |> matches |> List.fold_left (fun acc (x, y) -> acc + x*y) 0 |> Printf.printf "p1: %d\n";
  stripped |> matches |> List.fold_left (fun acc (x, y) -> acc + x*y) 0 |> Printf.printf "p2: %d\n";
  if debug then (
    Printf.printf "p2: parts:\n";
    List.iter (fun part -> Printf.printf "%s\n" part) parts;
    Printf.printf "p2: parts len %d\n" (List.length parts);
    Printf.printf "p2: stripped: %s\n" stripped;
  );
