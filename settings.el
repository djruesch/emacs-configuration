(setq user-mail-address "djruesch@gmail.com")
(setq user-full-name  "Del Ruesch")
(setq add-log-mailing-address "reports.djruesch@gmail.com")

;; Location things
(setq calendar-latitude -34.38668232390036)
(setq calendar-longitude -70.84974847123787)
(setq calendar-location-name "Rengo, Chile")

(defconst emacs-start-time (current-time))

(setq debug-on-error t)
(setq debug-on-quit t)

;; Show me more log messages
(setq message-log-max 500)

;;(checkdoc)
;;(byte-compile-file (buffer-file-name))
;;(package-buffer-info)

(let ((default-directory  "~/.emacs.d/site-lisp/"))
  (normal-top-level-add-subdirs-to-load-path))

(defvar bootstrap-version)
(let ((bootstrap-file
       (expand-file-name "straight/repos/straight.el/bootstrap.el" user-emacs-directory))
      (bootstrap-version 5))
  (unless (file-exists-p bootstrap-file)
    (with-current-buffer
        (url-retrieve-synchronously
         "https://raw.githubusercontent.com/raxod502/straight.el/develop/install.el"
         'silent 'inhibit-cookies)
      (goto-char (point-max))
      (eval-print-last-sexp)))
  (load bootstrap-file nil 'nomessage))

(straight-use-package 'use-package)
(setq straight-use-package-by-default t)

(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/")
(add-to-list 'package-archives '("org" . "https://orgmode.org/elpa/") t)
)

(cd (getenv "HOME"))

(defun dj/org-agenda-with-tip (arg)
  "Show agenda for ARG days."
  (org-agenda-list arg)
  (let ((inhibit-read-only t)
	(pos (point)))
    (goto-char (point-max))
    (goto-char pos)))

 (defun dj/kill-this-buffer ()
   "Kill the current buffer"
   (interactive)
   (kill-buffer (current-buffer)))

 (bind-keys
  ("C-x C-k" . dj/kill-this-buffer))

(defun dj/change-frame-font-size (fn)
  "Change the frame font size according to function FN."
  (let* ((font-name (frame-parameter nil 'font))
     (decomposed-font-name (x-decompose-font-name font-name))
     (font-size (string-to-number (aref decomposed-font-name 5))))
    (aset decomposed-font-name 5 (int-to-string (funcall fn font-size)))
    (set-frame-font (x-compose-font-name decomposed-font-name))))

(defun dj/frame-text-scale-increase ()
  "Increase the frame font size by 1."
  (interactive)
  (dj/change-frame-font-size '1+))

(defun dj/frame-text-scale-decrease ()
  "Decrease the frame font size by 1."
  (interactive)
  (dj/change-frame-font-size '1-))

(bind-keys
 ("C-+" . text-scale-increase)
 ("C--" . text-scale-decrease)
 ("s--" . dj/frame-text-scale-decrease)
 ("s-+" . dj/frame-text-scale-increase)
 ("s-=" . dj/frame-text-scale-increase))

 (use-package ring
   :commands (dj/transparency-apply dj/transparency-next dj/transparency-previous
		     dj/transparency-cycle dj/transparency-add)
   :config
   (setq dj/transparency-ring
     (ring-convert-sequence-to-ring (list '(100 100) '(100 50) '(100 10) '(95 50) '(90 50) '(85 50)))
     dj/transparency
     (ring-ref dj/transparency-ring 0))

   (defun dj/transparency-apply (trans)
     "Apply the TRANS alpha value to the frame."
     (set-frame-parameter (selected-frame) 'alpha (setq dj/transparency trans)))

   (defun dj/transparency-next ()
     "Apply the next transparency value in the ring `dj/transparency-ring`."
     (interactive)
     (dj/transparency-apply (ring-next dj/transparency-ring dj/transparency)))

   (defun dj/transparency-previous ()
     "Apply the previous transparency value in the ring `dj/transparency-ring`."
     (interactive)
     (dj/transparency-apply (ring-previous dj/transparency-ring dj/transparency)))

   (defun dj/transparency-cycle ()
     "Cycle to the next transparency setting."
     (interactive)
     (dj/transparency-next))

   (defun dj/transparency-add (active inactive)
     "Add ACTIVE and INACTIVE transparency values to the ring."
     (interactive "nActive Transparency:\nnInactive Transparency:")
     (ring-insert+extend dj/transparency-ring (list active inactive) t)
     (dj/transparency-apply (list active inactive))))

(global-set-key (kbd "C-d") 'dj/duplicate-line)      ;; Duplicate Line

   (defun dj/duplicate-line()
     (interactive)
     (move-beginning-of-line 1)
     (kill-line)
     (yank)
     (open-line 1)
     (next-line 1)
     (yank)
   )

(global-set-key (kbd "C-c r") 'dj/reload-init-file)

 (defun dj/reload-init-file ()
   (interactive)
   (load-file "~/.emacs.d/init.el"))

(defun move-line-up ()
  "Move up the current line."
  (interactive)
  (transpose-lines 1)
  (forward-line -2)
  (indent-according-to-mode))

(defun move-line-down ()
  "Move down the current line."
  (interactive)
  (forward-line 1)
  (transpose-lines 1)
  (forward-line -1)
  (indent-according-to-mode))

;(define-key input-decode-map "\e\eOA" [(meta up)])
;(define-key input-decode-map "\e\eOB" [(meta down)])

(global-set-key [(meta up)]  'move-line-up)
(global-set-key [(meta down)]  'move-line-down)

(setq auto-mode-alist
      (append
       (list (cons "\\.org$" 'org-mode)
             (cons "\\.txt$" 'text-mode)
             (cons "\\.tex$" 'latex-mode)
             (cons "\\.sli$" 'latex-mode)
             (cons "\\.bib$" 'bibtex-mode)
             (cons "\\.epub$" 'nov-mode)
             
             (cons "\\.dss?s?l$" 'dsssl-mode)
             (cons "\\.css$" 'css-mode)

             (cons "\\.pl$" 'perl-mode)
             (cons "\\.cls$" 'perl-mode)
             (cons "\\.sup$" 'perl-mode)

             (cons "\\.py$" 'python-mode)
             (cons "\\.pdf$" 'pdf-view-mode)

             (cons "\\.rb$" 'ruby-mode)

             (cons "\\.3l$" 'nroff-mode)

             (cons "\\.ttl$" 'ttl-mode)
             (cons "\\.n3$" 'ttl-mode)

             (cons "\\.ts$" 'ng2-ts-mode)

             (cons "\\.rdf$" 'nxml-mode)
             (cons "\\.rnc$" 'rnc-mode)
             (cons "\\.rng$" 'nxml-mode)
             (cons "\\.xpd$" 'nxml-mode)
             (cons "\\.xml$" 'nxml-mode)
             (cons "\\.xpl$" 'nxml-mode)
             (cons "\\.xsd$" 'nxml-mode)
             (cons "\\.xqy$" 'xquery-mode)
             (cons "\\.html$" 'nxml-mode)
             (cons "\\.htm$" 'nxml-mode)
             (cons "\\.xsl$" 'nxml-mode)
             )
       auto-mode-alist)
      )

(setq magic-mode-alist '(("<\\?xml " . nxml-mode)
                         ("%![^V]" . ps-mode)
                         ("# xmcd " . conf-unix-mode)))

;; for viewing lines matching regexps
(autoload 'all "all" nil t)

;; for RFCs
(autoload 'rfc "rfc" nil t)

;; Various modes
(autoload 'tar-mode "tar-mode.elc" "Tar archive mode." t)
(autoload 'ruby-mode "ruby-mode.elc" "Ruby mode" t)
(autoload 'xquery-mode "xquery-mode.elc" "XQuery mode" t)
(autoload 'python-mode "python-mode" "Mode for editing Python programs" t)
(autoload 'n3-mode "n3-mode" "Mode for editing N3" t)

(require 'auth-source)
(if (file-exists-p "~/.authinfo.gpg")
    (setq auth-sources '((:source "~/.authinfo.gpg" :host t :protocol t)))
    (setq auth-sources '((:source "~/.authinfo" :host t :protocol t))))

   (setq custom-file "~/.emacs.d/custom-file.el")
   (if (file-exists-p custom-file)
   (load-file custom-file))

   (with-eval-after-load "bind-key"
   (bind-key "<f7>"
	 (lambda ()
	 (interactive
	 (find-file custom-file)))))

   (let* ((variable-tuple
    (cond ((x-list-fonts "Source Sans Pro") '(:font "Source Sans Pro"))
	  ((x-list-fonts "Lucida Grande")   '(:font "Lucida Grande"))
	  ((x-list-fonts "Verdana")         '(:font "Verdana"))
	  ((x-family-fonts "Sans Serif")    '(:family "Sans Serif"))
	  (nil (warn "Cannot find a Sans Serif Font.  Install Source Sans Pro."))))
       (base-font-color     (face-foreground 'default nil 'default))
       (headline           `(:inherit default :weight bold :foreground ,base-font-color)))

   (custom-theme-set-faces
   'user
   `(org-level-8 ((t (,@headline ,@variable-tuple))))
   `(org-level-7 ((t (,@headline ,@variable-tuple))))
   `(org-level-6 ((t (,@headline ,@variable-tuple))))
   `(org-level-5 ((t (,@headline ,@variable-tuple))))
   `(org-level-4 ((t (,@headline ,@variable-tuple :height 1.1))))
   `(org-level-3 ((t (,@headline ,@variable-tuple :height 1.25))))
   `(org-level-2 ((t (,@headline ,@variable-tuple :height 1.5))))
   `(org-level-1 ((t (,@headline ,@variable-tuple :height 1.75))))
   `(org-document-title ((t (,@headline ,@variable-tuple :height 2.0 :underline nil))))))

   ;; Face pitch
   (custom-theme-set-faces
   'user
   '(variable-pitch ((t (:family "Source Sans Pro" :height 180 :weight light))))
   '(fixed-pitch ((t ( :family "Inconsolata" :slant normal :weight normal :height 1.0 :width normal)))))

   (add-hook 'org-mode-hook 'variable-pitch-mode)

   ;; Faces for elements
   (custom-theme-set-faces
   'user
   '(org-block ((t (:inherit fixed-pitch))))
   '(org-code ((t (:inherit (shadow fixed-pitch)))))
   '(org-document-info ((t (:foreground "dark orange"))))
   '(org-document-info-keyword ((t (:inherit (shadow fixed-pitch)))))
   '(org-indent ((t (:inherit (org-hide fixed-pitch)))))
   '(org-link ((t (:foreground "royal blue" :underline t))))
   '(org-meta-line ((t (:inherit (font-lock-comment-face fixed-pitch)))))
   '(org-property-value ((t (:inherit fixed-pitch))) t)
   '(org-special-keyword ((t (:inherit (font-lock-comment-face fixed-pitch)))))
   '(org-table ((t (:inherit fixed-pitch :foreground "#83a598"))))
   '(org-tag ((t (:inherit (shadow fixed-pitch) :weight bold :height 0.8))))
   '(org-verbatim ((t (:inherit (shadow fixed-pitch))))))

(add-to-list 'exec-path "/usr/local/opt/mysql-client/bin/mysql")

(setq sql-mysql-program "/usr/local/opt/mysql-client/bin/mysql")

(setq sql-user "djruesch")

(setq sql-password "password")

(setq sql-server "localhost")

;(setq sql-mysql-options "optional command line options")

(add-to-list 'exec-path "/usr/local/bin/psql")

(setq sql-postgres-program "/usr/local/bin/psql")

(setq postgres-user "djruesch")

;(setq postgres-password "password")

(setq postgres-server "localhost")

;(setq sql-postgres-options "optional command line options")

;(global-unset-key (kbd "C-x C-c")) ;;killing Emacs
;(global-set-key (kbd "C-x C-c") 'delete-frame) ;;kill Frame 
(global-unset-key (kbd "C-x C-z")) ;;Minimizing a Window

 (setq package-enable-at-startup nil)

(setq gc-cons-threshold 100000000)

(defvar file-name-handler-alist-original file-name-handler-alist)
(setq file-name-handler-alist nil)
(setq site-run-file nil)

(defconst *sys/gui*
  (display-graphic-p)
  "Are we running on a GUI Emacs?")

(defconst *sys/win32*
  (eq system-type 'windows-nt)
  "Are we running on a WinTel system?")

(defconst *sys/linux*
  (eq system-type 'gnu/linux)
  "Are we running on a GNU/Linux system?")

(defconst *sys/mac*
  (eq system-type 'darwin)
  "Are we running on a Mac system?")

(defconst *sys/root*
  (string-equal "root" (getenv "USER"))
  "Are you a ROOT user?")

(defconst *rg*
  (executable-find "rg")
  "Do we have ripgrep?")

(defconst *python*
  (executable-find "python")
  "Do we have python?")

(defconst *python3*
  (executable-find "python3")
  "Do we have python3?")

(defconst *mvn*
  (executable-find "mvn")
  "Do we have Maven?")

(defconst *gcc*
  (executable-find "gcc")
  "Do we have gcc?")

(defconst *git*
  (executable-find "git")
  "Do we have git?")

(defconst *pdflatex*
  (executable-find "pdflatex")
  "Do we have pdflatex?")

   (setq custom-file "~/.emacs.d/custom-file.el")
   (if (file-exists-p custom-file)
   (load-file custom-file))

   (with-eval-after-load "bind-key"
   (bind-key "<f7>"
	 (lambda ()
	 (interactive
	 (find-file custom-file)))))

   (let* ((variable-tuple
    (cond ((x-list-fonts "Source Sans Pro") '(:font "Source Sans Pro"))
	  ((x-list-fonts "Lucida Grande")   '(:font "Lucida Grande"))
	  ((x-list-fonts "Verdana")         '(:font "Verdana"))
	  ((x-family-fonts "Sans Serif")    '(:family "Sans Serif"))
	  (nil (warn "Cannot find a Sans Serif Font.  Install Source Sans Pro."))))
       (base-font-color     (face-foreground 'default nil 'default))
       (headline           `(:inherit default :weight bold :foreground ,base-font-color)))

   (custom-theme-set-faces
   'user
   `(org-level-8 ((t (,@headline ,@variable-tuple))))
   `(org-level-7 ((t (,@headline ,@variable-tuple))))
   `(org-level-6 ((t (,@headline ,@variable-tuple))))
   `(org-level-5 ((t (,@headline ,@variable-tuple))))
   `(org-level-4 ((t (,@headline ,@variable-tuple :height 1.1))))
   `(org-level-3 ((t (,@headline ,@variable-tuple :height 1.25))))
   `(org-level-2 ((t (,@headline ,@variable-tuple :height 1.5))))
   `(org-level-1 ((t (,@headline ,@variable-tuple :height 1.75))))
   `(org-document-title ((t (,@headline ,@variable-tuple :height 2.0 :underline nil))))))

   ;; Face pitch
   (custom-theme-set-faces
   'user
   '(variable-pitch ((t (:family "Source Sans Pro" :height 180 :weight light))))
   '(fixed-pitch ((t ( :family "Inconsolata" :slant normal :weight normal :height 1.0 :width normal)))))

   (add-hook 'org-mode-hook 'variable-pitch-mode)

   ;; Faces for elements
   (custom-theme-set-faces
   'user
   '(org-block ((t (:inherit fixed-pitch))))
   '(org-code ((t (:inherit (shadow fixed-pitch)))))
   '(org-document-info ((t (:foreground "dark orange"))))
   '(org-document-info-keyword ((t (:inherit (shadow fixed-pitch)))))
   '(org-indent ((t (:inherit (org-hide fixed-pitch)))))
   '(org-link ((t (:foreground "royal blue" :underline t))))
   '(org-meta-line ((t (:inherit (font-lock-comment-face fixed-pitch)))))
   '(org-property-value ((t (:inherit fixed-pitch))) t)
   '(org-special-keyword ((t (:inherit (font-lock-comment-face fixed-pitch)))))
   '(org-table ((t (:inherit fixed-pitch :foreground "#83a598"))))
   '(org-tag ((t (:inherit (shadow fixed-pitch) :weight bold :height 0.8))))
   '(org-verbatim ((t (:inherit (shadow fixed-pitch))))))

; Allow some things that emacs would otherwise confirm.
(put 'eval-expression  'disabled nil)
(put 'downcase-region  'disabled nil)
(put 'upcase-region    'disabled nil)
(put 'narrow-to-region 'disabled nil)
(put 'set-goal-column  'disabled nil)

 (setq inhibit-startup-message t)

(defun my-startup-layout ()
 (interactive)
 (delete-other-windows)
 ;(split-window-horizontally) ;; -> |
 ;(next-multiframe-window)
 (shell)
 ;(split-window-vertically) ;;  -> --
 (next-multiframe-window)
 (view-buffer "*dashboard*")
 (treemacs)
 ;(next-multiframe-window)
 ;(dired "~")
)

 (add-hook 'emacs-startup-hook

     ;; Windows location
     (when (window-system)
     (set-frame-height (selected-frame) 133)
     (set-frame-width (selected-frame) 150)
     (set-frame-position (selected-frame) 1985 -800))

     (my-startup-layout )
 )

 (require 'ispell)

 (add-to-list 'exec-path "/usr/local/bin/hunspell")
 (setq ispell-program-name "/usr/local/bin/hunspell")
 
 (setq ispell-local-dictionary "en_US")

 (add-to-list
  'ispell-local-dictionary-alist
  '(("en_US" "[[:alpha:]]" "[^[:alpha]]" "[0-9']" t
     ("-d" "en_US") nil utf-8)))

 (when (string-equal system-type "darwin") ; There is no problem on Linux
   ;; Dictionary file name
   (setenv "DICTIONARY" "en_US"))

 (global-set-key (kbd "<C-c w>") 'ispell-word)
 (global-set-key (kbd "<C-n f>") 'helm-flyspell-correct)
 ;(global-set-key (kbd "<C-f4>") 'flyspell-correct-word-generic)

;(setq backup-by-copying t
;create-lockfiles nil
;backup-directory-alist '((".*" . "~/.saves"))
;; auto-save-file-name-transforms `((".*" "~/.saves" t))
;delete-old-versions t
;kept-new-versions 6
;kept-old-versions 2
;version-control t)

(setq backup-directory-alist
      `((".*" . ,temporary-file-directory)))
(setq auto-save-file-name-transforms
      `((".*" ,temporary-file-directory t)))

(defun dj/force-backup-of-buffer ()
  "Lie to Emacs, telling it the current buffer has yet to be backed up."
  (setq buffer-backed-up nil))
(add-hook 'before-save-hook  'dj/force-backup-of-buffer)

;; Make some buffers immortal
(defun dj-immortal-buffers ()
  (if (or (eq (current-buffer) (get-buffer "*scratch*"))
          (eq (current-buffer) (get-buffer "*Messages*")))
      (progn (bury-buffer)
             nil)
    t))

(add-hook 'kill-buffer-query-functions 'dj-immortal-buffers)

 (set-register ?a (cons 'file "~/.authinfo.gpg"))
 (set-register ?s (cons 'file "~/.emacs.d/settings.org"))
 (set-register ?o (cons 'file "~/org/organizer.org"))
 (set-register ?b (cons 'file "~/org/clients/codigopd/blog.org"))
 (set-register ?f (cons 'file "~/org/elfeed.org"))
 (set-register ?c (cons 'file "~/org/contacts.org"))
 (set-register ?j (cons 'file "~/org/journals/djruesch.org"))
 (set-register ?n (cons 'file "~/.netrc"))

(defun dj/org-add-ids-to-headlines-in-file ()
  "Add ID properties to all headlines in the current file which
do not already have one."
  (interactive)
  (org-map-entries 'org-id-get-create)
 )


;(add-hook 'org-mode-hook
;	  (lambda ()
;	    (add-hook 'before-save-hook 'dj/org-add-ids-to-headlines-in-file nil 'local)))

(setq completion-ignored-extensions
      (append completion-ignored-extensions '(".rtf")))

  (menu-bar-mode -1)

  (tool-bar-mode -1)

  (scroll-bar-mode -1)

 (blink-cursor-mode -1)

 ;;(global-hl-line-mode 1)
 ;;(set-face-background 'hl-line "#3e4446")
 ;;(set-face-foreground 'highlight nil)

 (setq ring-bell-function
 (lambda ()
 (let ((orig-fg (face-foreground 'mode-line)))
 (set-face-foreground 'mode-line "#F2804F")
 (run-with-idle-timer 0.1 nil
 (lambda (fg) (set-face-foreground 'mode-line fg))
 orig-fg))))

 (setq vc-follow-symlinks t)

 (prefer-coding-system       'utf-8)
 (set-default-coding-systems 'utf-8)
 (set-terminal-coding-system 'utf-8)
 (set-keyboard-coding-system 'utf-8)
 (set-language-environment 'utf-8)

 (setq org-export-coding-system 'utf-8)
 (set-charset-priority 'unicode)

 (setq buffer-file-coding-system 'utf-8
       x-select-request-type '(UTF8_STRING COMPOUND_TEXT TEXT STRING))
 ;; MS Windows clipboard is UTF-16LE
 (when (eq system-type 'windows-nt)
   (set-clipboard-coding-system 'utf-16le-dos))

 (setq browse-url-browser-function 'browse-url-generic)
 (setq browse-url-generic-program "/Applications/qutebrowser.app/Contents/MacOS/qutebrowser")

 ;; Change "yes or no" to "y or n"
 (fset 'yes-or-no-p 'y-or-n-p)

 ;; Don't ask for confirmation for "dangerous" commands
 (put 'erase-buffer 'disabled nil)
 (put 'narrow-to-page 'disabled nil)
 (put 'upcase-region 'disabled nil)
 (put 'narrow-to-region 'disabled nil)
 (put 'downcase-region 'disabled nil)
 (put 'scroll-left 'disabled nil)
 (put 'scroll-right 'disabled nil)
 (put 'set-goal-column 'disabled nil)

 ;; large file warning
 (setq large-file-warning-threshold (* 15 1024 1024))

(server-start)
;(require 'server)

;(setq server-port    52698)
;(setq server-use-tcp t)

(defun server-start-and-copy ()
  (server-start)
  (copy-file "~/.emacs.d/server/server" "/Volumes/DJRuesch/.emacs.d/server/server" t))

;(add-hook 'emacs-startup-hook 'server-start-and-copy)

; (when (and (or (eq system-type 'windows-nt) (eq system-type 'darwin))
 ;	    (not (and (boundp 'server-clients) server-clients))
 ;	    (not (daemonp)))
  ; (server-start))

(use-package monokai-theme 
  :ensure t
  :load-path "themes"
  :init
  (setq monokai-theme-kit t)
  :config
  (load-theme 'monokai t)
  )

 (use-package evil
   :disabled
   :ensure t
   :defer .1 ;; don't block emacs when starting, load evil immediately after startup
   :init
   (setq evil-want-keybinding nil)
   (setq evil-want-integration nil) ;; required by evil-collection
   (setq evil-search-module 'evil-search)
   (setq evil-ex-complete-emacs-commands nil)
   (setq evil-vsplit-window-right t) ;; like vim's 'splitright'
   (setq evil-split-window-below t) ;; like vim's 'splitbelow'
   (setq evil-shift-round nil)
   (setq evil-want-C-u-scroll t)
   :config
   (evil-mode)

   ;; vim-like keybindings everywhere in emacs
   (use-package evil-collection
     :after evil
     :ensure t
     :custom (evil-collection-setup-minibuffer t)
     :init
     (evil-collection-init))

   ;; gl and gL operators, like vim-lion
   (use-package evil-lion
     :ensure t
     :bind (:map evil-normal-state-map
                 ("g l " . evil-lion-left)
                 ("g L " . evil-lion-right)
                 :map evil-visual-state-map
                 ("g l " . evil-lion-left)
                 ("g L " . evil-lion-right)))

   ;; gc operator, like vim-commentary
   (use-package evil-commentary
     :ensure t
     :bind (:map evil-normal-state-map
                 ("gc" . evil-commentary)))

   ;; gx operator, like vim-exchange
   ;; NOTE using cx like vim-exchange is possible but not as straightforward
   (use-package evil-exchange
     :ensure t
     :bind (:map evil-normal-state-map
                 ("gx" . evil-exchange)
                 ("gX" . evil-exchange-cancel)))

   ;; gr operator, like vim's ReplaceWithRegister
   (use-package evil-replace-with-register
     :ensure t
     :bind (:map evil-normal-state-map
                 ("gr" . evil-replace-with-register)
                 :map evil-visual-state-map
                 ("gr" . evil-replace-with-register)))

   ;; * operator in vusual mode
   (use-package evil-visualstar
     :ensure t
     :bind (:map evil-visual-state-map
                 ("*" . evil-visualstar/begin-search-forward)
                 ("#" . evil-visualstar/begin-search-backward)))

   ;; ex commands, which a vim user is likely to be familiar with
   (use-package evil-expat
     :ensure t
     )

   ;; visual hints while editing
   (use-package evil-goggles
     :ensure t
     :config
     (evil-goggles-use-diff-faces)
     (evil-goggles-mode))

   ;; like vim-surround
   (use-package evil-surround
     :ensure t
     :commands
     (evil-surround-edit
      evil-Surround-edit
      evil-surround-region
      evil-Surround-region)
     :init
     (evil-define-key 'operator global-map "s" 'evil-surround-edit)
     (evil-define-key 'operator global-map "S" 'evil-Surround-edit)
     (evil-define-key 'visual global-map "S" 'evil-surround-region)
     (evil-define-key 'visual global-map "gS" 'evil-Surround-region))

   (message "Loading evil-mode...done"))

(require 'epa-file)
(custom-set-variables '(epg-gpg-program  "/usr/local/bin/gpg"))
(epa-file-enable)

(setq epa-file-select-keys nil)
(setq epa-file-encrypt-to '("djruesch@gmail.com"))

;; Increase the password cache expiry time.
(setq password-cache-expiry (* 60 15))

(setf epa-pinentry-mode 'loopback)

(setq epa-file-cache-passphrase-for-symmetric-encryption t)

(use-package tramp
  :defer 5
  :config
  (with-eval-after-load 'tramp-cache
    (setq tramp-persistency-file-name "~/.emacs.d/tramp"))
  (setq tramp-default-method "ssh"
        tramp-default-user-alist '(("\\`su\\(do\\)?\\'" nil "root"))
        tramp-adb-program "/usr/local/bin/adb"
        ;; use the settings in ~/.ssh/config instead of Tramp's
        tramp-use-ssh-controlmaster-options nil
        ;; don't generate backups for remote files opened as root (security hazzard)
        backup-enable-predicate
        (lambda (name)
          (and (normal-backup-enable-predicate name)
               (not (let ((method (file-remote-p name 'method)))
                      (when (stringp method)
                        (member method '("su" "sudo"))))))))
)

(use-package helm-tramp
  :bind ("C-c s" . 'helm-tramp)
)

(use-package exec-path-from-shell
)

(add-to-list 'load-path "~/.emacs.d/site-lisp/")

(require 'twittering-mode)

;(setq twittering-use-master-password t)
;(setq twittering-cert-file "/etc/ssl/certs/ca-bundle.crt")

(setq twittering-initial-timeline-spec-string
      '(":home"
        ":replies"
        ":favorites"
        ":direct_messages"
        ":search/emacs/"
        "user_name/list_name"))

(setq twittering-icon-mode t)                ; Show icons
(setq twittering-timer-interval 300)         ; Update your timeline each 300 seconds (5 minutes)
(setq twittering-url-show-status nil)        ; Keeps the echo area from showing all the http processes

(add-hook 'twittering-new-tweets-hook (lambda ()
   (let ((n twittering-new-tweets-count))
     (start-process "twittering-notify" nil "/usr/local/bin/notify-send"
                    "-i" "/usr/share/pixmaps/gnome-emacs.png"
                    "New tweets"
                    (format "You have %d new tweet%s"
                            n (if (> n 1) "s" ""))))))

(add-hook 'twittering-edit-mode-hook (lambda () (ispell-minor-mode) (flyspell-mode)))

(use-package helm
  :ensure t
  :demand
  :bind (("M-x" . helm-M-x)
	 ("C-x C-f" . helm-find-files)
	 ("C-x b" . helm-buffers-list)
	 ("C-x c o" . helm-occur)) ;SC
	 ("M-y" . helm-show-kill-ring) ;SC
	 ("C-x r b" . helm-filtered-bookmarks) ;SC
  :preface (require 'helm-config)
  :config (helm-mode 1))

(use-package helm-projectile
  :ensure t
  )

(use-package helm-descbinds
  :ensure t
  )

(use-package helm-bibtex
  :ensure t
  )

(use-package hydra
  :ensure t
)

 (defmacro toggle-setting-string (setting)
   `(if (and (boundp ',setting) ,setting) '[x] '[_]))

 (bind-key "C-x t"
  (defhydra hydra-toggle (:color amaranth)
    "
     _c_ column-number : %(toggle-setting-string column-number-mode)  _b_ orgtbl-mode    : %(toggle-setting-string orgtbl-mode)  _x_/_X_ trans          : %(identity dj/transparency)
     _e_ debug-on-error: %(toggle-setting-string debug-on-error)  _s_ orgstruct-mode : %(toggle-setting-string orgstruct-mode)  _m_   hide mode-line : %(toggle-setting-string dj/hide-mode-line-mode)
     _u_ debug-on-quit : %(toggle-setting-string debug-on-quit)  _h_ diff-hl-mode   : %(toggle-setting-string diff-hl-mode)  _p_   parenthisis : %(toggle-setting-string show-paren-mode)
     _f_ auto-fill     : %(toggle-setting-string auto-fill-function)  _B_ battery-mode   : %(toggle-setting-string display-battery-mode)
     _t_ truncate-lines: %(toggle-setting-string truncate-lines)  _l_ highlight-line : %(toggle-setting-string hl-line-mode)
     _r_ read-only     : %(toggle-setting-string buffer-read-only)  _n_ line-numbers   : %(toggle-setting-string linum-mode)
     _w_ whitespace    : %(toggle-setting-string whitespace-mode)  _N_ relative lines : %(if (eq linum-format 'linum-relative) '[x] '[_])
     "
    ("c" column-number-mode nil)
    ("e" toggle-debug-on-error nil)
    ("u" toggle-debug-on-quit nil)
    ("f" auto-fill-mode nil)
    ("t" toggle-truncate-lines nil)
    ("r" dired-toggle-read-only nil)
    ("w" whitespace-mode nil)
    ("b" orgtbl-mode nil)
    ("s" orgstruct-mode nil)
    ("x" dj/transparency-next nil)
    ("B" display-battery-mode nil)
    ("X" dj/transparency-previous nil)
    ("h" diff-hl-mode nil)
    ("p" show-paren-mode nil)
    ("l" hl-line-mode nil)
    ("n" linum-mode nil)
    ("N" linum-relative-toggle nil)
    ("m" dj/hide-mode-line-mode nil)
    ("q" nil)))

(use-package helpful
  :ensure t
  :bind
  ("C-h f" . helpful-function)
  ("C-h x" . helpful-command)
  ("C-h z" . helpful-macro))

 (use-package info+
 )

 (use-package projectile
   :ensure t
   :bind
   ("C-c p" . projectile-command-map)
   ("C-x w" . hydra-projectile-other-window/body)
   ("C-c C-p" . hydra-projectile/body)
   :config
  
   (use-package counsel-projectile
     :ensure t
   )

   (when (eq system-type 'windows-nt)
     (setq projectile-indexing-method 'native))
   (setq projectile-enable-caching t
	 projectile-require-project-root t
	 projectile-mode-line '(:eval (format " 🛠[%s]" (projectile-project-name)))
	 projectile-completion-system 'default)
   (projectile-mode)

   (defhydra hydra-projectile-other-window (:color teal)
     "projectile-other-window"
     ("f"  projectile-find-file-other-window        "file")
     ("g"  projectile-find-file-dwim-other-window   "file dwim")
     ("d"  projectile-find-dir-other-window         "dir")
     ("b"  projectile-switch-to-buffer-other-window "buffer")
     ("q"  nil                                      "cancel" :color blue))
   (defhydra hydra-projectile (:color teal :hint nil)
     "
  PROJECTILE: %(projectile-project-root)

  Find File            Search/Tags          Buffers                Cache
   ------------------------------------------------------------------------------------------
   _C-f_: file            _a_: ag                _i_: Ibuffer           _c_: cache clear
    _ff_: file dwim       _g_: update gtags      _b_: switch to buffer  _x_: remove known project
    _fd_: file curr dir   _o_: multi-occur     _C-k_: Kill all buffers  _X_: cleanup non-existing
     _r_: recent file                                               ^^^^_z_: cache current
     _d_: dir

   "
     ("a"   counsel-projectile-ag)
     ("b"   projectile-switch-to-buffer)
     ("c"   projectile-invalidate-cache)
     ("d"   projectile-find-dir)
     ("C-f" projectile-find-file)
     ("ff"  projectile-find-file-dwim)
     ("fd"  projectile-find-file-in-directory)
     ("g"   ggtags-update-tags)
     ("C-g" ggtags-update-tags)
     ("i"   projectile-ibuffer)
     ("K"   projectile-kill-buffers)
     ("C-k" projectile-kill-buffers)
     ("m"   projectile-multi-occur)
     ("o"   projectile-multi-occur)
     ("C-p" projectile-switch-project "switch project")
     ("p"   projectile-switch-project)
     ("s"   projectile-switch-project)
     ("r"   projectile-recentf)
     ("x"   projectile-remove-known-project)
     ("X"   projectile-cleanup-known-projects)
     ("z"   projectile-cache-current-file)
     ("`"   hydra-projectile-other-window/body "other window")
     ("q"   nil "cancel" :color blue)))

(use-package perspective
  :ensure t
  :config
  (persp-mode))

 (use-package all-the-icons
   :ensure t
   )

 (use-package all-the-icons-dired
   :ensure t
   :commands (all-the-icons-dired-mode)
   :config (add-hook 'dired-mode-hook 'all-the-icons-dired-mode))

(use-package company
  ;:diminish
  :config
  (global-company-mode 1)
  (setq ;; Only 2 letters required for completion to activate.
   company-minimum-prefix-length 2

   ;; Search other buffers for compleition candidates
   company-dabbrev-other-buffers t
   company-dabbrev-code-other-buffers t

   ;; Show candidates according to importance, then case, then in-buffer frequency
   company-transformers '(company-sort-by-backend-importance
			  company-sort-prefer-same-case-prefix
			  company-sort-by-occurrence)

   ;; Flushright any annotations for a compleition;
   ;; e.g., the description of what a snippet template word expands into.
   company-tooltip-align-annotations t

   ;; Allow (lengthy) numbers to be eligible for completion.
   company-complete-number t

   ;; M-⟪num⟫ to select an option according to its number.
   company-show-numbers t

   ;; Show 10 items in a tooltip; scrollbar otherwise or C-s ^_^
   company-tooltip-limit 10

   ;; Edge of the completion list cycles around.
   company-selection-wrap-around t

   ;; Do not downcase completions by default.
   company-dabbrev-downcase nil

   ;; Even if I write something with the ‘wrong’ case,
   ;; provide the ‘correct’ casing.
   company-dabbrev-ignore-case nil

   ;; Immediately activate completion.
   company-idle-delay 0)

  ;; Use C-/ to manually start company mode at point. C-/ is used by undo-tree.
  ;; Override all minor modes that use C-/; bind-key* is discussed below.
  (bind-key* "C-/" #'company-manual-begin)

  ;; Bindings when the company list is active.
  :bind (:map company-active-map
	      ("C-d" . company-show-doc-buffer) ;; In new temp buffer
	      ("<tab>" . company-complete-selection)
	      ;; Use C-n,p for navigation in addition to M-n,p
	      ("C-n" . (lambda () (interactive) (company-complete-common-or-cycle 1)))
	      ("C-p" . (lambda () (interactive) (company-complete-common-or-cycle -1)))))

(use-package pdf-tools
  :ensure t
  :config
  (custom-set-variables
    '(pdf-tools-handle-upgrades nil)) ; Use brew upgrade pdf-tools instead.
  (setq pdf-info-epdfinfo-program "/usr/local/bin/epdfinfo"))
(pdf-tools-install)

(use-package dired-hacks-utils
  :ensure t
)

(use-package dired-filter
  :ensure t
)

(use-package dired-rainbow
  :ensure t
)

(use-package dired-narrow
  :ensure t
)

(use-package dired-collapse
  :ensure t
)

(use-package nov
:load-path ("~/.emacs.d/site-lisp")
:requires (visual-fill-column justify-kp)
:config

(defun my-nov-font-setup ()
  (face-remap-add-relative 'variable-pitch :family "Liberation Serif"
                                           :height 1.0))
(add-hook 'nov-mode-hook 'my-nov-font-setup)

(setq nov-text-width t)
(setq visual-fill-column-center-text t)
(add-hook 'nov-mode-hook 'visual-line-mode)
(add-hook 'nov-mode-hook 'visual-fill-column-mode)

;(require 'justify-kp)
(setq nov-text-width t)

(defun my-nov-window-configuration-change-hook ()
  (my-nov-post-html-render-hook)
  (remove-hook 'window-configuration-change-hook
               'my-nov-window-configuration-change-hook
               t))

(defun my-nov-post-html-render-hook ()
  (if (get-buffer-window)
      (let ((max-width (pj-line-width))
            buffer-read-only)
        (save-excursion
          (goto-char (point-min))
          (while (not (eobp))
            (when (not (looking-at "^[[:space:]]*$"))
              (goto-char (line-end-position))
              (when (> (shr-pixel-column) max-width)
                (goto-char (line-beginning-position))
                (pj-justify)))
            (forward-line 1))))
    (add-hook 'window-configuration-change-hook
              'my-nov-window-configuration-change-hook
              nil t)))

(add-hook 'nov-post-html-render-hook 'my-nov-post-html-render-hook)

)

(defvar bitlbee-password "djruesch")
 
(defun bitlbee-netrc-identify ()
    "Auto-identify for Bitlbee channels using authinfo or netrc.
    
    The entries that we look for in netrc or authinfo files have
    their 'port' set to 'bitlbee', their 'login' or 'user' set to
    the current nickname and 'server' set to the current IRC
    server's name.  A sample value that works for authenticating
    as user 'keramida' on server 'localhost' is:
    
    machine localhost port bitlbee login keramida password supersecret"

    (interactive)
    (when (string= (buffer-name) "&bitlbee")
      (let* ((secret (plist-get (nth 0 (auth-source-search :max 1
							   :host erc-server
							   :user (erc-current-nick)
							   :port "bitlbee"))
				:secret))
	     (password (if (functionp secret)
			   (funcall secret)
			 secret)))
	(erc-message "PRIVMSG" (concat (erc-default-target) " " "identify" " " password) nil))))
  
  ;; Enable the netrc authentication function for &biblbee channels.
  (add-hook 'erc-join-hook 'bitlbee-netrc-identify)

 (use-package elfeed
   :ensure t
   :bind
   ("C-c f" . 'elfeed)
   ("C-c U" . 'elfeed-update)
   
   :config

   (setq-default elfeed-search-filter "@1-days-ago +unread ")

   (setf url-queue-timeout 30)

   (defun elfeed-v-mpv (url)
     "Watch a video from URL in MPV"
     (async-shell-command (format "mpv %s" url)))

   (defun elfeed-view-mpv (&optional use-generic-p)
     "Youtube-feed link"
     (interactive "P")
     (let ((entries (elfeed-search-selected)))
     (cl-loop for entry in entries
     do (elfeed-untag entry 'unread)
     when (elfeed-entry-link entry)
     do (elfeed-v-mpv it))
     (mapc #'elfeed-search-update-entry entries)
     (unless (use-region-p) (forward-line))))
     
 ;;(define-key elfeed-search-mode-map (kbd "v") 'elfeed-view-mpv)
)

   (use-package elfeed-org
   :ensure t
   :config (setq rmh-elfeed-org-files (list "~/org/elfeed.org"))
   )

 (use-package emms
   :config
   ;(require 'emms-setup)
   (emms-all)
   (emms-default-players)
   (setq emms-source-file-default-directory "~/Music/new/")
   (setq emms-playlist-buffer-name "*Music*")
   (setq emms-info-asynchronously t)
   (require 'emms-info-libtag) ;;; load functions that will talk to emms-print-metadata which in turn talks to libtag and gets metadata
   (setq emms-info-functions '(emms-info-libtag)) ;;; make sure libtag is the only thing delivering metadata
   (require 'emms-mode-line)
   (emms-mode-line 1)
   (require 'emms-playing-time)
   (emms-playing-time 1)
   (require 'emms-player-simple)

   (define-emms-simple-player afplay '(file)
     (regexp-opt '(".mp3" ".m4a" ".aac"))
     "afplay")
   (setq emms-player-list `(,emms-player-afplay))

   (global-set-key (kbd "C-c e t") 'emms-play-directory-tree)
   (global-set-key (kbd "C-c e a") 'emms-add-directory-tree)
   (global-set-key (kbd "C-c e f") 'emms-play-file)

   (global-set-key (kbd "C-c e x") 'emms-start)
   (global-set-key (kbd "C-c e X") 'emms-stop)
   (global-set-key (kbd "C-c e n") 'emms-next)
   (global-set-key (kbd "C-c e p") 'emms-previous)
   (global-set-key (kbd "C-c e SPC") 'emms-pause)

   (global-set-key (kbd "C-c e h") 'emms-shuffle)
 )

 (use-package mu4e
 :bind
 ("C-c m" . 'mu4e)
 :config
 ;; mu path
 (setq mu4e-mu-binary "/usr/local/bin/mu")
 ;; use mu4e for e-mail in emacs
 (setq mail-user-agent 'mu4e-user-agent)

 (setq mu4e-refile-folder "/[Gmail]/All Mail")
 (setq mu4e-drafts-folder "/[Gmail].Drafts")
 (setq mu4e-sent-folder   "/[Gmail].Sent Mail")
 (setq mu4e-trash-folder  "/[Gmail].Trash")

 ;; don't save message to Sent Messages, Gmail/IMAP takes care of this
 (setq mu4e-sent-messages-behavior 'delete)

 ;; (See the documentation for `mu4e-sent-messages-behavior' if you have
 ;; additional non-Gmail addresses and want assign them different
 ;; behavior.)

 ;; setup some handy shortcuts
 ;; you can quickly switch to your Inbox -- press ``ji''
 ;; then, when you want archive some messages, move them to
 ;; the 'All Mail' folder by pressing ``ma''.

 ;;(setq mu4e-maildir-shortcuts
 ;;    '( (:maildir "/[Gmail].Inbox"      :key ?i)
 ;;       (:maildir "/[Gmail].Sent Mail"  :key ?s)
 ;;       (:maildir "/[Gmail].Trash"      :key ?t)
 ;;       (:maildir "/[Gmail].All Mail"   :key ?a)))


 (setq mu4e-headers-fields
     '( (:date          .  25)    ;; alternatively, use :human-date
	(:flags         .   6)
	(:from          .  22)
	(:subject       .  nil))) ;; alternatively, use :thread-subject

 (setq mu4e-attachment-dir "~/Downloads")
 (setq mu4e-use-fancy-chars t)
 (setq mu4e-view-show-addresses t)
 (setq mu4e-view-show-images t)

 ;; allow for updating mail using 'U' in the main view:
 (setq mu4e-get-mail-command "/usr/local/bin/offlineimap")

 ;; something about ourselves
 (setq mu4e-compose-reply-to-address "djruesch@gmail.com")

 (setq mu4e-compose-signature "https://codigopd.com\n")

 ;; sending mail -- replace USERNAME with your gmail username
 ;; also, make sure the gnutls command line utils are installed
 ;; package 'gnutls-bin' in Debian/Ubuntu

 (require 'smtpmail)
 (setq message-send-mail-function 'smtpmail-send-it
    starttls-use-gnutls t
    smtpmail-starttls-credentials '(("smtp.gmail.com" 587 nil nil))
    smtpmail-auth-credentials
      '(("smtp.gmail.com" 587 "djruesch@gmail.com" nil))
    smtpmail-default-smtp-server "smtp.gmail.com"
    smtpmail-smtp-server "smtp.gmail.com"
    smtpmail-smtp-service 587)

 ;; don't keep message buffers around
 (setq message-kill-buffer-on-exit t)

 )

 (use-package dashboard 
   :ensure t
   :config

   ;(dashboard-setup-startup-hook)

   ;; Set the title
   (setq dashboard-banner-logo-title "Welcome to the CodigoPD Dashboard")
   ;; Set the banner
   (setq dashboard-startup-banner "/Users/djruesch/Proyectos/codigopd/website/static/img/logos/codigopd_logo-506x171.png")

   ;; Content is not centered by default. To center, set
   (setq dashboard-center-content t)

   ;; To disable shortcut "jump" indicators for each section, set
   (setq dashboard-show-shortcuts t)

   (setq dashboard-items '((recents  . 10)
   (bookmarks . 25)
   (projects . 15)
   (agenda . 15)
   (registers . 25)))

   (setq dashboard-set-heading-icons t)
   (setq dashboard-set-file-icons t)

   (setq dashboard-set-navigator t)

   (setq dashboard-set-init-info t)

   ;;(setq dashboard-set-footer t)

   ;;(add-to-list 'dashboard-items '(agenda) t)

   (setq show-week-agenda-p t)

   (setq dashboard-org-agenda-categories '("DJRuesch" "CodigoPD"))

   (setq dashboard-footer-messages '("Dashboard is pretty cool!"))
   (setq dashboard-footer-icon (all-the-icons-octicon "dashboard"
                                                   :height 1.1
                                                   :v-adjust -0.05
                                                   :face 'font-lock-keyword-face))
 )

 (use-package which-key
   :ensure t
   :init
   (which-key-mode)
   (which-key-setup-side-window-right-bottom)
   (setq which-key-max-description-length 60))

(use-package magit
  :ensure t
  :bind ("C-x g" . magit-status)
  :config
  (setq magit-last-seen-setup-instructions "1.4.0"))

(use-package magit-todos
  :ensure t
  :after magit
  :hook (magit-mode-hook . magit-todos-mode))

(use-package engine-mode
  :init (require 'engine-mode)
	;;(engine/set-keymap-prefix (kbd "C-c s"))
  :ensure t
  :config
  (setq engine-mode t)

  (defengine url
    "%s"
    :keybinding "u"
    :docstring "Open: URL")


  (defengine allrecipes
    "https://www.allrecipes.com/search/results/?wt=%s"
    :keybinding "r"
    :docstring "Search: allrecipes.com")


  (defengine churchofjesuschrist
    "https://www.churchofjesuschrist.org/search?lang=eng&query=%s"
    :keybinding "c"
    :docstring "Search: churchofjesuschrist.org")

  (defengine mail
    "https://mail.google.com/mail/u/0/#search/%s"
    :keybinding "m"
    :docstring "Search: djruesch@gmail.com"
    )

  (defengine emacswiki
    "http://google.com/search?q=site:emacswiki.org+%s"
    :keybinding "e"
    :docstring "Search: emacswiki"
    )

  (defengine sachachua
    "https://sachachua.com/blog/?s=%s"
    :keybinding "S"
    :docstring "Sachachua Blog"
  )

  (defengine duckduckgo
    "https://duckduckgo.com/?q=%s"
    :keybinding "d"
    :docstring "Search: Internet")

  (defengine image
    "https://duckduckgo.com/?q=%s&atb=v218-1__&ia=images&iax=images"
    :keybinding "i"
    :docstring "Search: Images")

  (defengine github
    "https://github.com/search?ref=simplesearch&q=%s"
    :keybinding "g"
    :docstring "Search: github.com")

  (defengine google
    "http://www.google.com/search?ie=utf-8&oe=utf-8&q=%s"
    :keybinding "s"
    :docstring "Search: google.com")

  (defengine pinterest
    "https://www.pinterest.cl/search/pins/?q=%s"
    :keybinding "P"
    :docstring "Search: pinterest.cl")

  (defengine python
    "https://docs.python.org/3/search.html?q=%s&check_keywords=yes&area=default"
    :keybinding "p"
    :docstring "Search: docs.python.org")

  (defengine stack-overflow
    "https://stackoverflow.com/search?q=%s"
    :keybinding "o"
    :docstring "Search: stackoverflow.com")

  (defengine familysearch
    "https://www.google.com/search?q=site:familysearch.org %s"
    :keybinding "f"
    :docstring "Search: FamilySearch.org")

  (defengine sitesearch
    "https://www.google.com/search?q=site:%s"
    :keybinding "w"
    :docstring "Search: Websites with Google")

   (defengine youtube
    "https://www.youtube.com/results?search_query=test%s"
    :keybinding "y"
    :docstring "Search: youtube.com")
)

 (setq-default abbrev-mode 1)

 (use-package yasnippet
   :ensure t
   :hook (after-init . yas-global-mode)
   :config

   (setq yas-snippet-dirs '("~/.emacs.d/snippets"
                           ))
   :bind
   (:map yas-minor-mode-map
	 ("C-c & t" . yas-describe-tables)
	 ("C-c & &" . org-mark-ring-goto)))

 (use-package yasnippet-snippets
   )
 
(use-package helm-c-yasnippet
   :bind
   (("C-c y" . helm-yas-complete)))

(use-package treemacs
  :ensure t
  :defer t
  :init
  (with-eval-after-load 'winum
    (define-key winum-keymap (kbd "M-0") #'treemacs-select-window))
  :config
  (progn
    (setq treemacs-collapse-dirs                 (if treemacs-python-executable 3 0)
          treemacs-deferred-git-apply-delay      0.5
          treemacs-directory-name-transformer    #'identity
          treemacs-display-in-side-window        t
          treemacs-eldoc-display                 t
          treemacs-file-event-delay              5000
          treemacs-file-extension-regex          treemacs-last-period-regex-value
          treemacs-file-follow-delay             0.2
          treemacs-file-name-transformer         #'identity
          treemacs-follow-after-init             t
          treemacs-git-command-pipe              ""
          treemacs-goto-tag-strategy             'refetch-index
          treemacs-indentation                   2
          treemacs-indentation-string            " "
          treemacs-is-never-other-window         nil
          treemacs-max-git-entries               5000
          treemacs-missing-project-action        'ask
          treemacs-move-forward-on-expand        nil
          treemacs-no-png-images                 nil
          treemacs-no-delete-other-windows       t
          treemacs-project-follow-cleanup        nil
          treemacs-persist-file                  (expand-file-name ".cache/treemacs-persist" user-emacs-directory)
          treemacs-position                      'left
          treemacs-read-string-input             'from-child-frame
          treemacs-recenter-distance             0.1
          treemacs-recenter-after-file-follow    nil
          treemacs-recenter-after-tag-follow     nil
          treemacs-recenter-after-project-jump   'always
          treemacs-recenter-after-project-expand 'on-distance
          treemacs-show-cursor                   nil
          treemacs-show-hidden-files             t
          treemacs-silent-filewatch              nil
          treemacs-silent-refresh                nil
          treemacs-sorting                       'alphabetic-asc
          treemacs-space-between-root-nodes      t
          treemacs-tag-follow-cleanup            t
          treemacs-tag-follow-delay              1.5
          treemacs-user-mode-line-format         nil
          treemacs-user-header-line-format       nil
          treemacs-width                         35
          treemacs-workspace-switch-cleanup      nil)

    ;; The default width and height of the icons is 22 pixels. If you are
    ;; using a Hi-DPI display, uncomment this to double the icon size.
    ;;(treemacs-resize-icons 44)

    (treemacs-follow-mode t)
    (treemacs-filewatch-mode t)
    (treemacs-fringe-indicator-mode 'always)
    (pcase (cons (not (null (executable-find "git")))
                 (not (null treemacs-python-executable)))
      (`(t . t)
       (treemacs-git-mode 'deferred))
      (`(t . _)
       (treemacs-git-mode 'simple))))
  :bind
  (:map global-map
        ("M-0"       . treemacs-select-window)
        ("C-x j 1"   . treemacs-delete-other-windows)
        ("C-x j t"   . treemacs)
        ("C-x j B"   . treemacs-bookmark)
        ("C-x j C-t" . treemacs-find-file)
        ("C-x j M-t" . treemacs-find-tag)))

(use-package treemacs-evil
  :after treemacs evil
  :ensure t)

(use-package treemacs-projectile
  :after treemacs projectile
  :ensure t)

(use-package treemacs-icons-dired
  :after treemacs dired
  :ensure t
  :config (treemacs-icons-dired-mode))

(use-package treemacs-magit
  :after treemacs magit
  :ensure t)

(use-package treemacs-persp ;;treemacs-persective if you use perspective.el vs. persp-mode
  :after treemacs persp-mode ;;or perspective vs. persp-mode
  :ensure t
  :config (treemacs-set-scope-type 'Perspectives))

 (use-package org
  :ensure t
  ;;:ensure org-plus-contrib
  :load-path ("~/.emacs.d/site-lisp")
  :delight (org-mode "🦄" :major)
  :mode "\\.org\\(.gpg|_archive\\)?$"
  
  :bind
  ;("C-c t"  . orgtbl-mode)
  ("C-c l"  . org-store-link)
  ("C-c c"  . org-capture)
  ("C-c b"  . org-iswitchb)
  ("C-c a"  . org-agenda)
  ("C-c g" . org-clock-goto)
  ("C-c i" . org-clock-in)
  ("C-c o" . org-clock-out)

  :config
	    
    ;; Fold all source blocks on startup.
    (setq org-hide-block-startup t)

    ;; Lists may be labelled with letters.
    (setq org-list-allow-alphabetical t)

    ;; Avoid accidentally editing folded regions, say by adding text after an Org “⋯”.
    (setq org-catch-invisible-edits 'show)
    
    ;; I use indentation-sensitive programming languages.
    ;; Tangling should preserve my indentation.
    (setq org-src-preserve-indentation t)
    
    ;; Tab should do indent in code blocks
    (setq org-src-tab-acts-natively t)
    
    ;; Give quote and verse blocks a nice look.
    (setq org-fontify-quote-and-verse-blocks t)
    
    ;; Pressing ENTER on a link should follow it.
    (setq org-return-follows-link t)

)

(setq org-priority-highest "A"
org-priority-lowest "C")

    
(setq mu4e-org-contacts-file  "~/org/contacts.org")
  (add-to-list 'mu4e-headers-actions
    '("org-contact-add" . mu4e-action-add-org-contact) t)
  (add-to-list 'mu4e-view-actions
    '("org-contact-add" . mu4e-action-add-org-contact) t)


(defun helm-contacts (&optional arg)
  (interactive "P")
  (when arg
    (setq helm-org-contacts-cache nil))
  (helm :sources '(helm-source-org-contacts helm-source-mu-contacts)
        :full-frame t
        :candidate-number-limit 500))

 (require 'org-contacts)
 (require 'helm-org-contacts)

 (setq org-contacts-org-property "ORG")
 (setq org-contacts-email-property "EMAIL")
 (setq org-contacts-tel-property "PHONE")
 (setq org-contacts-cell-property "CELL")
 (setq org-contacts-address-property "ADDRESS")
 (setq org-contacts-city-property "CITY")
 (setq org-contacts-state-property "STATE")
 (setq org-contacts-zip-property "ZIP")
 (setq org-contacts-groups-property "GROUPS")
 (setq org-contacts-country-property "COUNTRY")
 (setq org-contacts-birthday-property "BIRTHDAY")
 (setq org-contacts-note-property "NOTE")

 (setq org-contacts-files '("~/org/contacts.org"
                           )


)

     ;; Agenda
;     (setq org-agenda-files (quote ("/Users/djruesch/org/inbox.org")))
     
;     (setq org-agenda-files (append '(file-expand-wildcards "~/org/journals/*.org")
;                                     (file-expand-wildcards "~/org/notes/*.org")
;				     ))

(setq org-agenda-files (list "~/org/organizer.org"
                             "~/org/journals/"
			     "~/org/clients/DJRuesch.org"
			     "~/org/clients/CodigoPD.org"
			     "~/org/clients/Bottles.org"
			     "~/org/clients/JexReality.org"
			     "~/org/clients/WheelWays.org"
			     "~/org/schedule.org"
			     )
      )

(setq org-agenda-skip-unavailable-files t)

  (use-package org-super-agenda
    :ensure t
    :requires (org-super-agenda-mode)
    :config
    (let ((org-super-agenda-groups
       '((:log t)  ; Automatically named "Log"
         (:auto-category t)
         (:name "Schedule"
                :time-grid t)
         (:name "Today"
                :scheduled today)
         (:habit t)
         (:name "Due today"
                :deadline today)
         (:name "Overdue"
                :deadline past)
         (:name "Due soon"
                :deadline future)
         (:name "Unimportant"
                :todo ("SOMEDAY" "MAYBE" "CHECK" "TO-READ" "TO-WATCH")
                :order 100)
         (:name "Waiting..."
                :todo "WAITING"
                :order 98)
         (:name "Scheduled earlier"
                :scheduled past))))
  (org-agenda-list))
    
  )

(setq org-todo-keywords
      '(
        (sequence "IDEA(i)" "TODO(t)" "TODAY(T)" "NEXT(n)"  "|" "DONE(d)")
        (sequence "|" "WAITING(w)" "CANCELED(c)" "DELEGATED(l)")
        ))

(setq org-todo-keyword-faces
      '(("IDEA" . (:foreground "magenta" :weight bold)) 
        ("TODO" . (:foreground "forest green" :weight bold))
        ("TODAY" . (:foreground "Orange" :weight bold))
        ("NEXT" . (:foreground "Blue" :weight bold))   
        ("WAITING" . (:foreground "coral" :weight bold)) 
        ("CANCELED" . (:foreground "LimeGreen" :weight bold))
        ("DELEGATED" . (:foreground "LimeGreen" :weight bold))
       	("DONE" . (:foreground "red" :weight bold))
        ))

(setq org-use-fast-todo-selection t)

;(setq current-journal-filename (concat "~/org/journals/" %(format-time-string org-journal-year-format) "/" %(format-time-string org-journal-file-format))
(defun org-journal-find-location ()
  ;; Open today's journal, but specify a non-nil prefix argument in order to
  ;; inhibit inserting the heading; org-capture will insert the heading.
  (org-journal-new-entry t)
  (unless (eq org-journal-file-type 'daily)
    (org-narrow-to-subtree))
  (goto-char (point-max)))

(setq org-capture-templates '())

 (setq org-capture-templates
	'( ("P" "Planning")
	   ("Pd" "Daily Planning" plain (file+datetree+prompt "~/org/journals/djruesch.org") (file "~/org/templates/daily_planning.org"))
	   ("P
w" "Weekly Review" plain (file+datetree+prompt "~/org/journals/djruesch.org") (file "~/org/templates/weekly_review.org"))
	   ("Pm" "Monthly Report" plain (file+datetree+prompt "~/org/journals/djruesch.org")(file "~/org/templates/monthly_report.org"))
	   
	   ("k" "Bookmarks")
	   ("kd" "DJRuesch" entry (file+headline (lambda () (personal-note 'djruesch)) "Bookmarks")"** %(org-cliplink-capture)%?\n" :unnarrowed t)
	   ("kc" "CodigoPD" entry (file+headline (lambda () (personal-notedit ../e 'codigopd)) "Bookmarks")"** %(org-cliplink-capture)%?\n" :unnarrowed t)
	   	  	   
	   ("m" "Meeting"  entry (file "~/org/organizer.org" "Inbox") 
	   "* %^{Name}\t\t\t%^G\n:PROPERTIES:\n:TYPE: Event\n:CATEGORY: %^{Client|DJRuesch|CodigoPD}\n :CREATED: %U\n:END:\n\nLocation: %?\n\nSCHEDULED: %^{Scheduled}t")
	   
	   ;("g" "Goal"  entry (file+headline "~/org/organizer.org" "Inbox")
	   ;"* %^{Name}\t\t\t:Goal:%^G\n:PROPERTIES:\n:TYPE: Goal\n:CATEGORY: %^{Client|DJRuesch|CodigoPD}\n:TERM:%^{Term|Long|Medium|Short}\n:CREATED: %U\n:END:\n\n%?\n\nDEADLINE: %^{Deadline}t")
	   

	   ;("p" "Project"  entry (file+headline "~/org/organizer.org" "Inbox")
   	   ;"* PROJECT - %^{Name}\t\t\t:Project:%^G\n:PROPERTIES:\n:Type: Project\n:Created: %U\n:END:\n%?" :prepend t)

	   ;("f" "Feature" entry (file+headline "~/org/organizer.org" "Inbox")
	   ;"* FEATURE - %?\t\t\t:Feature:%^G\n:PROPERTIES:\n:Type: Feature\nCREATED: %U\n:END:\n  %a" :clock-in t :clock-resume t)

	    ("i" "Idea" entry (file "~/org/organizer.org" "Inbox")
	   "*** IDEA %^{Name}\t\t\t:Idea:%^G\n:PROPERTIES:\n:Type: Idea\n:CATEGORY: %^{Client|DJRuesch|CodigoPD}\nCREATED: %U\n:END:\n%?" :clock-in t :clock-resume t)

	    ("j" "Jouranl")
	    ("jt" "Today's Entry" plain (function org-journal-today)
                               "** %(format-time-string org-journal-time-format)%^{Title}\n%i%?"
                               :jump-to-captured t :immediate-finish t)
	    ("jp" "Past Entry" plain (function org-journal-past)
                               "** %(format-time-string org-journal-time-format)%^{Title}\n%i%?"
                               :jump-to-captured t :immediate-finish t)
	    ("js" "Scheduled Entry" plain (function org-journal-scheduled)
                               "** TODO %?\n <%(princ org-journal--date-location-scheduled-time)>\n"
                               :jump-to-captured t)

	   ("t" "Todo" entry (file "~/org/organizer.org" "Inbox")
	   "* TODO %^{Name}\t\t\t:Todo:\n:PROPERTIES:\n:Type: Todo\n:CATEGORY: %^{Client|DJRuesch|CodigoPD}\n:CREATED: %U\n:END:\n%?\n" :clock-in t :clock-resume t)

	   ("n" "Next" entry (file "~/org/organizer.org" "Inbox")
	   "* NEXT %^{Name}\t\t\t:Todo:%^G\n:PROPERTIES:\n:Type: Next\n:CATEGORY: %^{Client|DJRuesch|CodigoPD}\nCREATED: %U\n:END:\n%?" :clock-in t :clock-resume t)

	   ("h" "Habit" entry (file "~/org/organizer.org" "Inbox") 
	   "* NEXT %^{Name}\t\t\t:Habit:\n:PROPERTIES:\n:CREATED: %U\n:CATEGORY: %^{Client|DJRuesch|CodigoPD}\n:STYLE: habit\n:REPEAT_TO_STATE: NEXT\n:LOGGING: DONE(!)\n:ARCHIVE: %%s_archive::* Habits\n:END:\n\nSCHEDULED: <%<%Y-%m-%d %a .+1d>>\n%U\n%?")
	   
	   ("n" "Notes")
	   ("nd" "DJRuesch" plain (file+datetree+prompt "~/org/DJRuesch/notes.org")
           "**** %^{Name}\n:PROPERTIES:\n:TYPE: Journal\n:CATEGORY: DJRuesch\n:CREATED: %U\n:END:\n\n%?")
	   ("nc" "CodigoPD" plain (file+datetree+prompt "~/org/CodigoPD/notes.org")
           "%K - %a\n%i\n\n%?")
	   
	   ("f" "Finance")
	   
	   ("fi" "Income")
	   ("fis" "Income:Salary" plain (file ledger-journal-file) "%(org-read-date) * receive %^{Received From} %^{For why}\nAssets:%^{Account|Personal|CodigoPD} %^{Amount} %^{Currency|CLP|USD}\nIncome:Salary\n")
            
	   ("fe" "Expense")
	   ("feg" "Expense:Gifts" plain (file ledger-journal-file) "%(org-read-date) * send %^{Send to} %^{For why}\nExpense:Gifts  %^{Amount} %^{Currency|CLP|USD}\nAssets:%^{Account|Personal|CodigoPD}\n")

	   ("c" "Contacts")
	   ("cd" "DJRuesch" entry (file "~/org/DJRuesch/contacts.org") "* %(org-contacts-template-name)\n:PROPERTIES:\n:EMAIL: %(org-contacts-template-email)\n:PHONE: %^{Phone| }\n:CELL: %^{Cell| }\n:ADDRESS: %^{Address| }\n:ADDRESS1: %^{Address 1| }\n:CITY: %^{City| }\n:STATE: %^{State| |Utah|O'Higgins}\n:ZIP: %^{Zip Code| }\n:COUNTRY: %^{Country|USA|Chile}\n:GROUPS: %^g\n:BIRTHDAY: %^{Birthday}t\n:END:\n\nNOTES:\n%?")
	   ("cc" "CodigoPD" entry (file "~/org/CodigoPD/contacts.org") "* %(org-contacts-template-name)\n:PROPERTIES:\n:EMAIL: %(org-contacts-template-email)\n:PHONE: %^{Phone| }\n:CELL: %^{Cell| }\n:ADDRESS: %^{Address| }\n:ADDRESS1: %^{Address 1| }\n:CITY: %^{City| }\n:STATE: %^{State| |Utah|O'Higgins}\n:ZIP: %^{Zip Code| }\n:COUNTRY: %^{Country|USA|Chile}\n:GROUPS: %^g\n:BIRTHDAY: %^{Birthday}t\n:END:\n\nNOTES:\n%?")
	   
	   ("B" "Blogs")
	   ("Bc" "CodigoPD" entry (file+olp+datetree "~/org/CodigoPD/blog.org")
	   "* %^{Title: }\t\t\t:CodigoPD:\n:PROPERTIES:\n:Type: Blog\n:Status: %^{Staus|Idea|Draft|Published}\n:Author: Del Ruesch\n:Created: %U\n:END:\n\n%?")
	   
	   
	   ))

(setq org-tag-persistent-alist 
      '((:startgroup . nil)
        ("Long-Term" . ?l) 
        ("Medium-Term" . ?m)
        ("Short-Term" . ?s)
        (:endgroup . nil)
        
	(:startgroup . nil)
        ("Project" . ?p) 
        ("Feature" . ?f)
        ("Task" . ?t)
        (:endgroup . nil)
        
	(:startgroup . nil)
        ("Idea" . ?i)
        ("Draft" . ?d)
        ("Published" . ?p)
        (:endgroup . nil)
        
	("@Home" . ?h)
        ("@Work" . ?w)
        ("@Church" . ?c)
        ("@Other" . ?o)  
        )
      )

(setq org-tag-faces
      '(
        ("Long-Term" . (:foreground "GoldenRod" :weight bold))
        ("Medium-Term" . (:foreground "GoldenRod" :weight bold))
        ("Short-Term" . (:foreground "GoldenRod" :weight bold))
        
        ("Project" . (:foreground "IndianRed1" :weight bold))   
        ("Feature" . (:foreground "IndianRed1" :weight bold))   
        ("Task" . (:foreground "IndianRed1" :weight bold))
        
	("Idea" . (:foreground "Red" :weight bold))  
        ("Draft" . (:foreground "Red" :weight bold))  
        ("Pubished" . (:foreground "OrangeRed" :weight bold))  
        
	("@Home" . (:foreground "OrangeRed" :weight bold))  
        ("@Work" . (:foreground "OrangeRed" :weight bold))  
        ("@Church" . (:foreground "GoldenRod" :weight bold))
        ("@Other" . (:foreground "LimeGreen" :weight bold))  
        )
)

(setq org-fast-tag-selection-single-key t)

 (setq org-publish-project-alist
	`(("posts"
           :base-directory "~/org/journals"
           ;;:remote (git "git@github.com:jonathanabennett/jonathanabennett.github.io.git" "master")
           ;;:source-browse-url ("Github" "https://jonathanabennett/jonathanabennett.github.io.git")
           ;;:site-domain "https://jonathanabennett.github.io/"
           :site-main-title "Step by Step"
           :site-sub-title "On the Way Home"
           :recursive t
           :publishing-directory "~/Sites/journals/"
           :section-numbers nil
           :with-title t
           :with-date t
	   :with-toc t
           :html-doctype "html5"
           :html-html5-fancy t
	   :html-head "<link rel=\"stylesheet\" href=\"../other/mystyle.css\" type=\"text/css\"/>"
           :html-head-include-default-style t
           :html-head-include-scripts t
	   :html-preamble t
           :htmlized-source t
           :publishing-function org-html-publish-to-html)

          ("photos"
           :base-directory "~/org/journals/photos"
           :base-extension "png\\|jpeg\\|jpg\\|gif\\|pdf"
           :publishing-directory "~/Sites/photos"
           :recursive t
           :publishing-function org-publish-attachment)

          ("static"
           :base-directory "~/org/journals"
           :base-extension "css\\|js\\|png\\|jpg\\|gif\\|pdf\\|mp3\\|ogg\\|swf"
           :publishing-directory "~/Sites/static/journal"
           :recursive t
           :publishing-function org-publish-attachment)


  ("journal"
           :components ("posts" "photos" "static"))
  ))

(use-package deft
      :after org
      :ensure t
      :bind
      ("C-c n d" . deft)
      :custom
      (deft-recursive t)
      (deft-use-filter-string-for-filename t)
      (deft-default-extension "org")
      (deft-directory "~/org/brain/"))

    (use-package org-roam
      :after org
      :ensure t
      :delight " 𝕫"
      :hook
      (after-init . org-roam-mode)
      
      :custom
      (org-roam-directory "~/org/brain/")
      (org-roam-graph-executable "/usr/local/bin/dot")
      
      (setq org-link-file-path-type "absolute")

      :bind (:map org-roam-mode-map
		  (("C-c n l" . org-roam)
		   ("C-c n f" . org-roam-find-file)
		   ("C-c n g" . org-roam-show-graph))
	     :map org-mode-map
		  (("C-c n i" . org-roam-insert))
		  (("C-c n I" . org-roam-insert-immediate))))

   (use-package org-roam-bibtex
     :after org-roam
     :hook (org-roam-mode . org-roam-bibtex-mode)
     :bind (:map org-mode-map
            (("C-c n a" . orb-note-actions))))

  (use-package org-ref
     :after org
     :requires (org-bibtex)
     :config
       (require 'org-ref)

       (setq reftex-default-bibliography '("~/org/bibtex/references.bib"))

       ;; see org-ref for use of these variables
       (setq org-ref-bibliography-notes "~/org/notes.org"
	 org-ref-default-bibliography '("~/org/bibtex/references.bib")
	 org-ref-pdf-directory "~/org/bibtex/bibtex-pdfs/")
     
       (setq bibtex-completion-bibliography "~/org/bibtex/references.bib"
	 bibtex-completion-library-path "~/org/bibtex/bibtex-pdfs"
	 bibtex-completion-notes-path "~/org/bibtex/helm-bibtex-notes")
     
       ;; open pdf with system pdf viewer (works on mac)
       (setq bibtex-completion-pdf-open-function
       (lambda (fpath)
	 (start-process "open" "*open*" "open" fpath)))
     
       (setq org-latex-pdf-process (list "latexmk -shell-escape -bibtex -f -pdf %f"))



       (defun org-ref-noter-at-point ()
	 "Open the pdf for bibtex key under point if it exists."
	 (interactive)
	 (let* ((results (org-ref-get-bibtex-key-and-file))
             (key (car results))
             (pdf-file (funcall org-ref-get-pdf-filename-function key)))
           (if (file-exists-p pdf-file)
               (progn
              (find-file-other-window pdf-file)
              (org-noter))
          (message "no pdf found for %s" key))))

       (add-to-list 'org-ref-helm-user-candidates 
             '("Org-Noter notes" . org-ref-noter-at-point))

       (setq org-ref-bibliography-notes "~/org/notes.org")
       (setq org-ref-notes-function #'org-ref-notes-function-one-file)
   )

(use-package org-noter
    :after org
    :ensure t
    :config (setq org-noter-default-notes-file-names '("notes.org")
                  org-noter-notes-search-path '("~/org/notes")
                  org-noter-separate-notes-from-heading t
		  org-noter-set-auto-save-last-location t)
)

(setq ledger-journal-file "~/org/current.ledger")

(defun org-journal-save-entry-and-exit()
  "Simple convenience function.
  Saves the buffer of the current day's entry and kills the window
  Similar to org-capture like behavior"
  (interactive)
  (save-buffer)
  (kill-buffer-and-window))

(defvar org-journal--date-location-scheduled-time nil)

(defun org-journal-today (&optional scheduled-time)
  (let ((scheduled-time (or scheduled-time (org-read-date nil nil nil "Date:"))))
    (setq org-journal--date-location-scheduled-time scheduled-time)
    (org-journal-new-entry t (org-time-string-to-time scheduled-time))
    (unless (eq org-journal-file-type 'daily)
      (org-narrow-to-subtree))
    (goto-char (point-max))))


(defun org-journal-past (&optional scheduled-time)
  (let ((scheduled-time (or scheduled-time (org-read-date nil nil nil "Date:"))))
    (setq org-journal--date-location-scheduled-time scheduled-time)
    (org-journal-new-date-entry t (org-time-string-to-time scheduled-time))
    (unless (eq org-journal-file-type 'daily)
      (org-narrow-to-subtree))
    (goto-char (point-max))))

(defun org-journal-scheduled ()
  ;; Open today's journal, but specify a non-nil prefix argument in order to
  ;; inhibit inserting the heading; org-capture will insert the heading.
  (org-journal-new-scheduled-entry t)
  ;; Position point on the journal's top-level heading so that org-capture
  ;; will add the new entry as a child entry.
  (goto-char (point-min)))

;(defun org-journal-past ()
  ;; Open today's journal, but specify a non-nil prefix argument in order to
  ;; inhibit inserting the heading; org-capture will insert the heading.
 ; (org-journal-new-date-entry t)
  ;; Position point on the journal's top-level heading so that org-capture
  ;; will add the new entry as a child entry.
 ; (goto-char (point-min)))

(defun org-journal-file-header-func (time)
  "Custom function to create journal header."
  (concat
    (pcase org-journal-file-type
      (`daily "#+TITLE: Daily Journal\n#+STARTUP: showeverything")
      (`weekly "#+TITLE: Weekly Journal\n#+STARTUP: folded")
      (`monthly "#+TITLE: Monthly Journal\n#+STARTUP: folded")
      (`yearly "#+TITLE: Yearly Journal\n#+STARTUP: folded"))))

(setq org-journal-file-header 'org-journal-file-header-func)


(use-package org-journal
:ensure t
:requires (org-journal)

:config
(define-key org-journal-mode-map (kbd "C-x C-s") 'org-journal-save-entry-and-exit)

)


(customize-set-variable 'org-journal-file-type 'daily)
(customize-set-variable 'org-journal-dir "~/org/journal/")
(customize-set-variable 'org-journal-file-format "%Y-%m-%d.org")
(customize-set-variable 'org-journal-date-format "%e %b %Y - (%A)")
(customize-set-variable 'org-journal-time-format "%H:%M")
(customize-set-variable 'org-journal-year-format "%Y")
(customize-set-variable 'org-journal-date-prefix "* ")
(customize-set-variable 'org-journal-time-prefix "** ")
(customize-set-variable 'org-journal-enable-agenda-integration t)
(setq org-journal-enable-cache t)

(setq org-refile-targets (quote ((nil :maxlevel . 9)
    (org-agenda-files :maxlevel . 9))))

(setq org-refile-use-outline-path t)
(setq org-outline-path-complete-in-steps nil)

;; Allow refile to create parent tasks with confirmation
(setq org-refile-allow-creating-parent-nodes 'confirm)

(org-babel-do-load-languages
 'org-babel-load-languages
 '(
   (emacs-lisp . t)
   (org . t)
   (shell . t)
   (C . t)
   (python . t)
   (gnuplot . t)
   (octave . t)
   (R . t)
   (dot . t)
   (awk . t)
   ))

(require 'org-bullets)
(setq org-bullets-bullet-list '("☯" "○" "✸" "✿" "~"))
(add-hook 'org-mode-hook (lambda () (org-bullets-mode 1)))

(use-package org-cliplink
:ensure t
:requires (org-cliplink)
)

(defun personal-note (ntype)
  (cond
    ((string= 'djruesch ntype) (concat org-directory (format-time-string "/DJRuesch/bookmarks.org")))
    ((string= 'codigopd ntype) (concat org-directory (format-time-string "/CodigoPD/bookmarks.org")))
    (t (error "Invalid personal note type: " ntype))))

(use-package editorconfig
  :ensure t
  :config
  (editorconfig-mode 1))

(use-package elpy
  :ensure t
  :init
  (elpy-enable)
 :config
 (setq elpy-rpc-python-command "python3")
)

(setq debug-on-error nil)
(setq debug-on-quit nil)

(let ((elapsed (float-time (time-subtract (current-time)
					  emacs-start-time))))
  (message "LOADING SETTINGS TIME - (%.3fs)" elapsed))
(put 'narrow-to-region 'disabled nil)
