type direction =
  | Up
  | Down
  | Left
  | Right
  | UpLeft
  | UpRight
  | DownLeft
  | DownRight

let next_x_y x y direction =
  match direction with
  | Up -> (x, y - 1)
  | Down -> (x, y + 1)
  | Left -> (x - 1, y)
  | Right -> (x + 1, y)
  | UpLeft -> (x - 1, y - 1)
  | UpRight -> (x + 1, y - 1)
  | DownLeft -> (x - 1, y + 1)
  | DownRight -> (x + 1, y + 1)

let all_directions =
  [ Up; Down; Left; Right; UpLeft; UpRight; DownLeft; DownRight ]

let p1_expected = "SAMX"

let rec check_direction x y matrix ttl direction =
  if y < 0 || y >= Array.length matrix then false
  else if x < 0 || x >= String.length matrix.(y) then false
  else if ttl == -1 then false
  else if matrix.(y).[x] == p1_expected.[ttl] then
    let x, y = next_x_y x y direction in
    if ttl == 0 then true else check_direction x y matrix (ttl - 1) direction
  else false

let rec walk x y matrix =
  if y >= Array.length matrix then 0
  else if x >= String.length matrix.(0) then walk 0 (y + 1) matrix
  else
    let matches =
      all_directions
      |> List.fold_left
           (fun acc direction ->
             if
               check_direction x y matrix
                 (String.length p1_expected - 1)
                 direction
             then acc + 1
             else acc)
           0
    in
    matches + walk (x + 1) y matrix

let check_p2 matrix x y direction c =
  let x, y = next_x_y x y direction in
  matrix.(y).[x] == c

let rec walk_p2 x y matrix =
  if y + 1 >= Array.length matrix then 0
  else if x + 1 >= String.length matrix.(y) then walk_p2 1 (y + 1) matrix
  else if
    matrix.(y).[x] = 'A'
    &&
    let check = check_p2 matrix x y in
    ((check UpLeft 'M' && check DownRight 'S')
    || (check UpLeft 'S' && check DownRight 'M'))
    && ((check UpRight 'M' && check DownLeft 'S')
       || (check UpRight 'S' && check DownLeft 'M'))
  then 1 + walk_p2 (x + 1) y matrix
  else walk_p2 (x + 1) y matrix

let main input _ =
  let input = Array.of_list input in
  walk 0 0 input |> Printf.printf "p1: %d\n";
  walk_p2 1 1 input |> Printf.printf "p2: %d\n"
