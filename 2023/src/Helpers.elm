module Helpers exposing (..)


split : String -> String -> List String
split sep str =
    str
        |> String.trim
        |> String.split sep
        |> List.map String.trim
