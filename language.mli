(*      Bartosz Su�kowski       *)
(*      11.01.2004              *)
(*                              *)
(*      j�zyki regularne        *)

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
(* dope�nienie j�zyka *)
val invert : language -> language

(* selektory *)
(* czy s�owo nale�y do j�zyka *)
val accepts : language -> Alphabet.word -> bool
(* czy pewien prefix s�owa nale�y do j�zyka *)
val accepts_prefix : language -> Alphabet.word -> bool
(* czy j�zyk jest pusty *)
val is_empty : language -> bool
(* czy j�zyk jest niesko�czony *)
val is_finite : language -> bool

(* konwersja mi�dzy wyra�eniami *)
val of_expression : Expression.expression -> language
val to_expression : language -> Expression.expression

(* konwersja mi�dzy automatami *)
val of_automate : 'a Automate.automate -> language
val to_automate : language -> int Automate.automate

end;;
