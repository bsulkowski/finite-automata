(*      Bartosz Sułkowski       *)
(*      11.01.2004              *)
(*                              *)
(*      mapy                    *)

module Map : MAP = struct

      
open Utilities

        
exception NotDefined


(* zwyczajne drzewo BST *)
type ('a, 'b) map =
        Node of ('a * 'b) * ('a, 'b) map * ('a, 'b) map
      | Leaf
      

let empty = Leaf
        
let rec update_with f ((x, y) as p) = function
        Node ((a, b) as n, l, r) -> 
                if x < a then Node (n, (update_with f p l), r)
                else if x > a then Node (n, l, (update_with f p r))
                else Node ((x, f y b), l, r)
      | Leaf -> Node (p, Leaf, Leaf)

let update p m = update_with const p m


let is_empty = function
        Leaf -> true
      | _ -> false

let rec apply m x = match m with
        Node ((a,b) as n, l, r) ->
                if x < a then apply l x
                else if x > a then apply r x
                else b
      | Leaf -> raise NotDefined

let domain m x =
        try apply m x; true
        with NotDefined -> false

        
let rec foldr f a = function
        Node (n, l, r) -> foldr f (f n (foldr f a r)) l
      | Leaf -> a

let rec map f = function
        Node ((a, b), l, r) -> Node ((a, f b), (map f l), (map f r))
      | Leaf -> Leaf
      
let filter f m = foldr (function n -> if f n then update n else id) empty m


let to_list m = foldr push [] m

let of_list l = Utilities.foldr update empty l


let sum_with f m1 m2 = foldr (update_with f) m2 m1

let product m1 m2 =
        let f (x,y) m = foldr (function (a,b) -> update ((a,x),(b,y))) m m1
        in foldr f empty m2

        
end;;
