

(use r7rs)
(define-library (options-formulae-chkn)
  (import (scheme)
          (scheme base)
          (prefix other-module other-module:)
          (prefix clojurian-syntax clj:)
          (prefix statistics stats:))
  (export baz test-it)
  (begin
    
    (define baz 1)

    (define (add-some-stuff)
      (+ baz other-module:bar))

    (define (get-d1 underlying-price strike-price time-to-expiry-in-yrs risk-free-rate volatility)
      (clj:->
       (clj:-> (log (/ underlying-price strike-price))
               (+ (clj:->
                   (clj:-> risk-free-rate
                           (+ (clj:-> volatility
                                  (* volatility)
                                  (/ 2.0))))
                   (* time-to-expiry-in-yrs))))
       (/ (* volatility (clj:-> time-to-expiry-in-yrs inexact sqrt)))))

    (define (bs-price call-or-put underlying-price strike-price time-to-expiry-in-yrs risk-free-rate volatility)
      (let* ((dividend-yield 0.0)
             (d1 (get-d1 underlying-price strike-price time-to-expiry-in-yrs risk-free-rate volatility))
             (d2 (clj:-> d1
                         (- (* volatility (clj:-> time-to-expiry-in-yrs inexact sqrt))))))
        (case call-or-put
          ('call (clj:->
                  (clj:-> underlying-price
                          (* (exp (* -1 dividend-yield time-to-expiry-in-yrs)))
                          (* (stats:phi d1)))
                  (- (clj:-> strike-price
                             (* (exp (* -1 risk-free-rate time-to-expiry-in-yrs)))
                             (* (stats:phi d2))))))
          ('put (clj:->
                 (clj:-> strike-price
                         (* (exp (* -1 dividend-yield time-to-expiry-in-yrs)))
                         (* (stats:phi (* -1 d2))))
                 (- (clj:-> underlying-price
                            (* (exp (* -1 dividend-yield time-to-expiry-in-yrs)))
                            (* (stats:phi (* -1 d1))))))))))

    (define (bs-vega call-or-put underlying-price strike-price time-to-expiry-in-yrs risk-free-rate volatility)
      (let ((d1 (get-d1 underlying-price strike-price time-to-expiry-in-yrs risk-free-rate volatility)))
        (* underlying-price
           (clj:-> time-to-expiry-in-yrs inexact sqrt)
           (stats:normal-pdf d1 0 1))))

    (define (find-volatility target-value call-or-put underlying-price strike-price time-to-expiry-in-yrs risk-free-rate)
      (let* ((precision 0.00001)
             (sigma 0.5))
        (letrec ((loopity (lambda (result iter-count)
                            (let* ((price (bs-price call-or-put underlying-price strike-price
                                                    time-to-expiry-in-yrs risk-free-rate result))
                                   (vega (bs-vega call-or-put underlying-price strike-price
                                                  time-to-expiry-in-yrs risk-free-rate result))
                                   (diff (- target-value price)))
                              (if (or (< (abs diff) precision) (>= iter-count 100))
                                  result
                                  (loopity (+ result (/ diff vega)) (+ iter-count 1)))))))
          (loopity 0.5 0))))

    (define (test-it)
      (find-volatility 17.5 'call 586.08 585 (/ 40 365) 0.0002))))
