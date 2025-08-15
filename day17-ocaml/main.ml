let rec print_list_rec list =
  match list with
    | [] -> ()
    | h::t ->
        print_int h;
        print_char ' ';
        print_list_rec t

let print_list list =
  print_string "List: ";
  print_list_rec list;
  print_newline ()

let rec split_rec list el_left acc =
  if el_left == 0 then (List.rev acc, list) else
  match list with
    | [] -> (List.rev acc, [])
    | head::tail -> split_rec tail (el_left - 1) (head::acc)

let spin list steps len = 
  let actual_steps = steps mod len in
  let (first, second) = split_rec list actual_steps [] in
      List.append second first
    
let spin_insert elem list spin_steps len =
  (* 1 + spin_steps is used as we should insert the elem AFTER the previous one *)
  let spun_list = spin list (1 + spin_steps) len in
    elem::spun_list

let rec do_spin_lock list next max spin_steps =
  (*print_list list;*)
  if next > max then 
    list
  else
    do_spin_lock (spin_insert next list spin_steps next) (next + 1) max spin_steps 
  
let part1 spin_steps =
  let list = do_spin_lock [0] 1 2017 spin_steps in
  print_int (List.nth list 1);
  print_newline ()
  
let rec do_fake_spin_lock next after_zero pos len max spin_steps =
  (* Just keep track of what's after 0 and when that is updated *) 
  if next > max then after_zero else
  let next_pos = (pos + spin_steps) mod len in
  if next_pos == 0 then
    do_fake_spin_lock (next + 1) next 1 (len + 1) max spin_steps
  else
    do_fake_spin_lock (next + 1) after_zero (next_pos + 1) (len + 1) max spin_steps
 

let part2 spin_steps =
  (* Can't do like part 1 due to efficiency, so sort of cheat *)
  let after_zero = do_fake_spin_lock 2 1 1 2 50000000 spin_steps in
  print_int after_zero

let () =
  let spin_steps = read_int () in
  part1 spin_steps;
  part2 spin_steps;
