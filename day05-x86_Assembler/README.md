## Day 5 - x86 Assembler

This in a way felt like the easiest day so far. It really only required you to read ints into an array and then have a simple while loop with a position pointer. Since it did not require any special data structures it felt like an easy day to get x86 out of the way. I was quite right, the actual algorithm was easy, but reading the input and printing output was way more annoying than I had hoped for.

A fun thing was that we needed to re-use the input array in both parts, but in each we had to modify it. As we did not know the length of the array, I decided to push each item twice on the stack in sequence, so now the array contains two of each item. The first of the pair is used for part 1 and the second for part 2. Thought that was a nice and cute solution. I just saved the array on the stack, like a VLA in C.

## Impression of x86

It was basically exactly what I though, but I only used quite elementary instructions. The big trouble as mentioned above was I/O. Not surprisingly I will never write something in Assembler if I don't have to, or if I'm doing anything with a compiler. But it is very straight forward in a way to write, as long as you don't require much data structures or complex stuff.
