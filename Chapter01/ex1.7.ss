(define (average x y)
    (/ (+ x y) 2))

(define (improve guess x)
    (average guess (/ x guess)))

(define (good-enough? guess x)
    (< (abs (- (square guess) x)) 0.001))

(define (new-good-enough? old_guess new_guess)
    (< (abs (- old_guess new_guess)) 0.001))

(define (sqrt-iter guess x)
    (if (good-enough? guess x)
        guess
        (sqrt-iter (improve guess x) x)))

(define (new-sqrt-iter guess x)
    (if (new-good-enough? guess (improve guess x))
        guess
        (new-sqrt-iter (improve guess x) x)))

; (new-sqrt-iter 1.0 0.00009)
; (new-sqrt-iter 1.0 900000000000000000000000000000000000000000000000000000000000000000000000000000000000)
