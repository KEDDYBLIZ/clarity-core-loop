;; Course Management Contract

;; Constants
(define-constant contract-owner tx-sender)
(define-constant err-owner-only (err u100))
(define-constant err-not-found (err u101))
(define-constant err-already-enrolled (err u102))

;; Data structures
(define-map courses 
  { course-id: uint }
  { 
    title: (string-ascii 100),
    instructor: principal,
    price: uint,
    max-students: uint,
    enrolled-count: uint,
    active: bool
  }
)

(define-map enrollments
  { course-id: uint, student: principal }
  {
    enrolled-at: uint,
    completed: bool
  }
)

;; Counter for course IDs
(define-data-var next-course-id uint u1)

;; Create new course
(define-public (create-course 
  (title (string-ascii 100))
  (price uint)
  (max-students uint))
  (let ((course-id (var-get next-course-id)))
    (map-insert courses
      { course-id: course-id }
      {
        title: title,
        instructor: tx-sender,
        price: price, 
        max-students: max-students,
        enrolled-count: u0,
        active: true
      }
    )
    (var-set next-course-id (+ course-id u1))
    (ok course-id)
  )
)

;; Enroll in course
(define-public (enroll (course-id uint))
  (let (
    (course (unwrap! (map-get? courses {course-id: course-id}) err-not-found))
    (enrollment-exists (map-get? enrollments {course-id: course-id, student: tx-sender}))
  )
    (asserts! (not enrollment-exists) err-already-enrolled)
    (asserts! (< (get enrolled-count course) (get max-students course)) (err u103))
    
    (map-insert enrollments
      {course-id: course-id, student: tx-sender}
      {
        enrolled-at: block-height,
        completed: false
      }
    )
    
    (map-set courses 
      {course-id: course-id}
      (merge course {enrolled-count: (+ (get enrolled-count course) u1)})
    )
    
    (ok true)
  )
)
