#lang racket/base
(require "../version-case/version-case.rkt"
         "../logger.rkt"
         racket/file
         (prefix-in whalesong: "../version.rkt")
         (for-syntax racket/base))

(version-case
  [(and (version<= "5.1.1" (version))
        (version< (version) "5.1.1.900"))
   (begin
     (log-debug "Using 5.1.1 bytecode parser")
     (require "parse-bytecode-5.1.1.rkt")
     (provide (except-out (all-from-out "parse-bytecode-5.1.1.rkt")
                          parse-bytecode)))]
  [(and (version<= "5.1.1.900" (version))
        (version< (version) "5.2"))
   (begin
     (log-debug "Using 5.1.2 bytecode parser")
     (require "parse-bytecode-5.1.2.rkt")
     (provide (except-out (all-from-out "parse-bytecode-5.1.2.rkt")
                          parse-bytecode)))]
  [(and (version<= "5.2" (version))
        (version< (version) "5.2.0.900"))
   (begin
     (log-debug "Using 5.2 bytecode parser")
     (require "parse-bytecode-5.2.rkt")
     (provide (except-out (all-from-out "parse-bytecode-5.2.rkt")
                          parse-bytecode)))]
  [(and (version<= "5.2.0.900" (version))
        (version< (version) "5.2.900"))
   (begin
     (log-debug "Using 5.2.1 bytecode parser")
     (require "parse-bytecode-5.2.1.rkt")
     (provide (except-out (all-from-out "parse-bytecode-5.2.1.rkt")
                          parse-bytecode)))]
  [(and (version<= "5.2.900" (version))
        (version< (version) "5.3.3.7"))
   (begin
     (log-debug "Using 5.3 bytecode parser")
     (require "parse-bytecode-5.3.rkt")
     (provide (except-out (all-from-out "parse-bytecode-5.3.rkt")
                          parse-bytecode)))]
  [(and (version<= "5.3.3.7" (version))
        (version< (version) "6.1.1"))
   (begin
     (log-debug "Using 5.3.3.7 bytecode parser")
     (require "parse-bytecode-5.3.3.7.rkt")
     (provide (except-out (all-from-out "parse-bytecode-5.3.3.7.rkt")
                          parse-bytecode)))]
  [(version>= (version) "6.1.1")
   (begin
     (log-debug "Using 6.1.1 bytecode parser")
     (require "parse-bytecode-6.1.1.rkt")
     (provide (except-out (all-from-out "parse-bytecode-6.1.1.rkt")
                          parse-bytecode)))]
  [else
   (error 'parse-bytecode "Whalesong doesn't have a compatible parser for Racket ~a" (version))])


(provide (rename-out [my-parse-bytecode parse-bytecode]))


(define (my-parse-bytecode x)
  (cond
    [(path? x)
     (parse-bytecode x)]
    [else
     (parse-bytecode x)]))
