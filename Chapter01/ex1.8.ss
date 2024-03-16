(define (improve guess x)
    (/ (+ (/ x (* guess guess)) (* 2 guess)) 3))

(define (good-enough? old_guess new_guess)
    (< (abs (- old_guess new_guess)) 0.001))

(define (cube-iter guess x)
    (if (good-enough? guess (improve guess x))
        guess
        (cube-iter (improve guess x) x)))

; (cube-iter 1.0 27)
; (cube-iter 1.0 0.00009)
; (cube-iter 1.0 900000000000000000000000000000000000000000000000000000000000000000000000000000000000)
