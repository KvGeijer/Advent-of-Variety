## Day 14 - Erlang (and some Js)

I initially htought this could be a good day for the functional programming and concurrency of Erlang, but I had misunderstood the description and thought I would do computations which could be parallelised. Instead I now do everything sequentially and it turns out the meat of the algorithms is graph coloring, which I could not parallelise. I did however find a quite good way to solve it with adding visited nodes to a dict instead of mutating the board.

The problem required reusing the code from day 10 which was in JavaScript. The way this was solved here was to do all new parts in Erlang, and pipe things pack and forth between Erlang and Js in the run.sh script. This could maybe be improved by having different processes and sockets in Erlang.

## Impressions of Erlang

The parts of Erlang I dislike is the strange syntax at times as well as the really bad error messages. For a solution like this one Erlang mostly feels like a more clunky Haskell. But where Erlang would actually shine would be in a setting which could utilize its specialization in message passing systems with servers or event handlers.