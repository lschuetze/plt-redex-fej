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

;(redex-match fej v '(new E (new A ⊕ ) (new B ⊕) ⊕ ))
;(redex-match fej r '((new F ⊕ ) Z (new A ⊕ ) (new B ⊕)))
;(redex-match fej v '(new E (new A ⊕ ) (new B ⊕) ⊕ ((new F ⊕ ) Z (new A ⊕ ) (new B ⊕))))
; tests fvalue for fvalue metafunction 
(test-equal (term (fvalue ,class-table a (new E (new A ⊕ ) (new B ⊕) ⊕ )))
            '(new A ⊕ ))
(test-equal (term (fvalue ,class-table a (new E (new A ⊕ ) (new B ⊕) ⊕ ((new F ⊕ ) Z (new A ⊕ ) (new B ⊕)))))
            '(new A ⊕ ))
(test-equal (term (fvalue ,class-table a (new E (new A ⊕ ) (new B ⊕) ⊕ ((new F ⊕ ) Y) ((new F ⊕ ) Z (new A ⊕ ) (new B ⊕)))))
            '(new A ⊕ ))

(test-results)
