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

function repeat_table(programs, first)
  for i = 0, size-1 do
    if (string.char(97 + i) ~= programs[(i+first)%size]) then
      return false
    end
  end
  return true
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

function dance(first, programs, positions)
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
  
  return first, programs, positions
end

function main()
  local first = 0
  local programs = {}
  local positions = {}
  for i = 0,(size-1) do
    c = string.char(97 + i)
    programs[i] = c
    positions[c] = i
  end
    
  input = io.read("*a")
  
  
  first, programs, positions = dance(first, programs, positions)
  print_progs(programs, first)
  
  nbr_dances = 1
  while not repeat_table(programs, first) do
    -- Could cache these positions, but I don't want to write another line of Lua now  
    first, programs, positions = dance(first, programs, positions)
    nbr_dances = nbr_dances + 1
  end
  
  do_dances = 1000000000 % nbr_dances
  for i=1,do_dances do
    first, programs, positions = dance(first, programs, positions)
  end
  print_progs(programs, first)
end

main()