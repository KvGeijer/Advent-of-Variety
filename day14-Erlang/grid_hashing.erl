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
        % {error, _}  -> t();   % Should maybe handle this better
        eof         -> Hashes;
        Data        -> 
            case re:run(Data, "Knot hash (?P<H>.+)", [{capture, ['H'], list}]) of   % Slightly confused: https://stackoverflow.com/questions/14581872/getting-values-of-named-subpatterns-in-erlang
                {match, [Hash]}      -> read_hashes([Hash | Hashes]);
                %{match, Captured}   -> read_hashes([Captured | Hashes]);
                %nomatch             -> read_hashes(Hashes)
                _                    -> read_hashes(Hashes)
            end
    end.

count_ones(Board) ->
    Ones = lists:filter(fun(Char) -> Char == $1 end, lists:flatten(Board)),
    io:format("Ones ~p~n", [length(Ones)]).
    

main() ->

    Hashes = read_hashes([]),
    OrderedHashes = lists:reverse(Hashes),

    Board = lists:map(fun(Str) -> integer_to_list(list_to_integer(Str, 16), 2) end, OrderedHashes),

    count_ones(Board).
