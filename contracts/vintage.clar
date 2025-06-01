;; VintageVault: Premium Wine Authentication and Provenance Platform
;; Version: 1.0.0
(define-constant ERR-NOT-AUTHORIZED (err u1))
(define-constant ERR-BOTTLE-NOT-FOUND (err u2))
(define-constant ERR-ALREADY-REGISTERED (err u3))
(define-constant ERR-INVALID-STATUS (err u4))
(define-constant ERR-INVALID-VINTAGE-YEAR (err u5))
(define-constant ERR-INVALID-REGION (err u6))
(define-constant ERR-INVALID-STORAGE-CONDITION (err u7))
(define-constant ERR-INVALID-WINE-NAME (err u8))
(define-constant ERR-INVALID-CELLAR-NOTES (err u9))
(define-constant MIN-VINTAGE-YEAR u1800)
(define-data-var next-bottle-id uint u1)
(define-map wine-collection
    uint
    {
        sommelier: principal,
        wine-name: (string-utf8 50),
        cellar-notes: (string-utf8 200),
        region: (string-utf8 15),
        storage-condition: (string-utf8 15),
        cellar-status: (string-utf8 10),
        vintage-year: uint
    }
)
(define-private (validate-region (region (string-utf8 15)))
    (or 
        (is-eq region u"Bordeaux")
        (is-eq region u"Burgundy")
        (is-eq region u"Champagne")
        (is-eq region u"Tuscany")
        (is-eq region u"Napa Valley")
        (is-eq region u"Barossa")
    )
)
(define-private (validate-storage-condition (storage-condition (string-utf8 15)))
    (or 
        (is-eq storage-condition u"Perfect")
        (is-eq storage-condition u"Excellent")
        (is-eq storage-condition u"Good")
        (is-eq storage-condition u"Fair")
        (is-eq storage-condition u"Compromised")
    )
)
(define-private (validate-text-quality (text (string-utf8 200)) (min-length uint) (max-length uint))
    (let 
        (
            (text-length (len text))
        )
        (and 
            (>= text-length min-length)
            (<= text-length max-length)
        )
    )
)
(define-public (register-wine 
    (wine-name (string-utf8 50))
    (cellar-notes (string-utf8 200))
    (region (string-utf8 15))
    (storage-condition (string-utf8 15))
    (vintage-year uint)
)
    (let
        (
            (bottle-id (var-get next-bottle-id))
        )
        (asserts! (validate-text-quality wine-name u3 u50) ERR-INVALID-WINE-NAME)
        (asserts! (validate-text-quality cellar-notes u10 u200) ERR-INVALID-CELLAR-NOTES)
        (asserts! (>= vintage-year MIN-VINTAGE-YEAR) ERR-INVALID-VINTAGE-YEAR)
        (asserts! (validate-region region) ERR-INVALID-REGION)
        (asserts! (validate-storage-condition storage-condition) ERR-INVALID-STORAGE-CONDITION)
        
        (map-set wine-collection bottle-id {
            sommelier: tx-sender,
            wine-name: wine-name,
            cellar-notes: cellar-notes,
            region: region,
            storage-condition: storage-condition,
            cellar-status: u"cellared",
            vintage-year: vintage-year
        })
        (var-set next-bottle-id (+ bottle-id u1))
        (ok bottle-id)
    )
)
(define-public (consume-wine (bottle-id uint))
    (let
        (
            (bottle (unwrap! (map-get? wine-collection bottle-id) ERR-BOTTLE-NOT-FOUND))
        )
        (asserts! (is-eq tx-sender (get sommelier bottle)) ERR-NOT-AUTHORIZED)
        (asserts! (is-eq (get cellar-status bottle) u"cellared") ERR-INVALID-STATUS)
        (ok (map-set wine-collection bottle-id (merge bottle { cellar-status: u"consumed" })))
    )
)
(define-read-only (get-wine (bottle-id uint))
    (ok (map-get? wine-collection bottle-id))
)
(define-read-only (get-sommelier (bottle-id uint))
    (ok (get sommelier (unwrap! (map-get? wine-collection bottle-id) ERR-BOTTLE-NOT-FOUND)))
)