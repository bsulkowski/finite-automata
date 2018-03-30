(*      Bartosz Su³kowski       *)
(*      11.01.2004              *)
(*                              *)
(*      wyra¿enia regularne     *)

module Expression : EXPRESSION = struct


open Utilities


type expression =
        Empty
      | Epsilon
      | Letter of Alphabet.letter
      | Sum of expression * expression
      | Concatenation of expression * expression
      | Iteration of expression


let sum = function
        Empty -> id
      | e1 -> function
                Empty -> e1
              | e2 -> Sum (e1, e2)
              
let concatenate = function
        Empty -> const Empty
      | Epsilon -> id
      | e1 -> function
                Empty -> Empty
              | Epsilon -> e1
              | e2 -> Concatenation (e1, e2)
                
let iterate = function
        Empty -> Epsilon
      | Epsilon -> Epsilon
      | Iteration e -> Iteration e
      | e -> Iteration e

      
let of_word w = foldr concatenate Epsilon (List.map (function c -> Letter c) w)

let to_word e =
    let rec shows = function
        Empty -> push '0'
      | Epsilon -> push '@'
      | Letter c -> push c
      | Sum (e1, e2) ->
          (function w -> '('::(shows e1 ('+'::(shows e2 (')'::w)))))
      | Concatenation (e1, e2) ->
          (function w -> '('::(shows e1 (shows e2 (')'::w))))
      | Iteration e ->
          (function w -> shows e ('*'::w))
    in
        shows e []

        
end;;
