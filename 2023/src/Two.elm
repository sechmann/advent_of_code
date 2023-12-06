module Two exposing (..)

import Helpers exposing (split)


type Draw
    = Draw ( Int, Int, Int )


type Game
    = Game ( Int, List Draw )


mapColor : Draw -> String -> Int -> Draw
mapColor (Draw ( r, g, b )) c n =
    case String.toLower c of
        "red" ->
            Draw ( n, g, b )

        "green" ->
            Draw ( r, n, b )

        "blue" ->
            Draw ( r, g, n )

        _ ->
            Debug.log ("Attempt to map color" ++ "c " ++ " with number: " ++ String.fromInt n ++ " in cube") (Draw ( r, g, b ))


parseColor : String -> Draw -> Draw
parseColor colorAndNumber draw =
    case split " " colorAndNumber of
        [ number, color ] ->
            case String.toInt number of
                Just n ->
                    mapColor draw color n

                _ ->
                    Debug.log ("Unknown number: " ++ number) draw

        _ ->
            Debug.log ("Invalid split color/number: " ++ colorAndNumber) draw


parseDraw : String -> List Draw -> List Draw
parseDraw draw draws =
    List.foldl parseColor (Draw ( 0, 0, 0 )) (split "," draw) :: draws


parseDraws : List String -> List Draw
parseDraws draws =
    List.foldl parseDraw [] draws


parseGame : String -> Game
parseGame game =
    case split ":" game of
        [ head, tail ] ->
            case String.toInt (String.replace "Game " "" head) of
                Just n ->
                    Game ( n, parseDraws (split ";" tail) )

                _ ->
                    Debug.log "Invalid game number" (Game ( 0, [] ))

        _ ->
            Debug.log "Invalid draw" (Game ( -1, [] ))


isDrawPossible : ( Int, Int, Int ) -> Draw -> Bool
isDrawPossible ( maxRed, maxGreen, maxBlue ) (Draw ( red, green, blue )) =
    (red <= maxRed)
        && (green <= maxGreen)
        && (blue <= maxBlue)


isGamePossible : ( Int, Int, Int ) -> Game -> Bool
isGamePossible max (Game ( _, draws )) =
    List.all (isDrawPossible max) draws


findMaxCubeCount : Draw -> ( Int, Int, Int ) -> ( Int, Int, Int )
findMaxCubeCount (Draw ( r, g, b )) ( stateR, stateG, stateB ) =
    ( max r stateR
    , max g stateG
    , max b stateB
    )


parse : String -> List Game
parse input =
    input
        |> String.trim
        |> split "\n"
        |> List.map parseGame


solvePart1 : ( Int, Int, Int ) -> List Game -> Int
solvePart1 max games =
    games
        |> List.filter (isGamePossible max)
        |> List.map (\(Game ( n, _ )) -> n)
        |> List.sum


solvePart2 : List Game -> Int
solvePart2 games =
    games
        |> List.map
            (\(Game ( _, draws )) ->
                List.foldl findMaxCubeCount ( 0, 0, 0 ) draws
            )
        |> List.map (\( r, g, b ) -> [ r, g, b ])
        |> List.map List.product
        |> List.sum
