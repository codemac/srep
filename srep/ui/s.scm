(define-module (srep ui s)
  #:use-module (srfi srfi-1)
  #:use-module (srfi srfi-37)
  #:use-module (ice-9 match)
  #:use-module (ice-9 format)
  #:use-module (ice-9 ftw)
  #:use-module (srep config)
  #:use-module (srep ui)
  #:export (srep-s))

(define (show-help)
  (format #t "Usage: srep s [OPTION] <irregex to find> <irregex to fill in> -- [files to operate on]
Search and replace a regex, much like sed's s command.~%")
  (newline)
  (show-common-options-help)
  (newline)
  (display "
  -h, --help             display this help and exit")
  (display "
  -V, --version          display version and exit")
  (newline))

(define %options
  (cons* (option '(#\h "help") #f #f
                 (lambda _
                   (show-help)
                   (exit 0)))
         (option '(#\V "version") #f #f
                 (lambda _
                   (show-version-and-exit "haunt serve")))
         %common-options))

(define %default-options
  (cons ;'(port . 8080)
        %default-common-options))

(define (srep-s . args)
  (let* ((opts     (simple-args-fold args %options %default-options))
	 (config   (assq-ref opts 'config)))

    (format #t "This doesn't work yet!"))
