#!/bin/sh
# -*- scheme -*-
exec guile -e "(@@ (srep cmd srep) main)" -s "$0" "$@"
!#

(define-module (srep cmd srep)
  #:use-module (srep vendor irregex))


(define (main arg0 . args)
  (let ((files (if (< (length args) 2) (list ".") (cdr args)))
	(pattern (car args)))
    (read )
       ))

