;; Learning Incentive Token

;; Define token
(define-fungible-token learn-token)

;; Constants
(define-constant contract-owner tx-sender)
(define-constant reward-amount u100)

;; Mint tokens as learning reward
(define-public (reward-learning (student principal))
  (ft-mint? learn-token reward-amount student)
)

;; Transfer tokens  
(define-public (transfer (amount uint) (sender principal) (recipient principal))
  (ft-transfer? learn-token amount sender recipient)
)
