
;;; init.el --- Initialization file for Emacs
;;; Commentary: Emacs Startup File --- initialization for Emacs

;; Added by Package.el.  This must come before configurations of
;; installed packages.  Don't delete this line.  If you don't want it,
;; just comment it out by adding a semicolon to the start of the line.
;; You may delete these explanatory comments.


;;;Code

;;; Commentary:
;;

(require 'tls)

(require 'package)
;;; Code:

(setq package-enable-at-startup nil)
(add-to-list 'package-archives
         '("melpa" . "https://melpa.org/packages/"))
 (add-to-list 'package-archives
         '("gnu" . "https://elpa.gnu.org/packages/"))
 (add-to-list 'package-archives
       '("melpa3" . "http://www.mirrorservice.org/sites/stable.melpa.org/packages/"))

(package-initialize)

(add-to-list 'custom-theme-load-path "~/.emacs.d/themes/")

;;; Add all subdirectories of the packages directory to the loadpath
(let ((default-directory  "~/.emacs.d/packages/"))
  (normal-top-level-add-subdirs-to-load-path))

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-enabled-themes '(ld-dark))
 '(custom-safe-themes
   '("ec0c9d1715065a594af90e19e596e737c7b2cdaa18eb1b71baf7ef696adbefb0" default))
 '(package-selected-packages
   '(pandoc-mode web-mode terraform-mode pyvenv markdown-mode sr-speedbar json-navigator smart-shift highlight-indent-guides flycheck-demjsonlint flycheck json-mode string-inflection cql-mode feature-mode magit haskell-mode elpy mustache-mode yaml-mode cucumber-goto-step exec-path-from-shell go-complete go-mode)))





(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )


;; Added for MacOs to make sure Emacs uses the proper $PATH
(defun set-exec-path-from-shell-PATH ()
  (let ((path-from-shell (replace-regexp-in-string
                          "[ \t\n]*$"
                          ""
                          (shell-command-to-string "$SHELL --login -i -c 'echo $PATH'"))))
    (setenv "PATH" path-from-shell)
    (setq eshell-path-env path-from-shell) ; for eshell users
    (setq exec-path (split-string path-from-shell path-separator))))

(when window-system (set-exec-path-from-shell-PATH))

;;;GO related
(setenv "GOPATH" "/Users/g/Workspace/Go")

(add-to-list 'exec-path "/Users/g/Workspace/Go/bin:")
(add-hook 'before-save-hook 'gofmt-before-save)

(defun auto-complete-for-go ()
  (auto-complete-mode 1))
(add-hook 'go-mode-hook 'auto-complete-for-go)

(add-to-list 'load-path "/Users/g/.emacs.d/go")
(require 'go-autocomplete)
(require 'auto-complete-config)
(ac-config-default)

(with-eval-after-load 'go-mode
  (require 'go-autocomplete))


(defun my-go-mode-hook ()
  ; Call Gofmt before saving
  (add-hook 'before-save-hook 'gofmt-before-save)
  ; Customize compile command to run go build
  (if (not (string-match "go" compile-command))
      (set (make-local-variable 'compile-command)
           "go build -v && go test -v && go vet"))
  ; Godef jump key binding
  (local-set-key (kbd "M-.") 'godef-jump)
  (local-set-key (kbd "M-*") 'pop-tag-mark)
)
(add-hook 'go-mode-hook 'my-go-mode-hook)


;; Tidal cycles configuration

;;(setq load-path (cons "/usr/local/share/emacs/site-lisp/tidal" load-path))
;;(require 'tidal)
;;(setq tidal-interpreter "/usr/local/bin/ghci")


;; Git
(global-set-key (kbd "C-x g") 'magit-status)

;;set up linting
(add-hook 'after-init-hook #'global-flycheck-mode)
;;set up json linting
;;(require 'flycheck-demjsonlint)

;; indentation highlighting for the highlight indent mode - only
;;(set-face-background 'highlight-indentation-face "#FFFF00")
;;(set-face-background 'highlight-indentation-current-column-face "#FFFF00")

;;set json indent to 2
(add-hook 'json-mode-hook
          (lambda ()
            (make-local-variable 'js-indent-level)
            (setq js-indent-level 2)))
;; (eval-after-load 'json-mode
;;   '(progn
;;      (add-to-list 'smart-shift-mode-alist
;;                   '(major-mode-or-derived-mode . customize-base-offset))))

(require 'hideshow)
(require 'sgml-mode)
(require 'nxml-mode)

(add-to-list 'hs-special-modes-alist
             '(nxml-mode
               "<!--\\|<[^/>]*[^/]>"
               "-->\\|</[^/>]*[^/]>"

               "<!--"
               sgml-skip-tag-forward
               nil))



(add-hook 'nxml-mode-hook 'hs-minor-mode)

;; optional key bindings, easier than hs defaults
(define-key nxml-mode-map (kbd "C-c h") 'hs-toggle-hiding)

;;; flycheck swagger

(require 'flycheck-swagger-tools)

(provide 'init)


;;(setenv "WORKON_HOME" "/anaconda3/envs/")
;;(pyenv-mode 1)


;;; init.el ends here
