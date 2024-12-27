;;
;; Emacs configuration file.
;;
;; Version 3. (Started blank 2020.)
;;
;;
;; Sections in this file:
;;
;; 1. Constants and OS specific hackery
;; 2. Initialization of Emacs herself
;; 3. Utilities for customising dotfiles
;; 4. Additions and configuration of text editing
;; 5. Color theme
;; 6. Custom keybindings
;;


;;
;; 1. Constants and OS specific hackery
;;
(defvar ~
  (expand-file-name "~/"))

(add-to-list 'load-path
              "~/.emacs.d/site-packages/")

;; Allow hash to be entered
(global-set-key (kbd "M-3") (lambda () (interactive) (insert "#")))


;; 2. Initialization of Emacs herself

(setq inhibit-startup-message t)
(if (fboundp 'scroll-bar-mode) (scroll-bar-mode -1)) ;; Don't show junk scrollbars
(if (fboundp 'tool-bar-mode) (tool-bar-mode -1))     ;; Don't show shonky floppy disk icon
(if (fboundp 'menu-bar-mode) (menu-bar-mode -1))     ;; Don't show menu bar
(column-number-mode 1)                               ;; Do show columns
(display-time)                                       ;; In the modeline
(setq-default cursor-type 'bar)                      ;; The box is quite big
(setq ring-bell-function 'ignore)                    ;; Shhhhhhh. (Disable bell function)
(defalias 'yes-or-no-p 'y-or-n-p)                    ;; Less typing for me
(add-to-list 'default-frame-alist                    ;; New windows start maximized
	     '(fullscreen . maximized))


(defun emacs-reloaded ()
  "Wander about-type stuff for initialization. Neat. Not useful at all.
For anything. Seriously."
  (switch-to-buffer "*scratch*")
  (animate-string (concat ";; Initialization successful, welcome to "
                          (substring (emacs-version) 0 16)
                          ". \n;; Loaded with .emacs enabled\n\n;; This is your newer fresher emacs config for the second roaring 20s.")
                  0 0)
  (newline-and-indent)  (newline-and-indent))

(defconst animate-n-steps 10)
(add-hook 'after-init-hook 'emacs-reloaded)



;;
;; 3. Utilities for customising dotfiles
;;

(defmacro dotfile (filename &optional path)
  "Define the function`filename to edit the dotfile in question"
  (let ((filestr (symbol-name filename)))
    `(progn
       (defun ,(intern filestr) ()
	 ,(format "Open %s for editing" filestr)
	 (interactive)
	   (find-file ,(if path path (concat ~ filestr)))))))

(dotfile .emacs)
(dotfile .zshrc)
(dotfile .screenrc)
(dotfile .gitconfig)

;;
;; 4. Additions and configuration of text editing
;;

(defun rename-current-file-or-buffer ()
  (interactive)
  (if (not (buffer-file-name))
      (call-interactively 'rename-buffer)
    (let ((file (buffer-file-name)))
      (with-temp-buffer
        (set-buffer (dired-noselect file))
        (dired-do-rename)
        (kill-buffer nil))))
  nil)


(show-paren-mode 1)                 ;; Highlight parenthesis pairs
(delete-selection-mode t)           ;; Delete contents of region when we start typing
(setq-default indent-tabs-mode nil) ;; Spaces instead of tabs
(setq tab-width 4)

;; We basically never want trailing whitespace in files.
(add-hook 'before-save-hook 'delete-trailing-whitespace)

(electric-pair-mode)

(ido-mode t)                      ;; Better find file/buffer
(setq ido-enable-flex-matching t) ;; enable fuzzy matching

(require 'dired-x)                  ;; For ommitting files
(setq-default dired-omit-files-p t) ;; This is the buffer-local variable
(setq dired-omit-files
      ;; kill magic . .. as well as .pyc and emacs *~ files
      (concat dired-omit-files "\\|^\\..+$\\|\\.pyc$\\|\\*~$"))


(add-to-list 'load-path
              "~/.emacs.d/site-packages/yasnippet")
(require 'yasnippet)
(yas-global-mode 1)


(require 'opal-mode)



;;
;; 5. Color theme
;;
(add-to-list 'custom-theme-load-path "~/.emacs.d/")
(load-theme 'epistrophy)


;;
;; 6. Custom keybindings
;;

(defmacro gset-key (pairs)
  "Globally set `pairs' as (binding symbol)"
  (let ((bindings (mapcar (lambda (b) (cons 'global-set-key b)) pairs)))
  `(progn ,@bindings)
  ))

(gset-key (
       ("\C-x\C-b" 'ibuffer)  ;; Ibuffer is part of Emacs & nicer than the default

       ([M-left] 'windmove-left)   ;; Move to left windnow
       ([M-right] 'windmove-right) ;; Move to right window
       ([M-up] 'windmove-up)       ;; Move to upper window
       ([M-down] 'windmove-down)   ;; Move to downer window
       ))
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-safe-themes
   '("0d5285aadfe9f771b865379fed216239b5fb145972c23e9a29fcff6f9a005a38" default)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
(put 'downcase-region 'disabled nil)
