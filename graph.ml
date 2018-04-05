(*      Bartosz Sułkowski       *)
(*      11.01.2004              *)
(*                              *)
(*      grafy skierowane        *)

module Graph : GRAPH = struct


open Utilities


(* mapa: wierzchołek -> (zbiór następników, zbiór poprzedników) *)
type 'a graph = ('a, 'a Set.set * 'a Set.set) Map.map


let empty = Map.empty

let add_vertex v g = Map.update_with (const id) (v, (Set.empty, Set.empty)) g

let edges_sum (n1, p1) (n2, p2) = (Set.sum n1 n2, Set.sum p1 p2)

let add_edge v w g =
        foldl (Map.update_with edges_sum) g
              [(v, (Set.singleton w, Set.empty))
              ;(w, (Set.empty, Set.singleton v))]

 
let next g v = fst (Map.apply g v)

let previous g v = snd (Map.apply g v)


let map f g =
        let vertex_map (v, e) =
                (f v, fun_product (Set.map f) (Set.map f) e)
        in
                Map.foldr (compose (Map.update_with edges_sum) vertex_map)
                          Map.empty g
        
let filter p g =
        Map.map (fun_product (Set.filter p) (Set.filter p))
                (Map.filter (compose p fst) g)

                
let create v n =
        let f x g = Set.foldr (add_edge x) (add_vertex x g) (n x)
        in Set.foldr f empty v
                        
let sum g1 g2 = Map.sum_with edges_sum g1 g2

let edges_product (n1, p1) (n2, p2) = (Set.product n1 n2, Set.product p1 p2)

let product g1 g2 = Map.map (uncurry edges_product) (Map.product g1 g2)
        
let disjoint_sum g1 g2 =
        sum (map (function x -> Set.First x) g1)
            (map (function x -> Set.Second x) g2)
        
let dual g = Map.map swap g


end;;
