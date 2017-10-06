

(use r7rs)
(define-library (options-formulae-chkn)
  (import (scheme base)
          (prefix other-module other-module:))
  (export baz)
  (begin
    
    (define baz 1)

    (define (add-some-stuff)
      (+ baz other-module:bar))

    ))
