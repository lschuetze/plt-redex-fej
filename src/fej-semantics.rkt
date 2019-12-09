#lang racket

(require "fej.rkt"
         "fej-meta.rkt"
         redex/reduction-semantics)

(provide  fvalue
          red)

; fig. 10 field value lookup
(define-metafunction fej
  fvalue : CT f v -> v

  ; FV-CLASS
  [(fvalue CT f_i (new C v ... ⊕ ))
   v_i
   (where ((T_1 f_1) ...) (fields CT (() C)))
   (where/hidden ((f_0 v_0) ... (f_i v_i) (f_i+1 v_i+1) ...)
                 ((f_1 v) ...))]

  ; FV-ROLE
  [(fvalue CT f_i (new D v_d ... ⊕ ((new C v_c ... ⊕ ) R v_r ... ) ((new C_1 v_c1 ... ⊕ ) R_1 v_r1 ...  ) ... ))
   v_ri
   (where ((T_r f_r) ...) (fields CT (C R)))
   (where/hidden ((f_0 v_r0) ... (f_i v_ri) (f_i+1 v_i+1) ...)
                 ((f_r v_r) ...))]

  ; FV-ROLE1
  [(fvalue CT f_i (new D v_d ... ⊕ ((new C v_c ... ⊕ ) R v_r ... ) ((new C_1 v_c1 ... ⊕ ) R_1 v_r1 ...  ) ... ))
   (fvalue CT f_i (new D v_d ... ⊕ ((new C_1 v_c1 ... ⊕ ) R_1 v_r1 ...  ) ... ))])

; fig. 16 dynamic semantics
(define red
  (reduction-relation
   fej
   #:domain (t CT)

   ; R-FIELD
   (--> ((in-hole E (lkp (new C v ... ⊕ r ...) f_i)) CT)
        ((in-hole E w) CT)
        "(R-FIELD)"
        (where (w) (fvalue CT f_i (new C v ... ⊕ r ...))))
   ))


(define-judgment-form fej

  ; all constituents are inputs
  #:mode (<: I I I)
  #:contract (<: CT Ts Ts)
  ; Ts ::= C.R | (C.R)*::C | Mi*

  ; S-REFLft
  [-------------
   (<: CT Ts Ts)]

  #|
  This is a combination of
  S-TRANS and S-STRUCT
  |#
  ;[(where () ())
  ; -------------
  ; ]
  )
