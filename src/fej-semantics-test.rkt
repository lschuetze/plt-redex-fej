#lang racket

(require "fej.rkt"
         "fej-semantics.rkt"
         redex)

(define class-table
  (term ( 
         (class A ())
         (class B ()
           (((() A) m (((() A) x))) x)
           )
         (class F ()
           (role Z requires ((() A) m (((() A) x)))
                 (((() A) a) ((() B) b)))
           (role Y requires ((() A) m (((() A) x)))
                 () (((() A) o (((() A) x))) x))
           )
         (class E
           (((() A) a) ((() B) b)))
         )
        )
  )

; programs
(define term0 (term (lkp (new E (new A ⊕ ) (new B ⊕) ⊕ ) a)))

; examples
(define example0
  `(,term0 ,class-table))

; tests fvalue for fvalue metafunction 
(test-equal (term (fvalue ,class-table a (new E (new A ⊕ ) (new B ⊕) ⊕ )))
            '(new A ⊕ ))
(test-equal (term (fvalue ,class-table a (new E (new A ⊕ ) (new B ⊕) ⊕ ((new F ⊕ ) Z (new A ⊕ ) (new B ⊕)))))
            '(new A ⊕ ))
(test-equal (term (fvalue ,class-table a (new E (new A ⊕ ) (new B ⊕) ⊕ ((new F ⊕ ) Y) ((new F ⊕ ) Z (new A ⊕ ) (new B ⊕)))))
            '(new A ⊕ ))

; test reduction rules
(test--> red
          example0
          `((new A ⊕ ) ,class-table))

(test-results)
