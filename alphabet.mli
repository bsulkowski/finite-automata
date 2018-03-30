(*      Bartosz Su趾owski       *)
(*      11.01.2004              *)
(*                              *)
(*      alfabet                 *)

module type ALPHABET = sig
        
(* litera *)        
type letter = char
(* s這wo *)
type word = letter list

(* wczytuje s這wo z napisu *)
val read : string -> word
(* wczytuje s這wo z liczby *)
val read_int : int -> word

(* wypisuje s這wo na ekranie *)
val write : word -> unit

end;;
