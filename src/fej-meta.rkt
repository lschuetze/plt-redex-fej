#lang racket

(require "fej.rkt"
         redex/reduction-semantics)

(provide class-lookup
         role-lookup
         role-in
         fields
         method-in
         mbody
         subst
         subst-many)

; class table lookup
(define-metafunction fej
  class-lookup : CT C -> any

  [(class-lookup (L_0 ... (class C any ...) L_1 ...) C)
   (class C any ...)]

  [(class-lookup any C) #f])

(define-metafunction fej
  role-in : L R -> any

  [(role-in (class C any ... A_0 ... (role R requires Mi ... ((T f) ...) M ...) A_1 ...) R)
   (role R requires Mi ... ((T f) ...) M ...)]

  [(role-in any R) #f])

(define-metafunction fej
  role-lookup : CT C R -> any

  [(role-lookup (L_0 ... (class C any ...) L_1 ...) C R)
   (role R requires Mi ... ((T f) ...) M ...)
   (where (role R requires Mi ... ((T f) ...) M ...)
          (role-in (class C any ...) R))]

  [(role-lookup any C R) #f])

; fig. 9: field lookup
; CT ((C_1 R) C_2) is undefined
(define-metafunction fej
  fields : CT T -> ((T f) ...)

  [(fields CT (() C))
   ((T f) ...)
   (where (class C ((T f) ...) any ...)
          (class-lookup CT C))]

  [(fields CT (C R))
   ((T f) ...)
   (where (role R requires Mi ... ((T f) ...) M ...)
          (role-lookup CT C R))]
  )

; fig. 11: method type lookup
;(define-metafunction fej
;  mtype : CT m Ts -> any
;
;  [ ; m is defined in C
;   (mtype CT m C)
;   (where)
;   ]
;  )

; method signature in method list?
(define-metafunction fej
  method-in : m M ... -> any

  [(method-in m M_0 ... ((T m ((T_1 x) ...)) e) M_1 ...)
   ((T m ((T_1 x) ...)) e)]

  [(method-in m any ...) #f])

; fig. 12 : method body lookup
(define-metafunction fej
  mbody : CT m T -> ((x ...) e T)

  ; MB-CLASS
  [(mbody CT m (() C))
   ((x ...) e (() C))
   (where (class C ((T f) ...) M ... A ...)
          (class-lookup CT C))
   (where ((T_0 m ((T_1 x) ...)) e)
          (method-in m M ...))]

  ; MB-ROLE
  [(mbody CT m (((C_0 R_0) (C_1 R_1) ...) C_n))
   ((x ...) e (C_0 R_0))
   (where (role R_0 requires Mi ... ((T_0 f_0) ...) M ...)
          (role-lookup CT C_0 R_0))
   (where ((T_1 m ((T_2 x) ...)) e)
          (method-in m M ...))]

  ; MB-MIXIN
  [(mbody CT m (((C_0 R_0) (C_1 R_1) ...) C_n))
   (mbody CT m (((C_1 R_1) ...) C_n))])

; substitute variable with value
(define-metafunction fej
  subst : x v any -> any

  ; single variable [v/x]x
  [(subst x v x) v]

  ; distribute subst [v/x]e
  [(subst x v (any ...))
   ((subst x v any) ...)]

  ; do nothing
  [(subst x v any) any])

; substitute variables with values
(define-metafunction fej
  subst-many : (x ...) (v ...) any -> any

  [(subst-many (x_1 x_2 ...) (v_1 v_2 ...) any)
   (subst x_1 v_1 (subst-many (x_2 ...) (v_2 ...) any))]

  [(subst-many () () any) any])
