(*      Bartosz Su³kowski       *)
(*      11.01.2004              *)
(*                              *)
(*      grafy skierowane        *)

module type GRAPH = sig

type 'a graph

val empty : 'a graph
val add_vertex : 'a -> 'a graph -> 'a graph
val add_edge : 'a -> 'a -> 'a graph -> 'a graph

val next : 'a graph -> 'a -> 'a Set.set
val previous : 'a graph -> 'a -> 'a Set.set

val map : ('a -> 'b) -> 'a graph -> 'b graph
val filter : ('a -> bool) -> 'a graph -> 'a graph

val create : ('a Set.set) -> ('a -> 'a Set.set) -> 'a graph
val sum : 'a graph -> 'a graph -> 'a graph
val product : 'a graph -> 'b graph -> ('a * 'b) graph
val disjoint_sum : 'a graph -> 'b graph -> ('a, 'b) Set.sum graph
val dual : 'a graph -> 'a graph

end;;
