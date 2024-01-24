app "AoC"
    packages {
        pf: "https://github.com/roc-lang/basic-cli/releases/download/0.7.0/bkGby8jb0tmZYsy2hg1E_B2QrCgcSTxdUlHtETwm5m4.tar.br",
    }
    imports [pf.Stdout, pf.Task.{Task}, "input" as input : Str]
    provides [main] to pf

main : Task {} *
main = Str.concat part1 "\n" 
    |> Str.concat part2
    |> Stdout.line

part1 =
    input
    |> Str.trim
    |> parse
    |> maxAcc
    |> Num.toStr

part2 =
    input
    |> Str.trim
    |> parse
    |> simulate 100
    |> List.len
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

simulate : (List Atom), Nat -> List Atom
simulate = \atoms, iters ->
    if iters == 0 then 
        atoms
    else
        updatedAtoms = List.map atoms atomStep
        simulate (filterAtoms updatedAtoms) (iters - 1)

atomStep : Atom -> Atom
atomStep = \{p, v, a} ->
    vN = List.map2 v a \x, y -> x + y
    pN = List.map2 vN p \x, y -> x + y
    {p: pN, v: vN, a: a}

filterAtoms : List Atom -> List Atom
filterAtoms = \atoms -> 
    counts = List.walk 
        atoms 
        (Dict.empty {})
        \dict, {p, v: _, a: _} -> Dict.insert dict p (1 + ((Dict.get dict p) |> Result.withDefault 0))
    List.dropIf 
        atoms
        \{p, v: _, a: _} -> (Dict.get counts p |> Result.withDefault 666) > 1
