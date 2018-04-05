(*      Bartosz Sułkowski       *)
(*      11.01.2004              *)
(*                              *)
(*      automaty skończone      *)

module type AUTOMATE = sig

type 'a automate

(* konstruktor *)
(* użycie: create alfabet zbiór_stanów stany_początkowe stany_końcowe
 *              relacja_prześcia
 * gdzie relacja_przejścia c q = { p : q -c-> p } *)
val create :
        Alphabet.letter Set.set -> 'a Set.set -> 'a Set.set -> 'a Set.set
     -> (Alphabet.letter -> 'a -> 'a Set.set)
     -> 'a automate

(* selektory *)     
val alphabet : 'a automate -> Alphabet.letter Set.set
(* stany automatu *)
val states : 'a automate -> 'a Set.set
(* relacja przejścia między stanami *)
val delta : 'a automate -> Alphabet.letter -> 'a -> 'a Set.set 

(* step a c qs = { p : istnieje q<-qs, że (q -c-> p) } *)
val step : 'a automate -> Alphabet.letter -> 'a Set.set -> 'a Set.set
(* step_any a qs = { p : istnieje q<-qs i c<-alphabet a, że (q -c-> p) } *)
val step_any : 'a automate -> 'a Set.set -> 'a Set.set
(* back_step a qs =
   { p : jesli (p -c-> q), to q<-qs oraz dla pewnych q i c jest (p -c-> q) } *)
val back_step : 'a automate -> 'a Set.set -> 'a Set.set

(* stany początkowe *)
val initial_states : 'a automate -> 'a Set.set
(* stany akceptujące *)
val final_states : 'a automate -> 'a Set.set
(* stany osiągalne *)
val reachable_states : 'a automate -> 'a Set.set
(* stany produktywne *)
val productive_states : 'a automate -> 'a Set.set
(* stany silnie produktywne *)
val strong_productive_states : 'a automate -> 'a Set.set
(* stany ograniczone *)
val finite_states : 'a automate -> 'a Set.set

(* skleja według danej funkcji stany automatu
 * (jeśli jądro funkcji jest kongruencją dla tego automatu,
 * to otrzymujemy w ten sposób automat ilorazowy) *)
val map : ('a -> 'b) -> 'a automate -> 'b automate
(* zmienia nazwy stanów na liczby naturalne *)
val states_to_int : 'a automate -> int automate

(* redukcja stanów nieosiągalnych *)
val reduce : 'a automate -> 'a automate
(* determinizacja *)
val determinize : 'a automate -> 'a list automate
(* minimalizacja automatu deterministycznego
 * (dla automatu niedeterministycznego wynik jest nieokreślony) *)
val minimalize : 'a automate -> 'a automate
(* odwrócenie kierunku przejść w automacie *)
val reverse : 'a automate -> 'a automate

(* na podstawie funkcji opisującej stany automatu
 * zwraca słowo opisujące automat *)
val to_word : ('a -> Alphabet.word) -> 'a automate -> Alphabet.word

end;;
