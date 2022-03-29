% The idea is to just pick one random program and then follow the path up to find the one carrying it not being carried
carries(fwft, ktlj).
carries(fwft, cntj).
carries(fwft, xhth).

carries(padx, pbga).
carries(padx, havc).
carries(padx, qoyq).

carries(tknk, ugml).
carries(tknk, padx).
carries(tknk, fwft).

carries(ugml, gyxo).
carries(ugml, ebii).
carries(ugml, jptl).

% This writes out all the carriers until it can't match no more. It really is not that nice...
bottomCarrier(X) :- (carries(Y, X)
    -> bottomCarrier(Y)
    ; format('The bottom is: ~w~n', [X])
).

result :- bottomCarrier(jptl).
