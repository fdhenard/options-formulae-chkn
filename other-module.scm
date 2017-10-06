(use r7rs)
(define-library (other-module)
  (import (scheme base))
  (export bar)
  (begin

    (define bar 2)))
