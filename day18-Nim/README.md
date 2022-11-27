## Day 18 - Nim

This day was a classic assembler day in AoC. The first part came down to parsing some assemby-ish instructions and then use them to operate on an array of registers/values. To make this _nice_ you have to have some way of representing a choice in a struct. Nim actually did it quite nice with using an enum as a key in a struct to then have a union based on the key. 

The second part was actually really cool and sort of simulated two concurrent programs communicating. But it was quite annoying as it changed a lot of the core things about the code, so to re-use code for both parts it became quite convoluted. It would have been much easier to just rewrite the code, but I would not really like to do that.

## Impression of Nim

I had no real idea of what to expect with Nim, but it felt a bit more modern than I expected. It felt like C, but with a more modern approach when it comes to for example memory safety, debugging and case statements. It still from what I could see has the abhorrent practice of importing all functions from a file without using the file as some sort of namespace qualifier, which was the biggest turn-off for me. It seems it has quite interetsing ideas when it comes to macros operating on the AST, but I sadly did no texperiment any with it. In a way it feels similar to a languagae I would have created, but maybe a bit too much focus on safety (although seemingly mostly optional). 

The biggest problem I had was the the documentation left a lot to be desired. For example I wanted to know how to declare object variants with different types for their fields, but the manual and examples were only when there was one type and the compiler only said my frmatting was wrong, not how to fix it. Things like that made it hader than it should have been to start learning the language.

UPDATATE: After part 2 I became very frustrated. I saw it as a good possibility to try out concurrency, but it became a nightmare. Normal vars could not be shared between threads due to safety (I had them behind a lock, but the program did not know/have a guaratee for that) so it did not work without disabling safety. It was also hard to get any information about the memory consitency model, so in the end I just used channels for all shared resources (even a counter) which was ver ugly. Overall the documentation that I managed to find around concurrency was very bare bones and hard to use.

Overall I think it is a rather neat language, and I would probably have had a better time if I had had a more structured introduction to it. I did not find much good documentation or tutorials, but maybe it does exist somewhere. However, I would not use Nim on a future project unlss a team member was very proficient in it, or the documentation became more informative.
