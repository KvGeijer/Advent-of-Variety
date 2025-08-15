main :-
	solve_part1,
	solve_part2.

parse_input(Line, Name, Weight, Children) :-
    re_replace("->", ">", Line, LineFixed), % Could not get it to work, as when splitting on "->", it split on - AND >, not ->
    split_string(LineFixed, '>', " ", [Left|Rest]),
    split_string(Left, " ", "()", [NameAtomString, WeightString]),
    atom_string(Name, NameAtomString),
    number_string(Weight, WeightString),

    ( Rest = [ChildrenPartString] ->
        split_string(ChildrenPartString, ",", " ", ChildStringsTrimmed),
        maplist(string_to_atom, ChildStringsTrimmed, Children)
    ; Children = []
    ).

load_programs :-
    retractall(program(_,_,_)),  % clear old data
    open('input.in', read, In),
    read_string(In, _, FileContents),
    close(In),
    split_string(FileContents, "\n", "", Lines),
    forall(
        ( member(Line, Lines),
          string_length(Line, Len),
          Len > 0
        ),
        (
          parse_input(Line, Name, Weight, Children),
          assertz(program(Name, Weight, Children))
        )
    ).

find_root(RootName) :-
    findall(C, (program(_, _, Cs), member(C, Cs)), AllChildren),
    program(RootName, _, _),
    \+ member(RootName, AllChildren).

solve_part1 :-
    load_programs,
    find_root(Root),
    format("~w~n", [Root]).

tower_weight(Name, TotalWeight) :-
    program(Name, OwnWeight, Children),
    tower_weights(Children, ChildWeights),
    sum_list(ChildWeights, SumChildren),
    TotalWeight is OwnWeight + SumChildren.

tower_weights([], []).
tower_weights([C|Cs], [W|Ws]) :-
    tower_weight(C, W),
    tower_weights(Cs, Ws).

find_unbalanced(Node, WrongChild, CorrectWeight) :-
    program(Node, _, Children),
    maplist(tower_weight, Children, Weights),
    pairs_keys_values(Pairs, Children, Weights),
    (   balanced_or_find_outlier(Pairs, NormalWeight, OutlierChild, OutlierWeight) -> 
        (   find_unbalanced(OutlierChild, DeeperChild, DeeperWeight) ->
            WrongChild = DeeperChild,
            CorrectWeight = DeeperWeight
        ;
            Offset is NormalWeight - OutlierWeight,
            program(OutlierChild, ChildOwnWeight, _),
            CorrectWeight is ChildOwnWeight + Offset,
            WrongChild = OutlierChild
        )
    ;
        fail
    ).

balanced_or_find_outlier(Pairs, NormalWeight, OutlierChild, OutlierWeight) :-
    pairs_values(Pairs, Weights),
    msort(Weights, Sorted),
    (   all_same(Sorted)
    ->  fail
    ;
        Sorted = [First,Second|_],
        append(_, [SecondLast,Last], Sorted),

        (   First \= Second
        ->
            NormalWeight = Second,
            OutlierWeight = First
        ;
            NormalWeight = SecondLast,
            OutlierWeight = Last
        ),

        member(OutlierChild-OutlierWeight, Pairs)
    ).

all_same([]).
all_same([_]).
all_same([X, Y | Tail]) :-
    X = Y,
    all_same([Y | Tail]).

solve_part2 :-
    load_programs,
    find_root(Root),
    (   find_unbalanced(Root, _, CorrectWeight)
    ->  format("~w~n", [CorrectWeight])
    ;   write("No imbalance found - check data.\n")
    ).

