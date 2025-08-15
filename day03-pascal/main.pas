
program SpiralDistances;
uses math;


type 
Coords = record
   layer: cardinal;
   offset: cardinal;
end;


function coord(pos: cardinal):Coords;
var 
    layer: cardinal;
    final: cardinal;
    length: cardinal;
    base: cardinal;

begin
    { Aha! Just view it as the area of the box! }
    layer := ceil((sqrt(pos) - 1)/2);
    
    length := 2*layer + 1;
    final := length*length; {should use power, but returns float}
    
    base := final + layer;
    coord.offset := layer - abs(layer - ((base - pos) mod (2*layer)));
    coord.layer := layer;

end;


procedure part1(pos: cardinal);
{ Here we can find a nice analytical solution }
var
    res: Coords;

begin 
    res := coord(pos);

    writeln('The manhattan distance is ', res.offset + res.layer);

end;


function disc_sin(dir: cardinal): integer;
{ This is basically a discrete sinus wave scaling input by pi/2.
  It is used to easily take a step in row and col in part 2.

  Sin: 0, 1, 0, -1 ...
  Row dirs: 0, 1, 0, -1 ...
  Col dirs: 1, 0, -1, 0 ... }

begin
    
    case (dir mod 4) of 
        0, 2: disc_sin := 0;
        1: disc_sin := 1;
        3: disc_sin := -1;
    end;

end;


procedure part2(cutoff:cardinal);
var
    max_layers: cardinal;
    spiral: array of array of cardinal;
    val: cardinal;
    row, col, i, j: cardinal;
    step, steps, dir: cardinal;
begin

    { As I use a matrix to represent the spiral I need to know a bound on the size.
      As it doubles in every corner we can take the 8-logarithm as a modest bound for layers. }
    max_layers := ceil(logn(8, cutoff));

    { Initialize two-dimensional array }
    setLength(spiral, max_layers*2 + 1);
    for row := 0 to high(spiral) do
    begin
        setLength(spiral[row], max_layers*2 + 1);
        for col := 0 to high(spiral[row]) do
            spiral[row][col] := 0;
    end;

    { Initialize }
    row := max_layers;
    col := max_layers;
    val := 1;
    spiral[row][col] := val;

    steps := 2;
    step := 0;
    dir := 0;

    { Traverse the spiral and just fill in the numbers }
    while val < cutoff do
    begin
        { Find new position }
        row := row + disc_sin(dir);
        col := col + disc_sin(dir + 1);

        { Possibly change direction }
        inc(step);
        if (step = (steps div 2)) then
        begin
            step := 0;
            inc(steps);
            inc(dir);
        end;

        { Calculate the value, use the fact that the spiral is initialized to 0 }
        val := 0;
        for i := 0 to 2 do
            for j := 0 to 2 do
                val := val + spiral[row + i - 1][col + j - 1];
        
        spiral[row][col] := val;

    end;
    
    writeln('The first value which is larger is: ', val);

end;


var 
    input: cardinal;
begin 
    read (input);
    part1(input);
    part2(input);
end.
