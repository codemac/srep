;;; srep

;;; Commentary:
;;
;; srep cli.
;;
;;; Code:

(define-module (srep ui)
  #:use-module (ice-9 format)
  #:use-module (ice-9 ftw)
  #:use-module (ice-9 match)
  #:use-module (srfi srfi-1)
  #:use-module (srfi srfi-26)
  #:use-module (srfi srfi-37)
  #:export (program-name
            show-version-and-exit
            simple-args-fold
            %common-options
            %default-common-options
            show-common-options-help
            leave
            string->number*
            load-config
            option?
            srep-main))

(define commands
  '("s" "g"))

(define program-name (make-parameter 'srep))

(define (show-srep-help)
  (format #t "Usage: srep COMMAND ARGS...
Run COMMAND with ARGS.~%~%")
  (format #t "COMMAND must be one of the sub-commands listed below:~%~%")
  (format #t "~{   ~a~%~}" (sort commands string<?)))

(define (show-srep-usage)
  (format #t "Try `srep --help' for more information.~%")
  (exit 1))

(define (show-version-and-exit name)
  (format #t "~a ~a
Copyright (C) 2015 the srep authors
License GPLv3+: GNU GPL version 3 or later <http://gnu.org/licenses/gpl.html>
This is free software: you are free to change and redistribute it.
There is NO WARRANTY, to the extent permitted by law.~%"
          name %srep-version)
  (exit 0))

(define (leave format-string . args)
  "Display error message and exist."
  (apply format (current-error-port) format-string args)
  (newline)
  (exit 1))

(define (string->number* str)
  "Like `string->number', but error out with an error message on failure."
  (or (string->number str)
      (leave "~a: invalid number" str)))

(define (simple-args-fold args options default-options)
  (args-fold args options
             (lambda (opt name arg result)
               (leave "~A: unrecognized option" name))
             (lambda (arg result)
               (leave "~A: extraneuous argument" arg))
             default-options))

(define %common-options
  (list (option '(#\c "config") #t #f
                (lambda (opt name arg result)
                  (alist-cons 'config arg result)))))

(define %default-common-options
  '((config . "srep.scm")))

(define (show-common-options-help)
  (display "
  -c, --config           configuration file to load"))

(define (option? str)
  (string-prefix? "-" str))

(define* (load-config file-name)
  "Load configuration from FILE-NAME."
  (if (file-exists? file-name)
      (let ((obj (load (absolute-file-name file-name))))
        (if (site? obj)
            obj
            (leave "configuration object must be a site, got: ~a" obj)))
      (leave "configuration file not found: ~a" file-name)))

(define (run-srep-command command . args)
  (let* ((module
          (catch 'misc-error
            (lambda ()
              (resolve-interface `(srep ui ,command)))
            (lambda -
              (format (current-error-port) "~a: invalid subcommand~%" command)
              (show-srep-usage))))
         (command-main (module-ref module (symbol-append 'srep- command))))
    (parameterize ((program-name command))
      (apply command-main args))))

(define* (srep-main arg0 . args)
  ;; Add srep site directory to Guile's load path so that user's can
  ;; easily import their own modules.
  (add-to-load-path (getcwd))
  (setlocale LC_ALL "")
  (match args
    (()
     (show-srep-usage))
    ((or ("-h") ("--help"))
     (show-srep-help))
    (("--version")
     (show-version-and-exit "srep"))
    (((? option? opt) _ ...)
     (format (current-error-port)
             "srep: unrecognized option '~a'~%"
             opt)
     (show-srep-usage))
    ((command args ...)
     (apply run-srep-command (string->symbol command) args))))
