(*      Bartosz Su�kowski       *)
(*      11.01.2004              *)
(*                              *)
(*      alfabet                 *)

module type ALPHABET = sig
        
(* litera *)        
type letter = char
(* s�owo *)
type word = letter list

(* wczytuje s�owo z napisu *)
val read : string -> word
(* wczytuje s�owo z liczby *)
val read_int : int -> word

(* wypisuje s�owo na ekranie *)
val write : word -> unit

end;;
