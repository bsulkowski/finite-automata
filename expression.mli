(*      Bartosz Su³kowski       *)
(*      11.01.2004              *)
(*                              *)
(*      wyra¿enia regularne     *)

module type EXPRESSION = sig

type expression =
        Empty
      | Epsilon
      | Letter of Alphabet.letter
      | Sum of expression * expression
      | Concatenation of expression * expression
      | Iteration of expression

(* funkcje zwracaj±ce odpowiednie wyra¿enie, dokonuj±ce skróceñ *)
val sum : expression -> expression -> expression
val concatenate : expression -> expression -> expression
val iterate : expression -> expression

(* zwraca wyra¿enie okre¶laj±ce dane s³owo
 * (ale sk³adaj±ce siê tylko ze zwyk³ych liter) *)
val of_word : Alphabet.word -> expression
(* zapisuje wyra¿enie jako s³owo *)
val to_word : expression -> Alphabet.word

end;;

