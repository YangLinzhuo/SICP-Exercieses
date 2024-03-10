# Chapter 1 Exercises

1. Below is a sequence of expressions. What is the result printed by the interpreter in response to each expression? Assume that the sequence is to be evaluated in the order in which it is presented.

```scheme
10
(+ 5 3 4)
(- 9 1)
(/ 6 2)
(+ (* 2 4) (- 4 6))
(define a 3)
(define b (+ a 1))
(+ a b (* a b))
(= a b)
(if (and (> b a) (< b (* a b)))
    b
    a)

(cond ((= a 4) 6)
      ((= b 4) (+ 6 7 a))
      (else 25))

(+ 2 (if (> b a) b a))
(* (cond ((> a b) a)
         ((< a b) b)
         (else -1))
   (+ a 1))
```

表达式结果：
```text
1 ]=> 10
;Value: 10

1 ]=> (+ 5 3 4)
;Value: 12

1 ]=> (- 9 1)
;Value: 8

1 ]=> (/ 6 2)
;Value: 3

1 ]=> (+ (* 2 4) (- 4 6))
;Value: 6

1 ]=> (define a 3)
;Value: a

1 ]=> (define b (+ a 1))
;Value: b

1 ]=> (+ a b (* a b))
;Value: 19

1 ]=> (= a b)
;Value: #f

1 ]=> (if (and (> b a) (< b (* a b)))
    b
    a)
;Value: 4

1 ]=> (cond ((= a 4) 6)
      ((= b 4) (+ 6 7 a))
      (else 25))
;Value: 16

1 ]=> (+ 2 (if (> b a) b a))
;Value: 6

1 ]=> (* (cond ((> a b) a)
         ((< a b) b)
         (else -1))
   (+ a 1))
;Value: 16

1 ]=> 
End of input stream reached.
Ceterum censeo Carthaginem esse delendam.
```

2. Translate the following expression into prefix form:

$$
\frac{5 + 4 + (2 - (3 - (6 + \frac{4}{5})))}{3(6 - 2)(2 - 7)}
$$

```scheme
(/ (+ 5 4 (- 2 (- 3 (+ 6 (/ 4 5))))) (* 3 (- 6 2) (- 2 7)))
```

```text
1 ]=> (/ (+ 5 4 (- 2 (- 3 (+ 6 (/ 4 5))))) (* 3 (- 6 2) (- 2 7)))
;Value: -37/150
```

3. Define a procedure that takes three numbers as arguments and returns the sum of the squares of the two larger numbers.

```scheme
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
```

4. Observe that our model of evaluation allows for combinations whose operators are compound expressions. Use this observation to describe the behavior of the following proedure:

```scheme
(define (a-plus-abs-b a b)
    ((if (> b 0) + -) a b))
```

`(if (> b 0) + -)` 根据 `b` 的大小返回 `+` 或者 `-` 运算符，用于后续 `a` 和 `b` 的计算。

如果 `b > 0`，则计算 `(+ a b)`，否则计算 `(- a b)`。


5. Ben Bitdiddle has invented a test to determine whether the interpreter he is faced with is using applicativeorder evaluation or normal-order evaluation. He defines the following two procedures:

```scheme
(define (p) (p))
(define (test x y)
    (if (= x 0) 0 y))
```

Then he evaluates the expression

```scheme
(test 0 (p))
```

What behavior will Ben observe with an interpreter that uses applicative-order evaluation? What behavior will he observe with an interpreter that uses normal-order evaluation? Explain your answer. (Assume that the evaluation rule for the special form if is the same whether the interpreter is using normal or applicative order: e predicate expression is evaluated first, and the result determines whether to evaluate the consequent or the alternative expression.)

如果是 applicative-order，那么会先执行 `(p)` 表达式，再传入 `test` 函数。而该表达式会不断调用 `p` 函数，那么会持续递归调用下去，导致超过调用深度上限。

如果是 normal-order，那么会替换表达式，先调用 `if` 判断，直接返回 `0`，并不会实际调用 `p` 函数。

6. 