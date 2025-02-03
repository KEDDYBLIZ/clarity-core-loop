;; Certificate NFT Contract

;; Define NFT
(define-non-fungible-token certificate uint)

;; Constants  
(define-constant contract-owner tx-sender)

;; Data vars
(define-data-var certificate-id uint u1)

;; Data maps
(define-map certificate-data
  uint 
  {
    course-id: uint,
    student: principal,
    issued-at: uint,
    metadata-uri: (string-utf8 256)
  }
)

;; Issue certificate
(define-public (issue-certificate 
  (course-id uint)
  (student principal) 
  (metadata-uri (string-utf8 256)))
  
  (let ((cert-id (var-get certificate-id)))
    ;; Mint NFT
    (nft-mint? certificate cert-id student)
    
    ;; Store metadata
    (map-insert certificate-data
      cert-id
      {
        course-id: course-id,
        student: student,
        issued-at: block-height,
        metadata-uri: metadata-uri
      }
    )
    
    (var-set certificate-id (+ cert-id u1))
    (ok cert-id)
  )
)
