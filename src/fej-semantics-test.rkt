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
         (class G
           (((() A) a)))
        )
  ))

; programs
 (define term0 (term (lkp (new E (new A ⊕ ) (new B ⊕) ⊕ ) a)))
 (define term1 (term (lkp (new G (new A ⊕ ) ⊕ ) a)))

; examples
(define example0
  `(,term0 ,class-table))
(define example1
  `(,term1 ,class-table))

; tests fvalue for fvalue metafunction
(test-equal (term (fvalue ,class-table a (new E (new A ⊕ ) (new B ⊕) ⊕ )))
            '(new A ⊕ ))
(test-equal (term (fvalue ,class-table a (new E (new A ⊕ ) (new B ⊕) ⊕ ((new F ⊕ ) Z (new A ⊕ ) (new B ⊕)))))
            '(new A ⊕ ))
(test-equal (term (fvalue ,class-table a (new E (new A ⊕ ) (new B ⊕) ⊕ ((new F ⊕ ) Y) ((new F ⊕ ) Z (new A ⊕ ) (new B ⊕)))))
            '(new A ⊕ ))

;(traces red example1)

; test reduction rules
(test--> red
         example1
         `((new A ⊕ ) ,class-table))
(test--> red
         example0
         `((new A ⊕ ) ,class-table))

;(apply-reduction-relation red example1)

(test-results)
