;;; srep
;;;
;;; Copyright © 2015 Jeff Mickey <j@codemac.net>
;;
;; GNU Guix development package.  To build and install, run:
;;
;;   guix package -f guix.scm
;;
;; To use as the basis for a development environment, run:
;;
;;   guix environment -l guix.scm
;;
;;; Code:

(use-modules (guix packages)
             (guix licenses)
             (guix git-download)
             (guix build-system gnu)
             (gnu packages)
             (gnu packages autotools)
             (gnu packages guile)
             (gnu packages texinfo))

(package
  (name "srep")
  (version "0.1")
  (source (origin
            (method git-fetch)
            (uri (git-reference
                  (url "git://github.com/codemac/srep.git")
                  (commit "master")))
            (sha256
             (base32
              "0gx1ijbz9k0lcgmv82x49nam1i7r16sqx5v8hbpafkiqyxkm2v1k"))))
  (build-system gnu-build-system)
  (arguments
   '(#:phases
     (modify-phases %standard-phases
       (add-after 'unpack 'bootstrap
         (lambda _ (zero? (system* "sh" "autogen.sh")))))))
  (native-inputs
   `(("autoconf" ,autoconf)
     ("automake" ,automake)
     ("texinfo" ,texinfo)))
  (inputs
   `(("guile" ,guile-2.0)))
  (propagated-inputs
   `(("guile-irregex" ,guile-irregex)))
  (synopsis "Scheme-like grep")
  (description "sgrep is a tool for using irregex syntax for things
like sed and grep. Currently only grep is supported.")
  (home-page "http://github.com/codemac/srep")
  (license gpl3+))
