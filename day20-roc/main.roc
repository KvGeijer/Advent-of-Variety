app "AoC"
    packages {
        pf: "https://github.com/roc-lang/basic-cli/releases/download/0.7.0/bkGby8jb0tmZYsy2hg1E_B2QrCgcSTxdUlHtETwm5m4.tar.br",
    }
    imports [pf.Stdout, pf.Task.{Task}, "input" as input : Str]
    provides [main] to pf

main : Task {} *
main = Stdout.line part1

part1 =
    input
    |> Str.trim
    |> parse
    # |> List.map \rec -> rec.a |> List.get 2 |> Result.withDefault 666999
    # |> List.map Num.toStr 
    # |> Str.joinWith ","
    |> maxAcc
    |> Num.toStr

Atom : {p: List I64, v: List I64, a: List I64}

parse : Str -> List Atom
parse = \str ->
    str |> Str.split "\n" |> List.map parseLine

parseLine = \line ->
    segs = line |> Str.split ", "
    {
        p : parseTuple ((List.get segs 0) |> Result.withDefault ""), 
        v : parseTuple ((List.get segs 1) |> Result.withDefault ""), 
        a : parseTuple ((List.get segs 2) |> Result.withDefault "")
    }

parseTuple : Str -> List I64
parseTuple = \tuple ->
    tuple
    |> Str.graphemes
    |> List.dropFirst 3
    |> List.dropLast 1
    |> Str.joinWith ""
    |> Str.split ","
    |> List.keepOks Str.toI64

maxAcc : List Atom -> Nat
maxAcc = \recs ->
    recs
    |> List.map (\rec -> manhattan rec.a)
    |> List.walkWithIndex 
      {best: 999, bestInd: 0} 
      (\{best: b, bestInd: bi}, elem, i -> (if elem < b then {best: elem, bestInd: i} else {best: b, bestInd: bi}))
    |> .bestInd
    

manhattan : List I64 -> I64
manhattan = \nums ->
    nums
    |> List.map Num.abs
    |> List.sum
