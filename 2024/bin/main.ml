let debug = ref false
let day = ref "1"
let noexample = ref false
let noinput = ref false

let speclist =
  [
    ("--debug", Arg.Set debug, "Output debug information");
    ("--day", Arg.Set_string day, "Which day to execute");
    ("--noexample", Arg.Set noexample, "Execute example");
    ("--noinput", Arg.Set noinput, "Execute input");
  ]

let timed f input debug =
  let start_time = Unix.gettimeofday () in
  f input debug;
  let elapsed_time = Unix.gettimeofday () -. start_time in
  Printf.printf "Execution time: %.2f ms\n" (elapsed_time*.1000.)

let () =
  Arg.parse speclist (fun _ -> ()) "Usage: aoc_2024 [--debug] [--day <day>] [--noexample] [--noinput]";

  let days = [
    ("1", Aoc_2024.Day1.Main.main);
    ("2", Aoc_2024.Day2.Main.main);
    ("3", Aoc_2024.Day3.Main.main);
    ("4", Aoc_2024.Day4.Main.main);
  ] in

  let f = List.assoc !day days in
  Printf.printf "--Day %s%s--\n" !day (if !debug then " debug" else "");

  if not !noexample then
    (
      Printf.printf "Example:\n";
      let example = Aoc_2024.Io.read_lines (Printf.sprintf "lib/day%s/example" !day) in
      f example !debug;
    );

  if not !noinput then
    (
      Printf.printf "Real:\n";
      let input = Aoc_2024.Io.read_lines (Printf.sprintf "lib/day%s/input" !day) in
      timed f input !debug;
      Printf.printf "---------\n";
    );
