class Program

    def initialize()
        @pipes = Array.new

        @visited = false
    end

    def link(program)
        @pipes.append(program)
    end

    def follow_pipes()
        if  !@visited
            @visited = true

            connections = 1
            @pipes.each {|prog|
                connections += prog.follow_pipes()   
            }
            connections
        else
            0
        end
    end
end

class Village
    def initialize()
        @programs = Array.new

        STDIN.each_line do |line|
            splitted = line.split(" <-> ", 2)
            from_ind = splitted.at(0).to_i
            populate_program(from_ind)
            from = @programs.at(from_ind)

            splitted.at(1).split(", ", -1).each{ |to_str| 
                to_ind = to_str.to_i
                populate_program(to_ind)
                to = @programs.at(to_ind)

                to.link(from)
                from.link(to)
            }
        end
    end

    def populate_program(nbr)
        (nbr + 1 - @programs.length).times{ 
            @programs.push Program.new
        }
    end

    def nbr_linked(ind) 
        linked = @programs.at(ind).follow_pipes()
        puts "Number linked to #{ind} is #{linked}"
    end
end

village = Village.new
village.nbr_linked(0)
