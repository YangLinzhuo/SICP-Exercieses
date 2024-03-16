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

6. Alyssa P. Hacker doesn’t see why `if` needs to be provided as a special form. “Why can’t I just define it as an ordinary procedure in terms of `cond`?” she asks. Alyssa’s friend Eva Lu Ator claims this can indeed be done, and she defines a new version of `if`:

```scheme
(define (new-if predicate then-clause else-clause)
    (cond (predicate then-clause)
          (else else-clause)))
```

Eva demonstrates the program for Alyssa:

```scheme
(new-if (= 2 3) 0 5)
5 
(new-if (= 1 1) 0 5)
0
```

Delighted, Alyssa uses new-if to rewrite the square-root program:

```scheme
(define (sqrt-iter guess x)
    (new-if (good-enough? guess x)
            guess
            (sqrt-iter (improve guess x) x)))
```

What happens when Alyssa aempts to use this to compute square roots? Explain.

`if` 的特殊性质在于，根据 `predicate` 的真假，只会执行传入的两个表达式中的一个。而定义的 `new-if` 函数则不具备这种性质，那么其需要先计算所有的传入参数的值，然后再传入函数中运算。

根据 `new-if` 的定义可以看到，我们需要先求出 `(sqrt-iter (improve guess x) x)` 表达式的值，才能将其传入函数中，然而求该值的过程又需要调用 `new-if` 函数，就会导致无限递归，从而程序报错。具体细节可以参考 [SICP 解题集 1.6](https://sicp.readthedocs.io/en/latest/chp1/6.html)。

类似地，`C++` 中的拷贝构造函数需要入参为引用也是这个道理，否则会无限调用拷贝构造函数：

```cpp
class A {
    A(A& a) { ... }
}
```

7. The `good-enough?` test used in computing square roots will not be very effective for finding the square roots of very small numbers. Also, in real computers, arithmetic operations are almost always performed with limited precision. is makes our test inadequate for very large numbers. Explain these statements, with examples showing how the test fails for small and large numbers. An alternative strategy for implementing `good-enough?` is to watch how `guess` changes from one iteration to the next and to stop when the change is a very small fraction of the `guess`. Design a square-root procedure that uses this kind of end test. Does this work better for small and large numbers?

对于特别小的数，比如 `0.00009`，`sqrt-iter` 并不能计算出正确的答案； 而对于特别大的数，比如 `900000000000000000000000000000000000000000000000000000000000000000000000000000000000`，因为浮点数精度问题，两个大数的差总是大于预定的阈值，所以 `sqrt-iter` 会陷入死循环。

按照提示，比较两次迭代之间 `guess` 的差值，而非 `guess` 的平方与目标值 `x` 之间的差值，可以实现另一个版本：

```scheme
(define (average x y)
    (/ (+ x y) 2))

(define (improve guess x)
    (average guess (/ x guess)))

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

(new-sqrt-iter 1.0 0.00009)
(new-sqrt-iter 1.0 900000000000000000000000000000000000000000000000000000000000000000000000000000000000)

```



8. Newton’s method for cube roots is based on the fact that if $y$ is an approximation to the cube root of $x$, then a better approximation is given by the value

$$
\frac{x/y^2 + 2y}{3}
$$


Use this formula to implement a cube-root procedure analogous to the square-root procedure.

实现：

```scheme
(define (improve guess x)
    (/ (+ (/ x (* guess guess)) (* 2 guess)) 3))

(define (good-enough? old_guess new_guess)
    (< (abs (- old_guess new_guess)) 0.001))

(define (cube-iter guess x)
    (if (good-enough? guess (improve guess x))
        guess
        (cube-iter (improve guess x) x)))
```


9.  