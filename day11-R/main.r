# Returns the Manhattan distance from the origin hex
get_distance <- function(north, north_east) {
    max(abs(north + north_east), abs(north), abs(north_east))
}

input <- array(read.table(file("stdin"), sep=",", header=FALSE))
max_dist = north_east = north = 0

for (instr in input) {
    if (instr == "ne") {
        north_east = north_east + 1
    }
    else if (instr == "n") {
        north = north + 1
    }
    else if (instr == "nw") {
        north = north + 1
        north_east = north_east - 1
    }
    else if (instr == "sw") {
        north_east = north_east - 1
    }
    else if (instr == "s") {
        north = north - 1
    }
    else if (instr == "se") {
        north = north - 1
        north_east = north_east + 1
    }
    current_dist = get_distance(north, north_east)
    max_dist = max(max_dist, current_dist)
}

sprintf("Final distance: %d", get_distance(north, north_east))
sprintf("Maximum distance: %d", max_dist)