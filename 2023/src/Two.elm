module Two exposing (..)

import Helpers exposing (split)



-- solve :: String -> String


type Draw
    = Draw ( Int, Int, Int )


type Game
    = Game ( Int, List Draw )


mapRed : Draw -> Int -> Draw
mapRed (Draw ( _, g, b )) n =
    Draw ( n, g, b )


mapGreen : Draw -> Int -> Draw
mapGreen (Draw ( r, _, b )) n =
    Draw ( r, n, b )


mapBlue : Draw -> Int -> Draw
mapBlue (Draw ( r, g, _ )) n =
    Draw ( r, g, n )


mapColor : Draw -> String -> Int -> Draw
mapColor d c n =
    case String.toLower c of
        "red" ->
            mapRed d n

        "green" ->
            mapGreen d n

        "blue" ->
            mapBlue d n

        _ ->
            Debug.log ("Unknown color: " ++ c) d


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


valid : ( Int, Int, Int ) -> Draw -> Bool
valid ( maxRed, maxGreen, maxBlue ) (Draw ( red, green, blue )) =
    (red <= maxRed)
        && (green <= maxGreen)
        && (blue <= maxBlue)


validGame : ( Int, Int, Int ) -> Game -> Bool
validGame max (Game ( _, draws )) =
    List.all (valid max) draws


solvePart1 : ( Int, Int, Int ) -> List Game -> Int
solvePart1 max games =
    games
        |> List.filter (validGame max)
        |> List.map (\(Game ( n, _ )) -> n)
        |> List.sum


determineMinimumBag : Draw -> ( Int, Int, Int ) -> ( Int, Int, Int )
determineMinimumBag (Draw ( r, g, b )) ( stateR, stateG, stateB ) =
    ( max r stateR
    , max g stateG
    , max b stateB
    )


toList : ( Int, Int, Int ) -> List Int
toList ( r, g, b ) =
    [ r, g, b ]


solvePart2 : List Game -> Int
solvePart2 games =
    games
        |> List.map
            (\(Game ( _, draws )) ->
                List.foldl
                    determineMinimumBag
                    ( 0, 0, 0 )
                    draws
            )
        |> List.map toList
        |> List.map List.product
        |> List.sum


parse : String -> List Game
parse input =
    input
        |> String.trim
        |> split "\n"
        |> List.map parseGame
