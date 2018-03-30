(*      Bartosz Su³kowski       *)
(*      11.01.2004              *)
(*                              *)
(*      automaty skoñczone      *)

module type AUTOMATE = sig

type 'a automate

(* konstruktor *)
(* u¿ycie: create alfabet zbiór_stanów stany_pocz±tkowe stany_koñcowe
 *              relacja_prze¶cia
 * gdzie relacja_przej¶cia c q = { p : q -c-> p } *)
val create :
        Alphabet.letter Set.set -> 'a Set.set -> 'a Set.set -> 'a Set.set
     -> (Alphabet.letter -> 'a -> 'a Set.set)
     -> 'a automate

(* selektory *)     
val alphabet : 'a automate -> Alphabet.letter Set.set
(* stany automatu *)
val states : 'a automate -> 'a Set.set
(* relacja przej¶cia miêdzy stanami *)
val delta : 'a automate -> Alphabet.letter -> 'a -> 'a Set.set 

(* step a c qs = { p : istnieje q<-qs, ¿e (q -c-> p) } *)
val step : 'a automate -> Alphabet.letter -> 'a Set.set -> 'a Set.set
(* step_any a qs = { p : istnieje q<-qs i c<-alphabet a, ¿e (q -c-> p) } *)
val step_any : 'a automate -> 'a Set.set -> 'a Set.set
(* back_step a qs =
   { p : jesli (p -c-> q), to q<-qs oraz dla pewnych q i c jest (p -c-> q) } *)
val back_step : 'a automate -> 'a Set.set -> 'a Set.set

(* stany pocz±tkowe *)
val initial_states : 'a automate -> 'a Set.set
(* stany akceptuj±ce *)
val final_states : 'a automate -> 'a Set.set
(* stany osi±galne *)
val reachable_states : 'a automate -> 'a Set.set
(* stany produktywne *)
val productive_states : 'a automate -> 'a Set.set
(* stany silnie produktywne *)
val strong_productive_states : 'a automate -> 'a Set.set
(* stany ograniczone *)
val finite_states : 'a automate -> 'a Set.set

(* skleja wed³ug danej funkcji stany automatu
 * (je¶li j±dro funkcji jest kongruencj± dla tego automatu,
 * to otrzymujemy w ten sposób automat ilorazowy) *)
val map : ('a -> 'b) -> 'a automate -> 'b automate
(* zmienia nazwy stanów na liczby naturalne *)
val states_to_int : 'a automate -> int automate

(* redukcja stanów nieosi±galnych *)
val reduce : 'a automate -> 'a automate
(* determinizacja *)
val determinize : 'a automate -> 'a list automate
(* minimalizacja automatu deterministycznego
 * (dla automatu niedeterministycznego wynik jest nieokre¶lony) *)
val minimalize : 'a automate -> 'a automate
(* odwrócenie kierunku przej¶æ w automacie *)
val reverse : 'a automate -> 'a automate

(* na podstawie funkcji opisuj±cej stany automatu
 * zwraca s³owo opisuj±ce automat *)
val to_word : ('a -> Alphabet.word) -> 'a automate -> Alphabet.word

end;;
