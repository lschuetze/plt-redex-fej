#lang racket

(require "fej.rkt"
         "fej-meta.rkt"
         redex/reduction-semantics)

(provide  )

(define red
  (reduction-relation
   fej
   #:domain (t CT)

   (--> )
   ))
