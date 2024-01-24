# Day 20 - Roc

This was a rather nice language, and it validated my design choice of pipes in Zote. However, they did not implement \>>, and in most of ther eg dict functions the dict was the first arg, not the data (which sort of makes sense due to functional style, but still).

The main drawback however was that it is far from a mature language. Surprisingly, I got several internal panics during compilation as I had make some syntax mistake. This is really inexcusable, especially when it does not even show you where in the code the parsing failed. Also, the compiler complained about unused variables in some pattern matches in function defs like \{p, v, a} -> ... when I did not use v or a, suggesting I change them to _v and _a, but that would not work as then the pattern would not match (they have to be v: _, a: _, which is more wordy and not understood from compiler).

Overall seemingly nice functional language, hindered by buggy/implementation. When it is mature it seems to be a language crafted with a lot of love.
