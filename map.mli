(*      Bartosz Sułkowski       *)
(*      11.01.2004              *)
(*                              *)
(*      mapy                    *)

module type MAP = sig

exception NotDefined

type ('a, 'b) map

val empty : ('a, 'b) map
val update : ('a * 'b) -> ('a, 'b) map -> ('a, 'b) map
val update_with : ('b -> 'b -> 'b) -> ('a * 'b) -> ('a, 'b) map -> ('a, 'b) map

val is_empty : ('a, 'b) map -> bool
val domain : ('a, 'b) map -> 'a -> bool
val apply : ('a, 'b) map -> 'a -> 'b

val foldr : (('a * 'b) -> 'c -> 'c) -> 'c -> ('a, 'b) map -> 'c
val map : ('b -> 'c) -> ('a, 'b) map -> ('a, 'c) map
val filter : (('a * 'b) -> bool) -> ('a, 'b) map -> ('a, 'b) map

val to_list : ('a, 'b) map -> ('a * 'b) list
val of_list : ('a * 'b) list -> ('a, 'b) map

val sum_with : ('b -> 'b -> 'b) -> ('a, 'b) map -> ('a, 'b) map -> ('a, 'b) map
val product : ('a, 'b) map -> ('c, 'd) map -> ('a * 'c, 'b * 'd) map

end;;
