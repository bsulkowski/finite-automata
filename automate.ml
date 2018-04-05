(*      Bartosz Sułkowski       *)
(*      11.01.2004              *)
(*                              *)
(*      automaty skończone      *)

module Automate : AUTOMATE = struct


open Utilities
open Alphabet
        

type 'a automate = {
        (* alfabet *)
        alphabet : Alphabet.letter Set.set;
        (* zbiór stanów automatu *)
        states : 'a Set.set;
        (* zbiór stanów początkowych *)
        initial_states : 'a Set.set;
        (* zbiór stanów akceptujących *)
        final_states : 'a Set.set;
        (* relacja przejścia, przechowywana w postaci mapy:
           litera alfabetu -> graf przejść między stanami poprzez tę literę *)
        map : (Alphabet.letter, 'a Graph.graph) Map.map
}


let create cs q q_i q_f delta =
        let add_letter c m =
                Map.update (c, (Graph.create q (delta c))) m
        in
              { alphabet = cs;
                states = q;
                initial_states = q_i;
                final_states = q_f;
                map = Set.foldr add_letter Map.empty cs }
        
let alphabet a = a.alphabet

let states a = a.states

let delta a c =
        try Graph.next (Map.apply a.map c)
        with Map.NotDefined -> const Set.empty


let reverse a =
      { alphabet = a.alphabet;
        states = a.states;
        initial_states = a.final_states;
        final_states = a.initial_states;
        map = Map.map Graph.dual a.map }

      
let step a c = Set.foldr (compose Set.sum (delta a c)) Set.empty
                        
let step_any a qs =
        Set.foldr (compose Set.sum (flip (step a) qs))
                Set.empty (alphabet a)
                
let back_step a =
        let rev_a = reverse a
        in function qs ->
                Set.filter (compose (Set.subset qs)
                        (compose (step_any a) Set.singleton))
                (step_any (rev_a) qs)

(* wyznacza elementy zbioru, do których można dojść od <x0>
   za pomocą przejścia <n> (tzn. a --> b, jeśli b <- (n a)
   inaczej mówiąc: traverse n x0 =
           obraz domknięcia przechodnio-zwrotnego relacji n zbioru x0 *)
let traverse n x0 =
        let rec advance x x1 =
                if not (Set.is_empty x1) then
                        advance (Set.sum x x1) (Set.minus x (n x1))
                else x
        in advance Set.empty x0
       

let initial_states a = a.initial_states

let final_states a = a.final_states

let reachable_states a = traverse (step_any a) (initial_states a)

let productive_states a = reachable_states (reverse a)

let strong_productive_states a =
        let rev_a = reverse a
        in traverse (step_any rev_a) (step_any rev_a (initial_states rev_a))

let finite_states a =
        let rec advance x =
                let x1 = back_step a x
                in
                        if Set.subset x x1 then x
                        else advance (Set.sum x x1)
        in
                advance (Set.minus (strong_productive_states a) (states a))


let map f a =
      { alphabet = a.alphabet;
        states = Set.map f a.states;
        initial_states = Set.map f a.initial_states;
        final_states = Set.map f a.final_states;
        map = Map.map (Graph.map f) a.map }

let filter f a =
      { alphabet = a.alphabet;
        states = Set.filter f a.states;
        initial_states = Set.filter f a.initial_states;
        final_states = Set.filter f a.final_states;
        map = Map.map (Graph.filter f) a.map }

let states_to_int a =
    let add_state q (m, i) = Map.update (q, i) m, i + 1
    in
        let numeration = fst (Set.foldr add_state (Map.empty, 0) (states a))
        in map (Map.apply numeration) a   
      

let reduce a = filter (Set.member (reachable_states a)) a

let determinize a = create
        (alphabet a)
        (Set.subsets (states a))
        (Set.singleton (Set.to_list (initial_states a)))
        (Set.filter
                (compose (Set.intersects (final_states a)) Set.of_list)
                (Set.subsets (states a)))
        (function c -> function q ->
                Set.singleton (Set.to_list (step a c (Set.of_list q))))
        
(* relation == ker (homomorphism relation) *)
let homomorphism relation =
        let f (a, b) m =
            let c = min a b
            in foldl (Map.update_with min) m [(b, c); (a, c)]
        in Map.apply (Set.foldr f Map.empty relation)

(* relacja syntaktyczna dla stanów automatu
   (p,q) <- syntactic_relation A, wtw gdy L(A,p) = L(A,q) *)
let syntactic_relation a =
    let final = final_states a
    and not_final = Set.minus (final_states a) (states a)
    in
        let prod_a =
              { alphabet = a.alphabet;
                states = Set.product a.states a.states;
                initial_states = Set.empty;
                final_states = (Set.sum (Set.product final not_final)
                                        (Set.product not_final final));
                map = Map.map (function x -> Graph.product x x) a.map }
        in
            Set.minus (productive_states prod_a) (states prod_a)

let minimalize a =
        let red_a = reduce a
        in map (homomorphism (syntactic_relation red_a)) red_a

        
let to_word state_to_word a =
    let shows_state q w =
        let shows_letter c v =
            let shows_target x u =
                (read " ") @ (state_to_word x) @ u
            in
                (read "\n\t-") @ [c] @ (read "-> ")
              @ (Set.foldr shows_target v (delta a c q))
        in                                
            (read "\n\n*** ") @ (state_to_word q) @ (read " ***")
          @ (if Set.member (initial_states a) q then read " INITIAL" else [])
          @ (if Set.member (final_states a) q then read " FINAL" else [])
          @ (Set.foldr shows_letter w (alphabet a))
    in
        Set.foldr shows_state [] (states a)

        
end;;
