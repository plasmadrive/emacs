

;; Added by Package.el.  This must come before configurations of
;; installed packages.  Don't delete this line.  If you don't want it,
;; just comment it out by adding a semicolon to the start of the line.
;; You may delete these explanatory comments.

(require 'package)
(add-to-list 'package-archives
  '("melpa" . "http://melpa.milkbox.net/packages/") t)
(package-initialize)

(add-to-list 'custom-theme-load-path "~/.emacs.d/themes/")

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-enabled-themes (quote (ld-dark)))
 '(custom-safe-themes
   (quote
    ("ec0c9d1715065a594af90e19e596e737c7b2cdaa18eb1b71baf7ef696adbefb0" default)))
 '(package-selected-packages
   (quote
    (flycheck-demjsonlint flycheck json-mode string-inflection cql-mode feature-mode magit haskell-mode elpy mustache-mode yaml-mode cucumber-goto-step exec-path-from-shell go-complete go-mode))))
;;set up json linting
(require 'flycheck-demjsonlint)


(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )


(defun set-exec-path-from-shell-PATH ()
  (let ((path-from-shell (replace-regexp-in-string
                          "[ \t\n]*$"
                          ""
                          (shell-command-to-string "$SHELL --login -i -c 'echo $PATH'"))))
    (setenv "PATH" path-from-shell)
    (setq eshell-path-env path-from-shell) ; for eshell users
    (setq exec-path (split-string path-from-shell path-separator))))

(when window-system (set-exec-path-from-shell-PATH))

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

(setq load-path (cons "/usr/local/share/emacs/site-lisp/tidal" load-path))
(require 'tidal)
(setq tidal-interpreter "/usr/local/bin/ghci")


;; Git
(global-set-key (kbd "C-x g") 'magit-status)
