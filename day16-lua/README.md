## Day 16 - Lua

Initially I was going to do this in TypeScript, but when I discovered how much overlap it actually had with JavaScript I decided against it and switched to Lua. The day looked quite easy and I thought it would be quite simple in basically any imperative language, so I chose Lua. 

Overall I am quite happy with my idea for the first part. Maybe it was actually not that hard, but it felt like a nice solution to keep the indexes and programs in different arrays, to make every operation constant in time. I had a problem for a few hours, but it turn out it had to do with how I split a string around / in Lua...

Part 2 felt very tricky when I saw it. I felt like there _had_ to exist some really smart and concise way to represent it as two linear mapping in programs and indexes overlaid. I did get that to work in theory, but I could not easily extract the 1 map into a billion ones with some multiplication, instead it would be around 30-40 operations per loop, which is way too much. Samuel though of the good idea to find maps for 1 dance, then 2 dances, 4, 8, and so on which would ave worked, and is more general than the used one. But I tested this before doing that one, and it worked. In general i am a bit unhappy that there did not seem to exist a really smart solution with constant time wrt number of dances > 1.

## Impressions of Lua

I have very mixed feeling about Lua, and as with the other languages I probably did not give it enough time to properly judge it. But in general it felt a bit too basic for me. The idea with seeminly everything beeing a dictionary was neat, at least for a scripting language like this without need for performance. The work part for me was how it operated on strings, which caused me a lot of head aches as I had an annoying bug. But oh well. I guess it was ok.