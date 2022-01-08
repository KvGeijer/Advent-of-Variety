
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
var
    res: Coords;

begin 
    res := coord(pos);

    writeln('The manhattan distance is ', res.offset + res.layer);

end;


var 
    input: cardinal;
begin 
    read (input);
    part1(input);
end.
