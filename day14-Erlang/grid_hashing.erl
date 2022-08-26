-module(grid_hashing).
-export([main/0, setup/0]).


prettyprint_list([Head|Tail]) ->
    io:format("~s~n", [Head]), 
    prettyprint_list(Tail);
prettyprint_list([]) -> nothing.

setup() ->
    {ok, [Input]} = io:fread("", "~s"),

    Hashes = [Input ++ "-" ++ integer_to_list(I) || I <- lists:seq(0, 127)],
    prettyprint_list(Hashes).



% Recursive is not great. Should really read the whole input as one and use re with flag global...
read_hashes(Hashes) ->
    case io:get_line("") of
        eof         -> Hashes;
        Data        -> 
            case re:run(Data, "Knot hash (?P<H>.+)", [{capture, ['H'], list}]) of   % Slightly confused: https://stackoverflow.com/questions/14581872/getting-values-of-named-subpatterns-in-erlang
                {match, [Hash]}      -> read_hashes([Hash | Hashes]);
                _                    -> read_hashes(Hashes)
            end
    end.



count_ones(Board) ->
    Ones = lists:filter(fun(Char) -> Char == $1 end, lists:flatten(Board)),
    io:format("Ones ~p~n", [length(Ones)]).


advance_ind({Row, Col}, MaxSize) ->
    if
        Col <  MaxSize                          -> {Row, Col + 1};
        (Col == MaxSize) and (Row < MaxSize)    -> {Row + 1, 1};
        (Col >= MaxSize) or (Row >= MaxSize)    -> out_of_bounds
    end.

at(Board, {Row, Col}) ->
    lists:nth(Col, lists:nth(Row, Board)).

unvisited_filled(Board, Visited, Pos) ->
    (at(Board, Pos) == $1) and not sets:is_element(Pos, Visited).


find_start_cell(_, _, out_of_bounds) -> out_of_bounds;
find_start_cell(Board, Visited, Pos) ->
    case unvisited_filled(Board, Visited, Pos) of       %Feels like this could be done differently
            true -> Pos;
            false -> find_start_cell(Board, Visited, advance_ind(Pos, length(Board)))
    end.
    
fold_func(Pos, NewVisited, Board) -> 
    case unvisited_filled(Board, NewVisited, Pos) of
        true  -> connect_region(Board, NewVisited, Pos);
        false -> NewVisited
    end. 

% Could be optimized so we cant call func on a cell which is now unavailable...
connect_region(Board, OldVisited, {Row, Col}) ->

    Visited = sets:add_element({Row, Col}, OldVisited),

    Connected = lists:filter(fun ({X, Y}) -> (min(X, Y) > 0) and (max(X,Y) =< length(Board)) end, 
        [{Row-1, Col}, {Row, Col-1}, {Row+1, Col}, {Row, Col+1}]),

    lists:foldl(fun(Pos, NewVisited) -> fold_func(Pos, NewVisited, Board) end, Visited, Connected).


rec_count_regions(Board, NbrRegions, Visited, Start) -> 

    case find_start_cell(Board, Visited, Start) of
        Pos = {_Row, _Col} -> 
            NewVisited = connect_region(Board, Visited, Pos),
            rec_count_regions(Board, NbrRegions+1, NewVisited, advance_ind(Pos, length(Board)));
        out_of_bounds -> 
            NbrRegions
        end.


count_regions(Board) ->
    % The idea is to not actually do the graph coloring,
    % But instead have a running counter of regions, a set of discovered nodes,
    % and (for speed mostly) the next index which we should start looking for the next region at.

    Regions = rec_count_regions(Board, 0, sets:new(), {1,1}),

    io:format("Regions ~b~n", [Regions]).


main() ->

    Hashes = read_hashes([]),
    OrderedHashes = lists:reverse(Hashes),

    UnevenBoard = lists:map(fun(Str) -> integer_to_list(list_to_integer(Str, 16), 2) end, OrderedHashes),
    Board = lists:map(fun(List) -> [$0 || _ <- lists:seq(1, length(UnevenBoard) - length(List))] ++ List end, UnevenBoard),

    count_ones(Board),
    count_regions(Board).
