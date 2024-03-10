(define (square x)
    (* x x))

(define (smallest x y z)
    (and (< x y) (< x z)))

(define (select x y z)
    (if (smallest x y z) 0 x))

(define (sum_of_two_larger_squares x y z)
    (+ (square (select x y z)) (square (select y x z)) (square (select z x y))))

(sum_of_two_larger_squares 0 1 2)
(sum_of_two_larger_squares 0 3 3)
(sum_of_two_larger_squares 4 1 2)
