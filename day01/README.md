## Day 1 - Piet

Piet is an esoteric programming language using pixel art as code. It executes as if a pointer moves through the image and executes commands based on color and gradient differences between adjacent pixels. I recommend reading more here https://www.dangermouse.net/esoteric/piet.html if interested. All memory is a stack of ints where you can operate on the top and also circularily rotate some sub-part of the stack to change order. 

I used the npiet interpreter and the npietedit editor and found them quite nice. The editor has some drawback though. The most obvious is that it is not great at handing larger images. Some quality of life would also be nice, for example being able to select two adjacent pixels and see the corresponding command, or commenting in some way, or being able to select multiple cells and both shift their colors and gradients some step and also moving them spetially together.

Initialy I thought it would be super hard, but after a while of working with it it became quite intuitive. At least for this problem as linked lists can be quite nicely represented by the stack, especially once you learn the roll sufficiently. The biggest hardship turned out to be debugging. Writing the code was not super hard, but it is very easy to select a wrong color at some point which then fucks everything up. As it is quite hard to directly understand what a program does (compared to writing code) the debugging part ook quite a while. But npiet had a nice trace functionality which is the sole reason I could complete it in any reasonable time.

## Changing input

Here you just pipe in the input file as usual. Very nice compatability.

It could even read in numbers directly, but as we wanted to read each digit by itself I had to do a loop and subtract by 48.

## Impression of Piet

It was surprisingly fun. The movement with the DP and CC was a bit more complex than I initially thought and it made everything much more interesting. To code golf in the language feels like it could be incredibly fun and challenging. This in large part due to it being quite simple to program if you just put things on straight lines.

So overall a surprisingly fun stack based language with a very pretty but confuing way to write code. Would definetely recommend
