# Day 25 - Gleam

A nice day with simulating a turing machine. Throwback to when I created these by hand in highschool. The hard part was absolutely how to parse the input in a nice way in the language, while the simulation is super simple.

## Thoughts on Gleam

Gleam seems like a nice modern functional language backed by the Erlang Virtual Machine as a backend. It has a nice Rust-like syntax, with some nice syntax sugar like their "assert" and "use" statements. It also has nice pattern matching, for example on strings, but it seems limited as it could not parse out something in the middle of a string, such as `"My name is " <> name <> "!!!" = "My name is Kåre!!!"`. This significantly reduces the usefulness of the string matching to me. Its pipes could very badly use the \>> operator from Zote ("\>>" is shorthand for creating a lambda with one parameter and piping it into the following function). Quite nice documentation, but maybe missing some things.
 
