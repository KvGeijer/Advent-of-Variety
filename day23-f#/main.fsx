open System

type Reg = int // 'a'..'z' mapped to 0..25

type Operand =
  | Imm of int64
  | Reg of Reg

type Instr =
  | Set of Reg * Operand
  | Sub of Reg * Operand
  | Mul of Reg * Operand
  | Jnz of Operand * Operand

let regIndex (s: string) : Reg =
    int (s.[0] - 'a')

let parseOperand (s: string) =
    match Int64.TryParse s with
    | true, v -> Imm v
    | _       -> Reg (regIndex s)

let parseInstr (line: string) : Instr =
    let p = line.Split([|' '|], StringSplitOptions.RemoveEmptyEntries)
    match p.[0] with
    | "set" -> Set (regIndex p.[1], parseOperand p.[2])
    | "sub" -> Sub (regIndex p.[1], parseOperand p.[2])
    | "mul" -> Mul (regIndex p.[1], parseOperand p.[2])
    | "jnz" -> Jnz (parseOperand p.[1], parseOperand p.[2])
    | op -> failwith "failed parse"

let lines =
    seq {
        let mutable l = Console.ReadLine()
        while not (isNull l) do
            let t = l.Trim()
            if t <> "" then yield t
            l <- Console.ReadLine()
    }

let program : Instr[] = lines |> Seq.map parseInstr |> Seq.toArray

let eval (regs: int64[]) = function
    | Imm v -> v
    | Reg r -> regs.[r]

let run (a: int, prog: Instr[]) =
    let regs = Array.zeroCreate<int64> 26
    regs.[regIndex "a"] <- a

    let mutable pc = 0
    let mutable muls = 0 
    let mutable iters = 0

    while pc >= 0 && pc < prog.Length do
        iters <- iters + 1
        match prog.[pc] with
        | Set (r, op) ->
            regs.[r] <- eval regs op
            pc <- pc + 1
        | Sub (r, op) ->
            regs.[r] <- regs.[r] - eval regs op
            pc <- pc + 1
        | Mul (r, op) ->
            regs.[r] <- regs.[r] * eval regs op
            muls <- muls + 1
            pc <- pc + 1
        | Jnz (x, y) ->
            if eval regs x <> 0 then
                pc <- pc + int (eval regs y)
            else
                pc <- pc + 1
    muls, regs

let muls1, regs1 = run(0, program)
printfn "%d" muls1

// hand transpiled and optimized function. Can further optimize the inner d <> b loop, but it was not necessary
let run2(prog: Instr[]) = 
    let mutable b = 108400 - 17
    let mutable c = 125400
    let mutable d = 0
    let mutable f = 0
    let mutable h = 0
    
    while b <> c do
        b <- b + 17
        f <- 1
        d <- 2
        while d <> b do
            if b % d = 0 && b <> d then
                f <- 0
            d <- d + 1
        if f = 0 then
            h <- h + 1
    h

let h = run2(program)
printfn "%d" h
