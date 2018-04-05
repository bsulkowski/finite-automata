(*      Bartosz Sułkowski       *)
(*      11.01.2004              *)
(*                              *)
(*      uniwersalne funkcje     *)

module type UTILITIES = sig
        
val id : 'a -> 'a
val const : 'a -> 'b -> 'a
val apply : ('a -> 'b) -> 'a -> 'b

val curry : ('a * 'b -> 'c) -> ('a -> 'b -> 'c)
val uncurry : ('a -> 'b -> 'c) -> ('a * 'b -> 'c)
val flip : ('a -> 'b -> 'c) -> ('b -> 'a -> 'c)

val compose : ('b -> 'c) -> ('a -> 'b) -> ('a -> 'c)
val fun_product : ('a -> 'b) -> ('c -> 'd) -> ('a * 'c -> 'b * 'd)

val min : 'a -> 'a -> 'a
val swap : 'a * 'b -> 'b * 'a
val push : 'a -> 'a list -> 'a list
val non : ('a -> bool) -> ('a -> bool)

val foldr : ('a -> 'b -> 'b) -> 'b -> 'a list -> 'b
val foldl : ('a -> 'b -> 'b) -> 'b -> 'a list -> 'b
val scanl : ('a -> 'b -> 'b) -> 'b -> 'a list -> 'b list

end;;
