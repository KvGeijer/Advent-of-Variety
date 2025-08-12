package main

import "core:fmt"
import "core:os"
import "core:strings"
import "base:runtime"
import "base:intrinsics"


print3 :: proc(bits: u16) {
    fmt.printf("---\n")
    fmt.printf("%03b\n%03b\n%03b\n", bits>>6, (bits>>3)&0b111, bits&0b111)
    fmt.printf("---\n")
}

print6 :: proc(bits: u64) {
    fmt.printf("%b\n", bits)
    fmt.printf("-~-\n")
    fmt.printf("%06b\n%06b\n%06b\n%06b\n%06b\n%06b\n", bits>>30, bits>>24&0b111111, bits>18&0b111111, bits>>12&0b111111, (bits>>6)&0b111111, bits&0b111111)
    fmt.printf("-~-\n")
}

print2 :: proc(bits: u8) {
    fmt.printf("---\n")
    fmt.printf("%02b\n%02b\n", bits>>2, bits&0b11)
    fmt.printf("---\n")
}

rotate2 :: proc(p: u8) -> u8 {
    return (p&0b0001)<<1 + (p&0b0010)<<2 + (p&0b0100)>>2 + (p&0b1000)>>1
}

rotate3 :: proc(p: u16) -> u16 {
    bits : u16 = 0
    for row : u8 = 0; row < 3; row += 1 {
        for col : u8 = 0; col < 3; col += 1 {
            bit : u8 = (2-row)*3 + 2-col
            rot_bit : u8 = (2-col)*3 + row
            if p&(1<<bit) != 0 {
                bits += 1<<rot_bit
            }
        }
    }
    return bits
}

flip2 :: proc(p: u8) -> u8 {
    return p>>2 +p&0b11<<2
}

flip3 :: proc(p: u16) -> u16 {
    return p>>6 + p&0b111000 + p&0b111<<6
}

parse_pattern :: proc(p:string) -> u16 {
    bits : u16 = 0
    for ch in p {
        if ch == '/' {
            continue
        }
        bits = (bits << 1) + cast(u16)(ch=='#')
    }
    return bits
}

parse_input :: proc() -> (rules2: map[u8]u16, rules3: map[u16][4]u8) {
    data, ok := os.read_entire_file_from_handle(os.stdin, context.allocator)
    runtime.assert(ok)
    text := string(data)

    // Two separate maps to avoid ambiguity between 4-bit and 9-bit rules
    // Always use the least significant bits
    rules2 = make(map[u8]u16)
    rules3 = make(map[u16][4]u8)

    lines := strings.split_lines(text)
    for line in lines {
        if line == "" {
            continue
        }

        if len(line) == 20 {
            from := cast(u8)(parse_pattern(line[:5]))
            to := parse_pattern(line[9:])
            for i := 0; i < 4; i += 1 {
                from = rotate2(from)
                runtime.assert(from < 16)
                rules2[from] = to
                rules2[flip2(from)] = to
            }
        } else {
            from := parse_pattern(line[:11])
            to_p := parse_pattern(line[15:])
            to : [4]u8 = {u8((to_p&0b1100000000000000)>>12 + (to_p&0b0000110000000000)>>10), u8((to_p&0b0011000000000000)>>10 + (to_p&0b0000001100000000)>>8), u8((to_p&0b0000000011000000)>>4 + (to_p&0b0000000000001100)>>2), u8((to_p&0b0000000000110000)>>2 + to_p&0b0000000000000011)}
            for i := 0; i < 4; i += 1 {
                rules3[from] = to
                rules3[flip3(from)] = to
                from = rotate3(from)
            }
        }
    }
    return
}

simulate3 :: proc(bits: u16, iters: int, rules2: map[u8]u16, rules3: map[u16][4]u8) -> int {
    if iters == 0 {
        return cast(int)(intrinsics.count_ones(bits))
    }

    patterns, ok := rules3[bits]
    runtime.assert(ok)

    return simulate4(patterns, iters-1, rules2, rules3)
}

simulate4 :: proc(bits: [4]u8, iters: int, rules2: map[u8]u16, rules3: map[u16][4]u8) -> int {
    if iters <= 1 {
        ones := 0
        for p in bits {
            if iters == 1 {
                ones += cast(int) intrinsics.count_ones(rules2[p])
            } else {
                ones += cast(int) intrinsics.count_ones(p)
            }
        }
        return ones
    }

    // Convert the 4x4 (4 2x2) into a 4 3x3
    sixsix :u64
    for i :u64= 0; i < 4; i += 1 {
        row :u64= i/2
        col :u64= i%2
        offset :u64= ((1-row)*18 + (1-col)*3)
        three := u64(rules2[bits[i]])
        sixsix |= (three&0b111000000) << (offset + 6)
        sixsix |= (three&0b111000) << (offset + 3)
        sixsix |= (three&0b111) << offset
    }


    

    // Transmute the 6x6 into 9 2x2
    many_twos: [9]u8
    for row :u8= 0; row < 3; row += 1 {
        for col :u8= 0; col < 3; col += 1 {
            two_bits: u64
            shift :u8= (2-col)*2 + (2-row)*2*6
            mask := 0b11 << shift
            two_bits |= (sixsix & (0b11<<(shift+6))) >> (shift+4)
            two_bits |= (sixsix & (0b11<< shift   )) >>  shift
            many_twos[(2-row)*3 + 2-col] = u8(two_bits)
        }
    }
    
    // Convert all 9 2x2 into a 3x3 and sum the simulate3 of each 3x3 
    res := 0
    for p in many_twos {
        three, ok := rules2[p]
        runtime.assert(ok)
        res += simulate3(three, iters-2, rules2, rules3)
    }
    return res
}

main :: proc() {
    rules2, rules3 := parse_input()

    start := parse_pattern(".#./..#/###")

    count1 := simulate3(start, 5, rules2, rules3)

   
    fmt.printf("%d\n", count1)
}

