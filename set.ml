(*      Bartosz Su³kowski       *)
(*      11.01.2004              *)
(*                              *)
(*      zbiory skoñczone        *)

module Set : SET = struct

      
open Utilities


(* mapa: element zbioru -> () *)
type 'a set = ('a, unit) Map.map

type ('a, 'b) sum =
        First of 'a
      | Second of 'b

      
let empty = Map.empty

let add x a = Map.update (x, ()) a


let is_empty a = Map.is_empty a

let member a x = Map.domain a x


let foldr f x a = Map.foldr (compose f fst) x a
        
let map f a = foldr (compose add f) empty a

let filter f a = Map.filter (compose f fst) a


let to_list a = List.map fst (Map.to_list a)
        
let of_list l = Map.of_list (List.map (function x -> (x, ())) l)


let singleton x = add x empty

let sum a b = Map.sum_with const a b
        
let product a b = Map.map (const ()) (Map.product a b)

let intersect a b = filter (member a) b

let intersects a b = not (is_empty (intersect a b))
        
let minus a b = filter (non (member a)) b

let subset a b = is_empty (minus a b)

let subsets a =
        let f x s = sum s (map (push x) s)
        in foldr f (singleton []) a

        
let first a = map (function x -> First x) a
        
let second a = map (function x -> Second x) a
        
let disjoint_sum a b = sum (first a) (second b)


end;;
