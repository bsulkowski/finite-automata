(*      Bartosz Sułkowski       *)
(*      11.01.2004              *)
(*                              *)
(*      języki regularne        *)

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
(* dopełnienie języka *)
val invert : language -> language

(* selektory *)
(* czy słowo należy do języka *)
val accepts : language -> Alphabet.word -> bool
(* czy pewien prefix słowa należy do języka *)
val accepts_prefix : language -> Alphabet.word -> bool
(* czy język jest pusty *)
val is_empty : language -> bool
(* czy język jest nieskończony *)
val is_finite : language -> bool

(* konwersja między wyrażeniami *)
val of_expression : Expression.expression -> language
val to_expression : language -> Expression.expression

(* konwersja między automatami *)
val of_automate : 'a Automate.automate -> language
val to_automate : language -> int Automate.automate

end;;
