(*      Bartosz Sułkowski       *)
(*      11.01.2004              *)
(*                              *)
(*      wyrażenia regularne     *)

module type EXPRESSION = sig

type expression =
        Empty
      | Epsilon
      | Letter of Alphabet.letter
      | Sum of expression * expression
      | Concatenation of expression * expression
      | Iteration of expression

(* funkcje zwracające odpowiednie wyrażenie, dokonujące skróceń *)
val sum : expression -> expression -> expression
val concatenate : expression -> expression -> expression
val iterate : expression -> expression

(* zwraca wyrażenie określające dane słowo
 * (ale składające się tylko ze zwykłych liter) *)
val of_word : Alphabet.word -> expression
(* zapisuje wyrażenie jako słowo *)
val to_word : expression -> Alphabet.word

end;;

