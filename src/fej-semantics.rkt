#lang racket
(require "fej.rkt"
         "fej-meta.rkt"
         redex/reduction-semantics)

(provide  fvalue
          red
          cp)

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

(define-metafunction fej
  cp : v v -> v

  [(cp (new D v_d ... ⊕ ((new C_0 v_c ... ⊕ ) R_0 v_r ... ) ((new C_1 v_c1 ... ⊕ ) R_1 v_r1 ...  ) ... ))
   (cp (new D v_d ... ⊕ ((new C_1 v_c1 ... ⊕ ) R_1 v_r1 ...  ) ... ))]

  [(cp (new D v_d ... ⊕ ((new C v_c ... ⊕ ) R v_r ... ) ((new C_1 v_c1 ... ⊕ ) R_1 v_r1 ...  ) ... ))
   (new D v_d ... ⊕ ((new C_1 v_c1 ... ⊕ ) R_1 v_r1 ...  ) ... )]

  [(cp v any) v]
  )

; fig. 16 dynamic semantics
(define red
  (reduction-relation
   fej
   #:domain (e CT)
   ;R-FIELD
   (--> ((in-hole E (lkp (new C v_0 ... ⊕ (v_1 R v_2 ...) ...) f_i)) CT)
        ((in-hole E v_i) CT)
        "(R-FIELD)"
        (where v_i (fvalue CT f_i (new C v_0 ... ⊕ (v_1 R v_2 ...) ...))))

   ;R-RINVK
   (--> ((in-hole E (call v_0 m v_1 ...)) CT)
        ((in-hole E (subst-many (x ...) (v_1 ...)
                                (subst super
                                       (cp v_0 (new D e_0 ... ⊕ ((new C_0 e_1 ... ⊕) R_0 e_2 ...)))
                                       (subst thisC (new C_0 e_1 ... ⊕)
                                              (subst this v_0 e_m))))) CT)
         "(R-RINVK)"
         (where ((x ...) e_m (new D e_0 ... ⊕ ((new C_0 e_1 ... ⊕) R_0 e_2 ...))) (mbody CT m v_0)))

   ;R-INVK
   ;   (--> ((in-hole E (call (new C v_0 ... ⊕ (v_1 R v_2 ...) ...) m v_3 ...)) CT)
   (--> ((in-hole E (call v_0 m v_1 ...)) CT)
        ((in-hole E (subst-many (x ...) (v_1 ...)
                                (subst this v_0 e_0))) CT)
        "(R-INVK)"
        (where ((x ...) e_0 v_0) (mbody CT m v_0)))))

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
