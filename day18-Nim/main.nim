import threadpool, std/[strutils, sequtils, parseutils, locks]

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
        of snd: 
            op: Operand
        of rcv:
            reg: char
        of jgz: 
            cond, jump: Operand
        of set, add, mul, modu: 
            left: char
            right: Operand

var
    # Had to do last minute changes, so now I just use horrible global variables
    # Also use channels instead of variables due to bad documentation and frustration
    mailboxOne, mailboxTwo, sleepbox: Channel[int]
    globalLock: Lock
    globalCond: Cond
    
    
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
        of "rcv": result = Instruction(kind: rcv, reg: words[1][0])
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
          
proc send(val: int, duetNumber: int, registers: var seq[int]) =
    globalLock.acquire()
    if duetNumber == 1:
        mailboxTwo.send(val)
    elif duetNumber == 2:
        mailboxOne.send(val)
    globalCond.broadcast()
    globalLock.release()
    
proc receive(reg: char, duetNumber: int, registers: var seq[int]): bool =
    result = true

    globalLock.acquire()
    while true:
        if duetNumber == 1:
            let tried = mailboxOne.tryRecv()
            if tried.dataAvailable:
                registers[reg.index] = tried.msg
                break      
        elif duetNumber == 2:
            let tried = mailboxTwo.tryRecv()
            if tried.dataAvailable:
                registers[reg.index] = tried.msg
                break      
        
        if sleepbox.peek() > 0 and mailboxOne.peek() == mailboxTwo.peek():
            # Deadlock! So exit and break
            sleepbox.send(1)
            globalCond.broadcast()
            result = false
            break
        else:
            # Must wait for a message
            sleepbox.send(1)
            globalCond.wait(globalLock)
            discard sleepbox.recv()
            
    globalLock.release()

# Should indent to shorten line... Became quite a clusterfuck when mixing part 1 and 2...
proc exec(instr: Instruction, duetNumber: int, registers: var seq[int], lastSound: var int, nbrSent: var int): int = 
    result = 1
    case instr.kind:
    of snd:
        if duetNumber == 0:
            lastSound = instr.op.eval(registers)        
        else:
            instr.op.eval(registers).send(duetNumber, registers)
            nbrSent += 1
    of rcv:
        if duetNumber == 0:
            if registers[instr.reg.index] != 0:
                echo "Recovering sound: ", lastSound
                result = 100000    # Ugly way to jump outside the main loop so we can continue with part 2
        elif not receive(instr.reg, duetNumber, registers):
            result = 100000
    of set:
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
                                                                  
proc simulate(instructions: seq[Instruction], duetNumber: int) =
    var 
        pos, nbrSent, lastSound: int
        registers: seq[int] = newSeq[int](25)

    # For part 2, use duetNumber 1 and 2
    if duetNumber != 0:
        registers['p'.index] = duetNumber - 1

    while pos >= 0 and pos < instructions.len:
        pos += exec(instructions[pos], duetNumber, registers, lastSound, nbrSent)
    
    if duetNumber == 2:
        echo "Messages sent by process 1: ", nbrSent
        
        
proc part1(instructions: seq[Instruction]) =
    simulate(instructions, 0)

proc part2(instructions: seq[Instruction]) =
    initLock(globalLock)
    initCond(globalCond)
    
    mailboxOne.open()
    mailboxTwo.open()
    sleepbox.open()
        
    spawn simulate(instructions, 1)
    spawn simulate(instructions, 2)    
    sync()

proc main() =
    let instructions = parse()
    part1(instructions)
    part2(instructions)

main()