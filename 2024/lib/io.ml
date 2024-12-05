let read_lines file  =
  let input = open_in file in
  let rec _read_lines acc =
    try
      let line = input_line input in
      _read_lines (line::acc)
    with End_of_file ->
      close_in input;
      List.rev acc
  in
  _read_lines []
