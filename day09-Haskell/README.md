## Day 9 - Haskell with Parsec

This day was just about parsing a recursive structure with some minor tricks. I had already used Haskell a bit and heard of Parsec which was supposed to be a powerful library for parsing things. So it seemed like a good match and I allowed it since I don't know anything about Parsec.

## Impressions of Parsec

Overall Parsec was very nice. The base idea of it is very simple and reminded me of the parser I wrote in Haskell during my course in uni. It treats parsing as many small functions, which can be combined to form a sort of recursive descent parser with lookahead opportunities. At least that was the way I managed to use it. The tricky part for me was getting started with it as I did not find any great introductions to it online. Some of the ones out there were very outdated and used a legacy version of the package (very similar, but different names for data types).
