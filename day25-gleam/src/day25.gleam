import gleam/bool
import gleam/dict
import gleam/int
import gleam/io
import gleam/list
import gleam/result
import gleam/string
import gleam/yielder
import stdin

pub fn last_word(s: String) -> String {
  let assert Ok(ret) =
    s
    |> string.split(" ")
    |> list.last
    |> result.map(fn(s) { string.drop_end(s, 1) })
  ret
}

pub fn simulate(state_name, pos: Int, tape, ins, steps: Int) {
  use <- bool.guard(steps == 0, tape |> dict.size)

  let assert Ok(state): Result(#(Bool, Int, String, Bool, Int, String), Nil) =
    ins |> dict.get(state_name)

  let #(write, move, next) = case dict.has_key(tape, pos) {
    False -> #(state.0, state.1, state.2)
    True -> #(state.3, state.4, state.5)
  }

  let tape = case write {
    True -> tape |> dict.insert(pos, Nil)
    False -> tape |> dict.delete(pos)
  }

  simulate(next, pos + move, tape, ins, steps - 1)
}

pub fn main() {
  let assert [
    "Begin in state " <> l1,
    "Perform a diagnostic checksum after " <> l2,
    _,
    ..records
  ] = stdin.read_lines() |> yielder.to_list
  let start = l1 |> string.drop_end(2)
  let assert Ok(#(steps, _)) = l2 |> string.split_once(" ")

  let instructions =
    records
    |> string.concat
    |> string.split("\n\n")
    |> list.map(fn(rec) {
      let assert [l0, _, l11, l12, l13, _, l21, l22, l23, ..] =
        rec |> string.split("\n")

      #(l0 |> last_word, #(
        l11 |> last_word |> string.starts_with("1"),
        l12
          |> last_word
          |> string.starts_with("r")
          |> bool.guard(1, fn() { -1 }),
        l13 |> last_word,
        l21 |> last_word |> string.starts_with("1"),
        l22
          |> last_word
          |> string.starts_with("r")
          |> bool.guard(1, fn() { -1 }),
        l23 |> last_word,
      ))
    })
    |> dict.from_list

  simulate(
    start,
    0,
    dict.new(),
    instructions,
    steps |> int.parse |> result.unwrap(0),
  )
  |> int.to_string
  |> io.println
}
