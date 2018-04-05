(*      Bartosz Sułkowski       *)
(*      11.01.2004              *)
(*                              *)
(*      uniwersalne funkcje     *)

module Utilities : UTILITIES = struct

        
let id x = x

let const c _ = c

let apply f x = f x


let curry f x y = f (x, y)
        
let uncurry f (x, y) =  f x y

let flip f x y = f y x


let compose f g x = f (g x)

let fun_product f g (x, y) = (f x, g y)


let min x y = if x < y then x else y

let swap (x, y) = (y, x)

let push h t = h :: t

let non f x = not (f x)


let rec foldr f a = function
        [] -> a
      | (h::t) -> f h (foldr f a t)

let rec foldl f a = function
        [] -> a
      | (h::t) -> foldl f (f h a) t

let rec scanl f a = function
        [] -> [a]
      | (h::t) -> a :: scanl f (f h a) t
      
                
end;;
