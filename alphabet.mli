(*      Bartosz Sułkowski       *)
(*      11.01.2004              *)
(*                              *)
(*      alfabet                 *)

module type ALPHABET = sig
        
(* litera *)        
type letter = char
(* słowo *)
type word = letter list

(* wczytuje słowo z napisu *)
val read : string -> word
(* wczytuje słowo z liczby *)
val read_int : int -> word

(* wypisuje słowo na ekranie *)
val write : word -> unit

end;;
