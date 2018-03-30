(*      Bartosz Su³kowski       *)
(*      11.01.2004              *)
(*                              *)
(*      jêzyki regularne        *)

module type LANGUAGE = sig

type language

(* konstruktory *)
val empty : language
val epsilon : language
val letter : Alphabet.letter -> language
val sum : language -> language -> language
(* konkatenacja *)
val concatenate : language -> language -> language
(* iteracja - operacja gwiazdki *)
val iterate : language -> language

(* modyfikatory *)
val intersect : language -> language -> language
val reverse : language -> language
(* dope³nienie jêzyka *)
val invert : language -> language

(* selektory *)
(* czy s³owo nale¿y do jêzyka *)
val accepts : language -> Alphabet.word -> bool
(* czy pewien prefix s³owa nale¿y do jêzyka *)
val accepts_prefix : language -> Alphabet.word -> bool
(* czy jêzyk jest pusty *)
val is_empty : language -> bool
(* czy jêzyk jest nieskoñczony *)
val is_finite : language -> bool

(* konwersja miêdzy wyra¿eniami *)
val of_expression : Expression.expression -> language
val to_expression : language -> Expression.expression

(* konwersja miêdzy automatami *)
val of_automate : 'a Automate.automate -> language
val to_automate : language -> int Automate.automate

end;;
