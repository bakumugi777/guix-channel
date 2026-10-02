(define-module (bakumugi packages desktop)
  #:use-module (guix packages)
  #:use-module (guix download)
  #:use-module (guix gexp)
  #:use-module (guix build-system copy)
  #:use-module (guix build-system gnu)
  #:use-module (guix licenses)
  #:use-module (gnu packages)
  #:use-module (gnu packages bash)
  #:use-module (gnu packages base)
  #:use-module (gnu packages commencement)
  #:use-module (gnu packages pkg-config)
  #:use-module (gnu packages pulseaudio)
  #:use-module (gnu packages networking)
  #:use-module (gnu packages linux)
  #:export (kaname shirube))

(define %kaname-commit "241df7cb4fea620d0b09c764c1199594ce892797")
(define %shirube-commit "343cf7fc7d5a9de057acfeb7d1b9027a8f6be0de")

(define quickshell-package (specification->package "quickshell"))

(define-public kaname
  (package
    (name "kaname")
    (version "0.1.0-241df7c")
    (source (origin
              (method url-fetch)
              (uri (string-append "https://github.com/bakumugi777/Kaname/archive/"
                                  %kaname-commit ".tar.gz"))
              (sha256
               (base32 "15jsg1b4h3aq6mkb9m6bs4ffcjb2hm2l99hvc24kmlcs560iiaxs"))))
    (build-system copy-build-system)
    (arguments
     (list
      #:install-plan
      #~'(("quickshell" "share/kaname/quickshell")
          ("config" "share/kaname/config")
          ("matugen" "share/kaname/matugen")
          ("bin/kaname" "libexec/kaname")
          ("bin/kaname-shell" "libexec/kaname-shell"))
      #:phases
      #~(modify-phases %standard-phases
          (add-after 'install 'install-launchers
            (lambda* (#:key inputs #:allow-other-keys)
              (let* ((out #$output)
                     (bin (string-append out "/bin"))
                     (bash (search-input-file inputs "/bin/bash"))
                     (qs (search-input-file inputs "/bin/quickshell")))
                (mkdir-p bin)
                (call-with-output-file (string-append bin "/kaname")
                  (lambda (port)
                    (format port "#!~a~%export KANAME_QML_DIR=~a/share/kaname/quickshell~%export KANAME_QS_BIN=~a~%exec ~a/libexec/kaname \"$@\"~%"
                            bash out qs out)))
                (chmod (string-append bin "/kaname") #o755)
                (call-with-output-file (string-append bin "/kaname-shell")
                  (lambda (port)
                    (format port "#!~a~%exec ~a -p ~a/share/kaname/quickshell \"$@\"~%"
                            bash qs out)))
                (chmod (string-append bin "/kaname-shell") #o755)))))))
    (inputs (list bash-minimal quickshell-package coreutils))
    (home-page "https://github.com/bakumugi777/Kaname")
    (synopsis "Quickshell radial launcher for Wayland")
    (description "Kaname is the user's Quickshell radial application launcher.")
    (license expat)))

(define-public shirube
  (package
    (name "shirube")
    (version "0.1.0-343cf7f")
    (source (origin
              (method url-fetch)
              (uri (string-append "https://github.com/bakumugi777/Shirube/archive/"
                                  %shirube-commit ".tar.gz"))
              (sha256
               (base32 "14cna2klxw2j9ka608n292bbp5f4m56a3bh5caivvw0y9i25q6az"))))
    (build-system gnu-build-system)
    (arguments
     (list
      #:tests? #f
      #:phases
      #~(modify-phases %standard-phases
          (delete 'configure)
          (replace 'build
            (lambda _
              (invoke "gcc" "-O2" "-std=c11"
                      "helpers/shirube-audio-rms.c" "-lm"
                      "-o" "shirube-audio-rms")))
          (replace 'install
            (lambda* (#:key inputs #:allow-other-keys)
              (let* ((out #$output)
                     (share (string-append out "/share/shirube"))
                     (bin (string-append out "/bin"))
                     (script (string-append bin "/shirube"))
                     (qs (search-input-file inputs "/bin/quickshell")))
                (mkdir-p (string-append share "/helpers"))
                (mkdir-p (string-append share "/matugen/templates"))
                (mkdir-p bin)
                (for-each (lambda (file) (install-file file share))
                          (find-files "." "\\.qml$"))
                (install-file "config.json" share)
                (install-file "shirube-audio-rms" (string-append share "/helpers"))
                (install-file "matugen/templates/shirube-colors.json"
                              (string-append share "/matugen/templates"))
                (copy-file "scripts/shirube.in" script)
                (substitute* script
                  (("@INSTALL_ROOT@") share)
                  (("exec qs ") (string-append "exec " qs " ")))
                (chmod script #o755)))))))
    (native-inputs (list gcc-toolchain))
    (inputs (map specification->package
                 '("quickshell" "coreutils" "gawk" "sed"
                   "network-manager" "pipewire" "wireplumber")))
    (home-page "https://github.com/bakumugi777/Shirube")
    (synopsis "Wayland left-edge light field interface")
    (description "Shirube is the user's Quickshell desktop status interface.")
    (license expat)))
