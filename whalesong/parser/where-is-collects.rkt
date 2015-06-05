#lang typed/racket/base
(require/typed racket/path
               [normalize-path (Path -> Path)])
(require/typed setup/dirs
               [find-share-dir (-> Path)])

(provide collects-path share-path)

(define collects-path
  (normalize-path
   (let: ([p : Path (find-system-path 'collects-dir)])
     (cond
      [(relative-path? p)
       (define maybe-path (find-executable-path (find-system-path 'exec-file) p))
       (cond
         [(path? maybe-path)
          maybe-path]
         [else
          (error 'collects-path "Could not find collects path")])]
      [else
       p]))))
(define share-path
  (normalize-path
   (let: ([p : Path (find-share-dir)])
     (cond
      [(relative-path? p)
       (define maybe-path (find-executable-path (find-system-path 'exec-file) p))
       (cond
         [(path? maybe-path)
          maybe-path]
         [else
          (error 'collects-path "Could not find share path")])]
      [else
       p]))))
