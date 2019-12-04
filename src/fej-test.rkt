#lang racket

(require "fej.rkt"
         "fej-meta.rkt"
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

(define term-fzy (term (class F ()
                     (role Z requires ((() A) m (((() A) x)))
                           (((() A) a) ((() B) b)))
                     (role Y requires ((() A) m (((() A) x)))
                           () (((() A) o (((() A) x))) x))
                         )))
(define term-m (term (((C R) m (((C R) x))) x)))

;(redex-match fej L term0)
;(redex-match fej CT class-table)
;(redex-match fej CT '((class A ())))
;(redex-match fej (T f) '((A) a))
;(redex-match fej (class C any ...) '(class A ()))
;(redex-match fej L '(class F () (role Z requires ((A) m (((A) x))) (((A) a) ((B) b)))))
;(redex-match fej (A_0 ... role R any ... A_1 ...) '(role Z requires ((A) m (((A) x))) (((A) a) ((B) b))))
;(redex-match fej (class C any ... A_0 ... (role R requires Mi ... ((T f) ...) M ...)  A_1 ...)
;             '(class F () (role Z requires ((A) m (((A) x))) (((A) a) ((B) b)))))

; test metafunction class-lookup
(test-equal (term (class-lookup ,class-table A))
            '(class A ()))
(test-equal (term (class-lookup ,class-table E))
            '(class E (((() A) a) ((() B) b))))
(test-equal (term (class-lookup ,class-table F))
            `,term-fzy)

; test metafunction role-in
(test-equal (term (role-in ,term-fzy Z))
            '(role Z requires ((() A) m (((() A) x))) (((() A) a) ((() B) b))))

; test metafunction role-lookup
(test-equal (term (role-lookup ,class-table F Z))
            '(role Z requires ((() A) m (((() A) x))) (((() A) a) ((() B) b))))

; test metafunction fields
(test-equal (term (fields ,class-table (() E)))
            '(((() A) a) ((() B) b)))
(test-equal (term (fields ,class-table (F Z)))
            '(((() A) a) ((() B) b)))

; test metafunction method-in
(test-equal (term (method-in m (((C R) n (((C R) x))) x)))
            #f)
(test-equal (term (method-in m )) ;empty
            #f)
(test-equal (term (method-in m ,term-m))
            `,term-m)
(test-equal (term (method-in m (((C R) n (((C R) x))) x) (((C R) m (((C R) x))) x)))
            '(((C R) m (((C R) x))) x))
(test-equal (term (method-in m (((C R) m (((C R) x))) x) (((C R) n (((C R) x))) x)))
            '(((C R) m (((C R) x))) x))
(test-equal (term (method-in m (((C R) n (((C R) x))) x) (((C R) m (((C R) x))) x) (((C R) o (((C R) x))) x)))
            '(((C R) m (((C R) x))) x))
(test-equal (term (method-in m (((C R) n (((C R) x))) x) (((C R) o (((C R) x))) x)))
            #f)

;(traces (term (mbody ,class-table m ((F Z) (F Y) B))))
; test metafunction mbody
(test-equal (term (mbody ,class-table m (() B)))
            '((x) x (() B)))
(test-equal (term (mbody ,class-table m (((F Y)) B)))
            '((x) x (() B)))
(test-equal (term (mbody ,class-table m (((F Y) (F Z)) B)))
            '((x) x (() B)))
(test-equal (term (mbody ,class-table o (((F Y)) B)))
            '((x) x (F Y)))
(test-equal (term (mbody ,class-table o (((F Z) (F Y)) B)))
            '((x) x (F Y)))

(test-results)
