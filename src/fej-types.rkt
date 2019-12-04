#lang racket
(require redex/reduction-semantics
         "fej.rkt")

(provide fej-types)

(define-extended-language fej-types fej
  ; typing environment
  (Γ ((x T) ...))
  )

(define-judgment-form fej-types

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
