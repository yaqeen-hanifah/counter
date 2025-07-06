;; An on-chain counter that stores a count for each individual

(define-constant MAX-COUNT u100)

;; Define a map data structure
(define-map counters
  principal
  uint
)

(define-data-var total-ops unit u0)

;; Function to retrieve the count for a given individual
(define-read-only (get-count (who principal))
  (default-to u0 (map-get? counters who))
)

(define-read-only (get-total-operations)
  (var-get total-ops)
)

(define-private (update-total-ops)
  (var-set total-ops (+ (var-get total-ops) u1))
)

(define-public (count-up)
  (let ((current-count (get-count tx-sender)))
    (asserts! (< current-count MAX-COUNT) (err u1))
    (update-total-ops)
    (ok (map-set counters tx-sender (+ current-count u1)))
  )
)

(define-public (count-down)
  (let ((current-count (get-count tx-sender)))
    (asserts! (> current-count 0) (err u2))
    (update-total-ops)
    (ok (map-set counters tx-sender (- current-count u1)))
  )
)

(define-public (reset-count)
  (begin
    (update-total-ops)
    (ok (map-set counters tx-sender u0))
  )
)
