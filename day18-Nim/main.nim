import std/[strutils, sequtils, parseutils]

type
    OpKind = enum
        reg,
        val
    Operand* = ref object
        case kind: OpKind
        of reg: reg: char
        of val: val: int 

    InstrKind = enum
        snd,
        set,
        add,
        mul,
        modu,
        rcv,
        jgz
    Instruction* = ref object
        case kind: InstrKind
        of snd, rcv: 
            op: Operand
        of jgz: 
            cond, jump: Operand
        of set, add, mul, modu: 
            left: char
            right: Operand

proc createOp(word: string): Operand =
    if word[0].isAlphaAscii:
        result = Operand(kind: reg,
                         reg: word[0])
    else:
        var num = 0 # This should not be needed
        discard word.parseInt(num)
        result = Operand(kind: val,
                         val: num)
                        
proc parseInstruction(words: seq[string]): Instruction =
    case words[0]:
        of "snd": result = Instruction(kind: snd, op: create_op(words[1]))
        of "rcv": result = Instruction(kind: rcv, op: create_op(words[1]))
        of "set": result = Instruction(kind: set, left: words[1][0], right: create_op(words[2]))
        of "add": result = Instruction(kind: add, left: words[1][0], right: create_op(words[2]))
        of "mul": result = Instruction(kind: mul, left: words[1][0], right: create_op(words[2]))
        of "mod": result = Instruction(kind: modu, left: words[1][0], right: create_op(words[2]))
        of "jgz": result = Instruction(kind: jgz, cond: create_op(words[1]), jump: create_op(words[2]))
        else: echo "What the #!%& is going on?"

proc parse(): seq[Instruction] =
    # let lines = stdin.readAll.splitLines.map(splitWhitespace)
    let lines = stdin.readAll.splitLines
    result = newSeq[Instruction](0)
    for line in lines:
        let words = line.splitWhiteSpace
        let instr = parseInstruction(words)
        result.add(instr)

proc index(reg: char): int =
    reg.int - 'a'.int 
    
proc eval(op: Operand, registers: var seq[int]): int =
    case op.kind:
    of val:
        result = op.val
    of reg:
        result = registers[op.reg.index]
          
proc exec(instr: Instruction, registers: var seq[int], lastSound: var int): int = 
    echo "eval ", lastSound, " ", instr.kind
    result = 1
    case instr.kind:
    of snd:
        echo "Playing sound!"
        echo instr.op.eval(registers)
        lastSound = instr.op.eval(registers)        
    of rcv:
        # Can we use a guard for this instead?
        if (instr.op.eval(registers) != 0):
            echo "Recovering sound!"
            echo lastSound
            echo registers
            quit(0)
    of set:
        #echo instr.left, " ", instr.left.index, " ", instr.right.eval(registers)
        registers[instr.left.index] = instr.right.eval(registers)
    of add:
        registers[instr.left.index] += instr.right.eval(registers)
    of mul:
        registers[instr.left.index] *= instr.right.eval(registers)
    of modu:
        registers[instr.left.index] = registers[instr.left.index] mod instr.right.eval(registers)
    of jgz:
        if (instr.cond.eval(registers) > 0):
            result = instr.jump.eval(registers)
                                                                  
proc simulate(instructions: seq[Instruction]) =
    var 
        pos: int
        lastSound: int = -1337
        registers: seq[int] = newSeq[int](25)
    
    while pos >= 0 and pos < instructions.len:
        echo "simul ind ", pos
        pos += exec(instructions[pos], registers, lastSound)

proc part1(instructions: seq[Instruction]) =
    simulate(instructions)
              
proc main() =
    let instructions = parse()
    part1(instructions)
    #part2(instructions)
    
main()