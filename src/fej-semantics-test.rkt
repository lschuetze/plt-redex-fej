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
         (class D ()
           (((() A) m (((() A) x))) (call this n x))
           (((() A) n (((() A) x))) x)
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
(define term2 (term (call (new B ⊕) m (new A ⊕))))
(define term3 (term (call (new D ⊕) m (new A ⊕))))

; examples
(define example0
  `(,term0 ,class-table))
(define example1
  `(,term1 ,class-table))
(define example2
  `(,term2 ,class-table))
(define example3
  `(,term3 ,class-table))

; tests fvalue for fvalue metafunction
(test-equal (term (fvalue ,class-table a (new E (new A ⊕ ) (new B ⊕) ⊕ )))
            '(new A ⊕ ))
(test-equal (term (fvalue ,class-table a (new E (new A ⊕ ) (new B ⊕) ⊕ ((new F ⊕ ) Z (new A ⊕ ) (new B ⊕)))))
            '(new A ⊕ ))
(test-equal (term (fvalue ,class-table a (new E (new A ⊕ ) (new B ⊕) ⊕ ((new F ⊕ ) Y) ((new F ⊕ ) Z (new A ⊕ ) (new B ⊕)))))
            '(new A ⊕ ))


;(redex-match fej v '(new C ⊕ ((new A ⊕) B)))
(test-equal (term (cp (A B) (new C ⊕ ((new A ⊕) B))))
            '(new C ⊕))
(test-equal (term (cp (A B) (new C ⊕ ((new D ⊕) E) ((new A ⊕) B))))
            '(new C ⊕))


;(traces red example1)

;; test reduction rules
; test R-FIELD
(test--> red
         example1
         `((new A ⊕ ) ,class-table))
(test--> red
         example0
         `((new A ⊕ ) ,class-table))

; test R-RINVK

; test R-INVK
(test-->> red
         example2
         `((new A ⊕) ,class-table))
(test-->> red
         example3
         `((new A ⊕) ,class-table))


;(apply-reduction-relation red example1)

(test-results)
