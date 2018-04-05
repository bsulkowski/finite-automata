(*      Bartosz Sułkowski       *)
(*      11.01.2004              *)
(*                              *)
(*      języki regularne        *)

module Language : LANGUAGE = struct


open Utilities
open Expression


(* język jest opisywany poprzez akceptujący go
   automat skończony, o stanach będących liczbami całkowitymi *)
type language = int Automate.automate

type equation = int * (int, expression) Map.map * expression


let of_automate a = Automate.states_to_int (Automate.reduce a)

let to_automate l = l


let empty = of_automate (Automate.create
        Set.empty
        Set.empty
        Set.empty
        Set.empty
        (const (const Set.empty)))

let epsilon = of_automate (Automate.create
        Set.empty
        (Set.singleton 0)
        (Set.singleton 0)
        (Set.singleton 0)
        (const (const Set.empty)))
        
let letter c = of_automate (Automate.create
        (Set.singleton c)
        (Set.of_list [0; 1])
        (Set.singleton 0)
        (Set.singleton 1)
        (const (function 0 -> Set.singleton 1 | _ -> Set.empty)))

let sum l1 l2 =
        let a1 = to_automate l1
        and a2 = to_automate l2
        in of_automate (Automate.create
        (Set.sum (Automate.alphabet a1) (Automate.alphabet a2))
        (Set.disjoint_sum (Automate.states a1) (Automate.states a2))
        (Set.disjoint_sum (Automate.initial_states a1)
                          (Automate.initial_states a2))
        (Set.disjoint_sum (Automate.final_states a1)
                          (Automate.final_states a2))
        (function c -> function 
                Set.First q -> Set.first (Automate.delta a1 c q)
              | Set.Second q -> Set.second (Automate.delta a2 c q) ))
                                
let concatenate l1 l2 =
        let a1 = to_automate l1
        and a2 = to_automate l2
        in of_automate (Automate.create
        (Set.sum (Automate.alphabet a1) (Automate.alphabet a2))
        (Set.disjoint_sum (Automate.states a1) (Automate.states a2))
        (Set.first (Automate.initial_states a1))
        ((if Set.intersects (Automate.initial_states a2)
                            (Automate.final_states a2)
         then Set.sum (Set.first (Automate.final_states a1))
         else id)
         (Set.second (Automate.final_states a2)))
        (function c -> function
            Set.First q ->
                (if Set.member (Automate.final_states a1) q then
                        Set.sum (Set.second (Automate.step a2 c
                                (Automate.initial_states a2)))
                else id)
                (Set.first (Automate.delta a1 c q))
          | Set.Second q -> Set.second (Automate.delta a2 c q) ))

(* iteracja co najmniej jednokrotna
   (zwykle oznaczana "+" zamiast "*") *)
let iterate_more l =
        let a = to_automate l
        in of_automate (Automate.create
        (Automate.alphabet a)
        (Automate.states a)
        (Automate.initial_states a)
        (Automate.final_states a)
        (function c -> function q ->
                (if Set.member (Automate.final_states a) q then
                    Set.sum (Automate.step a c (Automate.initial_states a))
                else id)
                (Automate.delta a c q) ))
                        
let iterate l = sum epsilon (iterate_more l)


let intersect l1 l2 =
        let a1 = to_automate l1
        and a2 = to_automate l2
        in of_automate (Automate.create
        (Set.sum (Automate.alphabet a1) (Automate.alphabet a2))
        (Set.product (Automate.states a1) (Automate.states a2))
        (Set.product (Automate.initial_states a1)
                     (Automate.initial_states a2))
        (Set.product (Automate.final_states a1)
                     (Automate.final_states a2))
        (function c -> function (q1, q2) ->
                Set.product (Automate.delta a1 c q1)
                            (Automate.delta a2 c q2) ))

let reverse l = of_automate (Automate.reverse (to_automate l))

let invert l =
    let a = to_automate l
    in
        let det_a = Automate.minimalize (Automate.determinize a)
        in of_automate (Automate.create
                (Automate.alphabet det_a)
                (Automate.states det_a)
                (Automate.initial_states det_a)
                (Set.minus (Automate.final_states det_a) (Automate.states det_a))
                (Automate.delta det_a))

       
let accepts l w =
        let a = to_automate l
        in
            let computed_states =
                (foldl apply (Automate.initial_states a)
                             (List.map (Automate.step a) w))
            in
                Set.intersects (Automate.final_states a)
                               computed_states

let accepts_prefix l w =
        let a = to_automate l
        in
           let computation =
                (scanl apply (Automate.initial_states a)
                             (List.map (Automate.step a) w))
           in
                foldl (||) false
                    (List.map (Set.intersects (Automate.final_states a))
                               computation)

let is_empty l =
        let a = to_automate l
        in
            not (Set.intersects (Automate.final_states a)
                                (Automate.reachable_states a))
       
let is_finite l =
        let a = to_automate l
        in
                Set.subset (Automate.finite_states a)
                           (Automate.initial_states a)

        
let rec of_expression = function
    Empty -> empty
  | Epsilon -> epsilon
  | Letter c -> letter c
  | Sum (e1, e2) -> sum (of_expression e1) (of_expression e2)
  | Concatenation (e1, e2) ->concatenate (of_expression e1) (of_expression e2)
  | Iteration e -> iterate (of_expression e)


(* układ równań opisujący języki generowane przez
   poszczególne stany automatu *)
let equations a =
    let eq q =
        let add_letter c m =
            Set.foldr
                (function x -> Map.update_with Expression.sum (x, Letter c))
                m
                (Automate.delta a c q)
        in
            (q
            ,Set.foldr add_letter Map.empty (Automate.alphabet a)
            ,if (Set.member (Automate.final_states a) q) then
                Epsilon else Empty)
    in Set.foldr (compose push eq) [] (Automate.states a)

(* podstawia pierwsze równanie w drugim *)    
let substitute (q1, m1, f1) (q2, m2, f2) =
    let alpha =
        try Expression.concatenate (Map.apply m2 q1)
        with Map.NotDefined -> const Empty
    in
        (q2
        ,Map.sum_with Expression.sum (Map.map alpha m1)
                (Map.update (q1, Empty) m2)
        ,Expression.sum (alpha f1) f2)

(* upraszcza równanie: "L = wL + M" do postaci "L = w*M" *)
let simplify (q, m, f) =
    let alpha =
        try Expression.concatenate (Expression.iterate (Map.apply m q))
        with Map.NotDefined -> id
    in
        (q
        ,Map.map alpha (Map.update (q, Empty) m)
        ,alpha f)

(* rozwiązuje dany układ równań *)        
let solve equations =
    let rec solve2 solved = function
            [] -> List.map (function (q, m, f) -> (q, f)) solved
          | (eq::eqs) -> solve2 (eq::solved) (List.map (substitute eq) eqs)
    in  
    let rec solve1 simplified = function
        [] -> solve2 [] simplified
      | (eq::eqs) ->
            let s_eq = simplify eq
            in solve1 (s_eq::simplified) (List.map (substitute s_eq) eqs)
    in solve1 [] equations
    
let to_expression l =
    let a = to_automate l
    in
      let initial = Set.member (Automate.initial_states a)
      in
        foldr (compose Expression.sum snd) Empty
              (List.filter (compose initial fst) (solve (equations a)))


end;;

