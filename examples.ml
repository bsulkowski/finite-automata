open Utilities;;

let pisz_a a = write (Automate.to_word read_int a);;

let pisz_l l = pisz_a (to_automate l);;

let pisz_e e = write (Expression.to_word e);;


let minimalny a = states_to_int (minimalize (determinize a));;

let uprosc l = of_automate (minimalny (to_automate l));;

let szukaj alfabet w1 =
    let any =
        Iteration (foldr Expression.sum Empty
                        (List.map (function x -> Letter x) alfabet))
    in  
        accepts_prefix (of_expression (Concatenation (any, of_word w1)))
        
        
let e0 = Sum (Letter 'a', Letter 'b');;

let e1 = Iteration e0;;

let e2 = of_word (read "aaa");;

let e3 = Concatenation (e1, Concatenation (e2, e1));;

let e4 = Sum (e0, of_word (read "aba"));;

let e5 = Concatenation (Letter 'a', Iteration (Letter 'b'));;

let e6 = Concatenation (Iteration (Letter 'a'), Letter 'b');;

let a1 =
        Automate.create
        (Set.of_list ['0';'1'])
        (Set.of_list [0;1;2])
        (Set.of_list [0])
        (Set.of_list [0])
        (function '0' -> (function 0 -> Set.singleton 0
                                 | 1 -> Set.singleton 2
                                 | _ -> Set.singleton 1)
                | _ -> (function 0 -> Set.singleton 1
                                 | 1 -> Set.singleton 0
                                 | _ -> Set.singleton 2));;
               
let a2 =
        Automate.create
        (Set.of_list ['a';'b'])
        (Set.of_list [0;1;2])
        (Set.of_list [0])
        (Set.of_list [2])
        (function 'a' -> (function 0 -> Set.of_list [0; 1]
                                 | 1 -> Set.singleton 2
                                 | _ -> Set.empty)
                | _ -> (function 0 -> Set.singleton 0
                                 | 1 -> Set.singleton 2
                                 | _ -> Set.empty));;

let v = function '0' -> 0
                | '1' -> 1
                | '2' -> 2
                | '3' -> 3
                | '4' -> 4
                | '5' -> 5
                | '6' -> 6
                | '7' -> 7
                | '8' -> 8
                | '9' -> 9

let a3 =
        Automate.create
        (Set.of_list ['0';'1';'2';'3';'4';'5';'6';'7';'8';'9'])
        (Set.of_list [0;1;2;3;4;5])
        (Set.of_list [0])
        (Set.of_list [0])
        (function c -> (function d -> Set.singleton ((d*10+(v c)) mod 6)));;

