## Day 17 - OCaml

The day was deceptively simple. The first part was really just permuting a cicrular linked list and inserting increasing elements. The second one upped the computational load, so the naïve solution could no longer be used. But it slightly changed the sought value which enabled me to use a very nice tail-recursive solution which just kept track of one number basically.

## Impressions of OCaml

Syntax wise it is quite pleasant, and it feels like a good mix between funcitonal and imperative. You don't have to outsource mutability to other languages like Erlang, and instead it is done inside certain structures of the languages. It seemed to me that functions had to be declared before use (like in C) which feels quite clunky and too script-like for my taste. However, if I wanted a modern language for pragmatic functional development this seems like a good choice. 

On a side not I must say I was a bit frustrated with the documentation. Evenrything seems to be built around the REPL, which made writng a simple cript file harder than needed. 
