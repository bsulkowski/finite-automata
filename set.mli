(*      Bartosz Su³kowski       *)
(*      11.01.2004              *)
(*                              *)
(*      zbiory skoñczone        *)

module type SET = sig

type 'a set
type ('a, 'b) sum =
        First of 'a
      | Second of 'b

val empty : 'a set
val add : 'a -> 'a set -> 'a set

val is_empty : 'a set -> bool
val member : 'a set -> 'a -> bool
val subset : 'a set -> 'a set -> bool
val intersects : 'a set -> 'a set -> bool

val foldr : ('a -> 'b -> 'b) -> 'b -> 'a set -> 'b
val map : ('a -> 'b) -> 'a set -> 'b set
val filter : ('a -> bool) -> 'a set -> 'a set

val to_list : 'a set -> 'a list
val of_list : 'a list -> 'a set

val singleton : 'a -> 'a set
val sum : 'a set -> 'a set -> 'a set
val product : 'a set -> 'b set -> ('a * 'b) set
val intersect : 'a set -> 'a set -> 'a set
val minus : 'a set -> 'a set -> 'a set
val subsets : 'a set -> 'a list set

val disjoint_sum : 'a set -> 'b set -> ('a, 'b) sum set
val first : 'a set -> ('a, 'b) sum set
val second : 'b set -> ('a, 'b) sum set

end;;
