#lang racket/base

(require "../parameters.rkt"
         "where-is-collects.rkt"
         racket/path
         racket/contract
         racket/list
         racket/runtime-path
         racket/string)



(provide/contract [rewrite-path (complete-path? . -> . (or/c symbol? false/c))]
                  [within-root-path? (complete-path? . -> . boolean?)]
                  [within-whalesong-path? (complete-path? . -> . boolean?)])



(define-runtime-path whalesong-path "..")
(define normal-whalesong-path
  (let ()
    (normalize-path whalesong-path)))




;; The path rewriter takes paths and provides a canonical symbol for
;; it.  Paths located within collects get remapped to collects, those
;; within the compiler directory mapped to "whalesong", those within
;; the root to "root".  If none of these work, we return #f.


;; rewrite-path: path -> (symbol #f)
(define (rewrite-path a-path)
  (let ([a-path (normalize-path a-path)])
    (cond
     [(within-whalesong-path? a-path)
      (string->symbol
       (string-append "whalesong/"
                      (my-path->string
                       (find-relative-path normal-whalesong-path a-path))))]
     [(within-collects? a-path)
      (string->symbol
       (string-append "collects/"
                      (my-path->string
                       (find-relative-path collects-path a-path))))]
     [(within-share? a-path)
      (string->symbol
       (string-append "share/"
                      (my-path->string
                       (find-relative-path share-path a-path))))]
     [(within-root-path? a-path)
      (string->symbol
       (string-append "root/"
                      (my-path->string
                       (find-relative-path (current-root-path) a-path))))]
     [else 
      #f])))



;; Like path->string, but I force the path separator to be '/' rather than the platform
;; specific one.
(define (my-path->string a-path)
  (string-join (map path->string (explode-path a-path)) "/"))


       

(define (within-root-path? a-path)
  (within? (current-root-path) a-path))


(define (within-collects? a-path)
  (within? collects-path a-path))


(define (within-share? a-path)
  (within? share-path a-path))


(define (within-whalesong-path? a-path)
  (within? normal-whalesong-path a-path))


;; within?: normalized-path normalized-path -> boolean
;; Produces true if a-path is within the base.
(define (within? base a-path)
  (let ([rp (find-relative-path base a-path)])
    (cond
     [(equal? rp a-path)
      #f]
     [else
      (let ([chunks (explode-path rp)])
        (cond
         [(empty? chunks)
          #t]
         [(eq? (first chunks) 'up)
          #f]
         [else
          #t]))])))