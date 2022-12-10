size = 16

-- Only split in two
function split(str, delim)
  local arr = {}
  for part in string.gmatch(str, "([^" .. delim .. "]+)") do
    table.insert(arr, part)
  end
  return arr[1], arr[2]
end

function rot_pos(pos, first)
  return (tonumber(pos) + first) % size
end

function parr(arr)
  print(table.concat(arr,", "))
end

function print_progs(programs, first)
  for i = first, size-1 do
    io.write(programs[i])
  end
  for i = 0, first-1 do
    io.write(programs[i])
  end
  io.write("\n")
  
end

function main()
  first = 0
  programs = {}
  positions = {}
  for i = 0,(size-1) do
    c = string.char(97 + i)
    programs[i] = c
    positions[c] = i
  end
    
  input = io.read("*a")
  
  for instr in string.gmatch(string.gsub(input, '%s+', ''), "([^,]+)") do
    type = string.sub(instr, 1, 1)
    if type == "s" then
      first = (first - string.sub(instr, 2)) % size
    elseif type == "x" then
      pos1, pos2 = split(string.sub(instr, 2), "/")
      pos1, pos2 = rot_pos(pos1, first), rot_pos(pos2, first)        
      prog1, prog2 = programs[pos1], programs[pos2]
      
      assert(programs[pos1] == prog1)
      assert(programs[pos2] == prog2)
      assert(positions[prog1] == pos1)
      assert(positions[prog2] == pos2)
      
      programs[pos1], programs[pos2] = programs[pos2], programs[pos1]
      positions[prog1], positions[prog2] = positions[prog2], positions[prog1]
    else
      prog1, prog2 = string.sub(instr, 2, 2), string.sub(instr, 4)
      pos1, pos2 = positions[prog1], positions[prog2]
      
      assert(programs[pos1] == prog1)
      assert(programs[pos2] == prog2)
      assert(positions[prog1] == pos1)
      assert(positions[prog2] == pos2)
      
      programs[pos1], programs[pos2] = programs[pos2], programs[pos1]
      positions[prog1], positions[prog2] = positions[prog2], positions[prog1]
    end
  end
  print_progs(programs, first)
end

main()