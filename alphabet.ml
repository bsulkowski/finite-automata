(*      Bartosz Su³kowski       *)
(*      11.01.2004              *)
(*                              *)
(*      alfabet                 *)

module Alphabet : ALPHABET = struct


type letter = char
type word = letter list


let read str =
        let rec reads s =
                try
                        let c = Stream.next s
                        in c :: reads s
                with Stream.Failure -> []
        in reads (Stream.of_string str);;

let read_int i =
        read (Printf.sprintf "%i" i)

        
let rec write = function
        [] -> Printf.printf "\n"
      | (h::t) -> Printf.printf "%c" h ; write t
      

end;;

