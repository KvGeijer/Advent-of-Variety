## Day 18 - Nim

This day was a classic assembler day in AoC. It comes down to parsing some assemby-ish instructions and then use them to operate on an array of registers/values. Tho make this _nice_ you have to have some way of representing a choice in a struct. Nim actually did it quite nice with using an enum as a key in a struct to then have a union based on the key. 

## Impression of Nim

I had no real idea of what to expect with Nim, but it felt a bit more modern than I expected. It felt like C, but with a more modern approach when it comes to for example memory safety, debugging and case statements. It still from what I could see has the abhorrent practice of importing all functions from a file without using the file as some sort of namespace qualifier, which was the biggest turn-off for me. It seems it has quite interetsing ideas when it comes to macros operating on the AST, but I sadly did no texperiment any with it. In a way it feels similar to a languagae I would have created, but maybe a bi ttoo much focus on safety (although seemingly mostly optional). 

The biggest problem I had was the the documentation left a lot to be desired. For example I wanted to know how to declare object variants with different types for their fields, but the manual and examples were only when there was one type and the compiler only said my frmatting was wrong, not how to fix it. Things like that made it hader than it should have been to start learning the language.
