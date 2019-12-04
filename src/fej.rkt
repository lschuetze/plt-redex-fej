#lang racket

(require redex/reduction-semantics)

(provide fej)

(define-language fej

  ; class declarations
  (L (class C ((T f) ...) M ... A ... ))

  ; role declarations
  (A (role R requires Mi ... ((T f) ...) M ... ))

  ; type declarations
  (T
   (C R)
   (((C R) ...) C))

  ; method signatures
  (Mi (T m ((T x) ...)))

  ; types and interfaces
  (Ts
   T
   (Mi ...))

  ; method declarations
  (M (Mi e))

  ; terms / expressions
  (e
   x
   (lkp e f)
   (call e m e ...)
   (new C e ... ⊕ r ...)
   (bind x ... with r ... from y ... e))

  ; values
  (v (new C v ...  r ...))

  ; role instance
  (r (v R v ...))

  ; class table
  (CT (L ...))

  ; evaluation contexts
  (E
   hole
   (lkp E f) ; CR-FIELD
   (call E m e ...) ; CR-INVK
   (call v m v ... E e ...) ; CR-INVK-ARG ;; Fig. 16 is not clear here - take definition of FJ
   (new C v ... E e ...) ; CR-NEW
   )

  (Bool #t #f)

  ; class names
  (B variable-not-otherwise-mentioned) ; type name
  (C variable-not-otherwise-mentioned)
  (D variable-not-otherwise-mentioned)
  ; role names
  (R variable-not-otherwise-mentioned)
  ; field names
  (f variable-not-otherwise-mentioned)
  (g variable-not-otherwise-mentioned)
  ; method names
  (m variable-not-otherwise-mentioned)
  (n variable-not-otherwise-mentioned)
  ; variable names
  (x variable-not-otherwise-mentioned)
  (y variable-not-otherwise-mentioned)
  )
