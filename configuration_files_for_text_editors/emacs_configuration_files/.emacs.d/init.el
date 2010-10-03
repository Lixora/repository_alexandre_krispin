;Time-stamp: <2010-09-30 14:23:10 (freeman)>
;;##################################################################################################
;;##################################################################################################
 
 						   ; LaTeX
 					   
;;##################################################################################################

; ------------------------------------------------------------------------------------------------------------------
						;; load AucTeX etc
; ------------------------------------------------------------------------------------------------------------------
(require 'tex-site)
(require 'tex-style)
; ------------------------------------------------------------------------------------------------------------------
					; To turn on RefTeX Minor Mode for all LaTeX files, and other
; ------------------------------------------------------------------------------------------------------------------
(add-hook 'LaTeX-mode-hook 'turn-on-reftex)   ; with AUCTeX LaTeX mode
(add-hook 'reftex-load-hook 'imenu-add-menubar-index)
(add-hook 'reftex-mode-hook 'imenu-add-menubar-index)

(add-hook 'LaTeX-mode-hook
          '(lambda ()
             (setq TeX-open-quote "«~")
             (setq TeX-close-quote "~»")
             (auto-fill-mode t)
             ))
             
; ------------------------------------------------------------------------------------------------------------------
					; Smart quotes
; ------------------------------------------------------------------------------------------------------------------
(setq TeX-open-quote "<<")
(setq TeX-close-quote ">>")

; ------------------------------------------------------------------------------------------------------------------
					;LaTeX-math and other usefull stuff
; see http://www.emacswiki.org/emacs/AUCTeX
; ------------------------------------------------------------------------------------------------------------------
(add-hook 'LaTeX-mode-hook 'LaTeX-math-mode)
(add-hook 'LaTeX-mode-hook 'auto-fill-mode)
(add-hook 'LaTeX-mode-hook 'flyspell-mode)


;;; ------------------------ dictionnaire - correction orthographique -----------
;(setq-default ispell-program-name "hunspell")

;(add-hook 'text-mode-hook
;     (lambda ()
;        (flyspell-mode 1)
;        (ispell-change-dictionary "francais")
;        (turn-on-auto-fill)
;))
;--------------------------------------------------------------------------------------------------
				; completion, style file, or multi-file stuff work
;--------------------------------------------------------------------------------------------------
(setq TeX-auto-save t)
(setq TeX-parse-self t)
;--------------------------------------------------------------------------------------------------
					;;Mode PDFLatex par défaut ou non
;--------------------------------------------------------------------------------------------------
(setq TeX-PDF-mode t); pour mettre par défaut décommenter cette ligne et commenter celle du dessous

;--------------------------------------------------------------------------------------------------
					;;Visualiseurs
;--------------------------------------------------------------------------------------------------
(setq TeX-output-view-style (quote (
      ("^pdf$" "." "evince %o")
      ("^ps$" "." "gv %o")
      ("^dvi$" "." "xdvi %o")
      )))
      (setq tex-dvi-view-command "xdvi")
(setq tex-dvi-print-command "dvips")
(setq tex-alt-dvi-print-command "dvips")

;------------------------------------------------------------------------------------------------
; Shortcut for compiling and viewing
;------------------------------------------------------------------------------------------------
(global-set-key [f4] 'XeLaTeX)

;--------------------------------------------------------------------------------------------------
;; Pour aller a la ligne automatiquement 
;--------------------------------------------------------------------------------------------------
(turn-on-auto-fill)

; ------------------------------------------------------------------------------------------------------------------
					; Autopairs
;see http://autopair.googlecode.com/svn/trunk/autopair.el
; ------------------------------------------------------------------------------------------------------------------
(add-to-list 'load-path "~/.emacs.d/lisp")
(require 'autopair)
(autopair-global-mode) ;; to enable in all buffers

;see http://www.emacswiki.org/emacs/AutoPairs#Discussion
; -------------------------------------------------
    (setq skeleton-pair t) ; enable pairing
    
; ------------------------------------------------------------------------------------------------------------------
					; master file
; ------------------------------------------------------------------------------------------------------------------
(setq-default TeX-master nil)
 TeX-master nil
 
;; ;;; ------------------------ Template -------------------------------
;; (setq load-path (cons (expand-file-name "~/.emacs.d/lisp")
;;                             load-path))
;; (require 'template)
;; (template-initialize)
;; ;;;; If you don't want to use yasnippet, look download the tarball here :
;; ;;;; voir http://emacs-template.sourceforge.net/

; ------------------------------------------------------------------------------------------------------------------
					; Wrapping the region in double quotes
; ------------------------------------------------------------------------------------------------------------------
    (defadvice TeX-insert-quote (around wrap-region activate)
      (cond
       (mark-active
        (let ((skeleton-end-newline nil))
          (skeleton-insert `(nil ,TeX-open-quote _ ,TeX-close-quote) -1)))
       ((looking-at (regexp-opt (list TeX-open-quote TeX-close-quote)))
        (forward-char (length TeX-open-quote)))
       (t
        ad-do-it)))
    (put 'TeX-insert-quote 'delete-selection nil)

; ------------------------------------------------------------------------------------------------------------------
					; Inserting and wrapping single quotes
; ------------------------------------------------------------------------------------------------------------------
    (defun TeX-insert-single-quote (arg)
      (interactive "p")
      (cond
       (mark-active
        (let ((skeleton-end-newline nil))
          (skeleton-insert
           `(nil ?` _ ?') -1)))
       ((or (looking-at "\\<")
            (looking-back "^\\|\\s-\\|`"))
        (insert "`"))
       (t
        (self-insert-command arg))))

    (add-hook 'LaTeX-mode-hook
              '(lambda ()
                 (local-set-key "'" 'TeX-insert-single-quote)))

; ------------------------------------------------------------------------------------------------------------------
 ;;set xetex mode in tex/latex
; ------------------------------------------------------------------------------------------------------------------
(add-hook 'LaTeX-mode-hook (lambda()
(add-to-list 'TeX-command-list '("XeLaTeX" "%`xelatex%(mode)%' %t" TeX-run-TeX nil t))
(setq TeX-command-default "XeLaTeX")
(setq TeX-save-query nil)
(setq TeX-show-compilation t)
))

;------------------------------------------------------------------------------------------------
					;Whizzy TeX
;------------------------------------------------------------------------------------------------

;; (setq my-toggle-whizzy-count 0)
;; (defun my-toggle-whizzy-mode ()
;;   (interactive)
;;   (if (= (mod my-toggle-whizzy-count 2) 0)
;;       (progn     
;;         (whizzytex-mode)
;;         (message "WhizzyTeX on"))
;;     (progn 
;;       (whizzy-mode-off)
;;       (kill-buffer (concat "*" (buffer-name) "*"))
;;       (message "WhizzyTeX off")))
;;   (setq my-toggle-whizzy-count (+ my-toggle-whizzy-count 1)))

;; (add-hook 'LaTeX-mode-hook
;;           (lambda ()
;;             (define-key LaTeX-mode-map (kbd "<f9>") 'my-toggle-whizzy-mode)))

;---------------------------------------------------------------------------------
					;Yasnippet
;; Auto completion / snippets
(add-to-list 'load-path "~/.emacs.d/lisp/yasnippet.el")
(require 'yasnippet)
(setq yas/root-directory "~/.emacs.d/snippets")
(yas/load-directory yas/root-directory)
(yas/global-mode)
(define-key global-map [f6] 'yas/expand)
(require 'dropdown-list)

;;       (setq yas/prompt-functions '(yas/dropdown-prompt
;;                                    yas/ido-prompt
;;                                    yas/completing-prompt))

;;##################################################################################################
;;				;; GNUPlot
;;##################################################################################################           
  (add-to-list 'load-path "~/emacs.d/lisp/")
  (autoload 'gnuplot-mode "gnuplot" "gnuplot major mode" t)
  (autoload 'gnuplot-make-buffer "gnuplot" "open a buffer in gnuplot mode" t)

;; this line automatically causes all files with the .gp extension to
;; be loaded into gnuplot mode
  (setq auto-mode-alist (append '(("\\.gp$" . gnuplot-mode)) auto-mode-alist))

;; This line binds the function-9 key so that it opens a buffer into
;; gnuplot mode 
  (global-set-key [(f9)] 'gnuplot-make-buffer)

;;##################################################################################################
;;				 key board / input method settings
;;################################################################################################## 

;--------------------------------------------------------------------------------------------------
;; key board / input method settings
(setq locale-coding-system 'utf-8)
(set-terminal-coding-system 'utf-8)
(set-keyboard-coding-system 'utf-8)
(set-language-environment 'UTF-8)       ; prefer utf-8 for language settings
(setq read-quoted-char-radix 10)         ; use decimal, not octal
(load-library "iso-transl") ; for accent ^
;see http://tldp.org/HOWTO/Keyboard-and-Console-HOWTO-12.html
;http://www.docmirror.net/fr/linux/howto/hardware/Keyboard-and-Console-HOWTO/Keyboard-and-Console-HOWTO-8.html
;http://www.faqs.org/docs/Linux-HOWTO/Keyboard-and-Console-HOWTO.html
;(iso-accents-customize french)
;;; Pour le clavier
;(load-library "iso-ascii")
;(load-library "iso-insert")
;(iso-accents-mode)


;--------------------------------------------------------------------------------------------------
			;Keyboard shortcuts
;--------------------------------------------------------------------------------------------------
(add-to-list 'load-path "~/.emacs.d/lisp/")
(require 'redo)
(define-key global-map (kbd "C-_") 'undo)
(define-key global-map (kbd "C-x C-_") 'redo)
;if you want to keep the C-w, M-w, and C-y original settings, there is a way is to bind cut, 
;copy and past keys by using the default X11 :
;http://www.emacswiki.org/emacs/CopyAndPaste
;; (global-set-key [(shift delete)] 'clipboard-kill-region)
;; (global-set-key [(control insert)] 'clipboard-kill-ring-save)
;; (global-set-key [(shift insert)] 'clipboard-yank)

;;######################################################################################################
					;; MENUS, BUFFERS...
;;######################################################################################################
;--------------------------------------------------------------------------------------------------
;;disable menu, toolbar, scrollbar
;--------------------------------------------------------------------------------------------------
(tool-bar-mode -1)
(toggle-scroll-bar -1)
;(set-scroll-bar-mode 'right)                                    ;;スクロールバーを右に表示
(menu-bar-mode 1)
;--------------------------------------------------------------------------------------------------
				;menu avec les buffer dans une tabbar
				; thanks to http://www.emacswiki.org/emacs/TabBarMode
;--------------------------------------------------------------------------------------------------
(add-to-list 'load-path "/usr/share/emacs/site-lisp/emhacks")
(require 'tabbar)
(tabbar-mode 1)

;; the following is taken from http://d.hatena.ne.jp/alfad/20100425/1272208744
;; 左に表示されるボタンを無効化
;-----------------------------------
;(setq tabbar-home-button-enabled "")
;(setq tabbar-scroll-left-button-enabled "")
;(setq tabbar-scroll-right-button-enabled "")
(setq tabbar-scroll-left-button-disabled "")
(setq tabbar-scroll-right-button-disabled "")

;; Firefoxライクなキーバインドに
;-----------------------------------
(global-set-key [(f8)] 'tabbar-forward)
(global-set-key [(f7)] 'tabbar-backward)

;all tabs is just one group
;-----------------------------------
 (setq tabbar-buffer-groups-function
          (lambda ()
            (list "All"))) ;; code by Peter Barabas

;--------------------------------------------------------------------------------------------------
				; one more item n the menu for new files
;--------------------------------------------------------------------------------------------------

(define-key menu-bar-file-menu [new-file]
  '(menu-item "New..." find-file
	      :enable (menu-bar-non-minibuffer-window-p)
	      :help "Specify a new file's name, to edit the file"))

;--------------------------------------------------------------------------------------------------
				;; A list of recent files
;--------------------------------------------------------------------------------------------------

(require 'recentf)
(setq recentf-exclude '("^/ftp.*" "^/ssh.*" "^/private.*" ))
(setq recentf-save-file "~/.emacs.d/recentf")
(recentf-mode 1)

;; GS-05/07/2006-12:15
;; http://www.emacswiki.org/cgi-bin/wiki/RecentFiles#toc6
(defun recentf-interactive-complete ()
  "find a file in the recently open file using iswitchb for completion"
  (interactive)
  (let* ((all-files recentf-list)
         (file-assoc-list (mapcar (lambda (x) (cons (file-name-nondirectory x) x)) all-files))
         (filename-list (remove-duplicates (mapcar 'car file-assoc-list) :test 'string=))
         (iswitchb-make-buflist-hook
          (lambda ()
            (setq iswitchb-temp-buflist filename-list)))
         (filename (iswitchb-read-buffer "Find Recent File: "))
         (result-list (delq nil (mapcar (lambda (x) (if (string= (car x) filename) (cdr x))) file-assoc-list)))
         (result-length (length result-list)))
         (find-file 
          (cond 
           ((= result-length 0) filename)
           ((= result-length 1) (car result-list))
           ( t
            (let ( (ido-make-buffer-list-hook
                     (lambda ()
                       (setq iswitchb-temp-buflist result-list))))
               (iswitchb-read-buffer (format "%d matches:" result-length))))
           ))))

;; to open recent files with keyboard
;;(global-set-key "\C-x\C-r" 'recentf-open-files-compl)
(global-set-key "\C-x\C-r" 'recentf-interactive-complete)

;--------------------------------------------------------------------------------------------------
						;; the minibuffer
;--------------------------------------------------------------------------------------------------
(setq
  enable-recursive-minibuffers nil         ;;  allow mb cmds in the mb
  max-mini-window-height .25             ;;  max 2 lines
  minibuffer-scroll-window nil
  resize-mini-windows nil)

;(icomplete-mode t)                       ;; completion in minibuffer
;; (setq 
;;   icomplete-prospects-height 1           ;; don't spam my minibuffer
;;   icomplete-compute-delay 0)             ;; don't wait
;; (require 'icomplete+ nil 'noerror)       ;; drew adams' extras

;;################################################################################################
				;; FULLSCREEN : appuyer sur F11
				;;thanks to http://www.emacswiki.org/emacs/FullScreen
;;################################################################################################

; -----------------------------------------------------------------------------------
    				;F11 is for fullscreen
; -----------------------------------------------------------------------------------
    (defun fullscreen (&optional f)
      (interactive)
      (set-frame-parameter f 'fullscreen
                           (if (frame-parameter f 'fullscreen) nil 'fullboth)))

    (global-set-key [f11] 'fullscreen)

    (add-hook 'after-make-frame-functions 'fullscreen)
; -----------------------------------------------------------------------------------
			    ;Send X Messages to the Window Manager
; -----------------------------------------------------------------------------------
 (defun fullscreen ()
       (interactive)
       (x-send-client-message nil 0 nil "_NET_WM_STATE" 32
	   		 '(2 "_NET_WM_STATE_FULLSCREEN" 0)))

; -----------------------------------------------------------------------------------
			; fullscreen mode	    		 
; --------------------------------------------------------------------------------------
	    		 (run-with-idle-timer 0.1 nil 'fullscreen)

; -----------------------------------------------------------------------------------------
			;To maximize the window only, uncomment
; -----------------------------------------------------------------------------------------
	    		  (defun fullscreen (&optional f)
       (interactive)
       (x-send-client-message nil 0 nil "_NET_WM_STATE" 32
	    		 '(2 "_NET_WM_STATE_MAXIMIZED_VERT" 0))
       (x-send-client-message nil 0 nil "_NET_WM_STATE" 32
	    		 '(2 "_NET_WM_STATE_MAXIMIZED_HORZ" 0)))


;;#################################################################################################
;;                          		   MOUSE, CURSOR
;;#################################################################################################

(mouse-wheel-mode t)
   (setq scroll-conservatively 10000)

;--------------------------------------------------------------------------------------------------
    ;; If you like to get a scroll one line at a time (less "jumpy" than defaults), uncomment
    	;;thanks to http://www.emacswiki.org/emacs/SmoothScrolling
;--------------------------------------------------------------------------------------------------    
  ;  (setq mouse-wheel-scroll-amount '(1 ((shift) . 1))) ;; one line at a time
    
   (setq mouse-wheel-progressive-speed nil) ;; don't accelerate scrolling
  ;     (setq mouse-wheel-progressive-speed true) ;;accelerate scrolling
    
   ;(setq mouse-wheel-follow-mouse 't) ;; scroll window under mouse
    
   ;(setq scroll-step 1) ;; keyboard scroll one line at a time
;(setq scroll-step 0) ;; keyboard don't scroll one line at a time

;--------------------------------------------------------------------------------------------------
		 ; Molette de la souris
;--------------------------------------------------------------------------------------------------
    (defun up-slightly () (interactive) (scroll-up 5))
    (defun down-slightly () (interactive) (scroll-down 5))
    (global-set-key [mouse-4] 'down-slightly)
    (global-set-key [mouse-5] 'up-slightly)
    (defun up-one () (interactive) (scroll-up 1))
    (defun down-one () (interactive) (scroll-down 1))
    (global-set-key [S-mouse-4] 'down-one)
    (global-set-key [S-mouse-5] 'up-one)
    (defun up-a-lot () (interactive) (scroll-up))
    (defun down-a-lot () (interactive) (scroll-down))
    (global-set-key [C-mouse-4] 'down-a-lot)
    (global-set-key [C-mouse-5] 'up-a-lot)

;--------------------------------------------------------------------------------------------------    
    		;; curseur en barre et non clignotant
;--------------------------------------------------------------------------------------------------
;;(setq cursor-type 'bar) -> default-frame-alist
(blink-cursor-mode 0)
;;(set-cursor-color "black")

;--------------------------------------------------------------------------------------------------
		; Laisser le curseur en place lors d'un défilement par pages.
		; Par défaut, Emacs place le curseur en début ou fin d'écran
		; selon le sens du défilement.
;--------------------------------------------------------------------------------------------------

;(setq scroll-preserve-screen-position t)

;--------------------------------------------------------------------------------------------------
		;; Use box cursor for overwrite-mode, and red cursor for quail active input.
		;;thanks to http://www.jurta.org/en/emacs/dotemacs
;--------------------------------------------------------------------------------------------------
(defun my-change-cursor ()
  "Change cursor color and type depending on insertion mode and input method."
  (set-cursor-color
   (cond (current-input-method "red3") ; "AntiqueWhite4"
         ((eq (frame-parameter (selected-frame) 'background-mode) 'dark)
                               "DarkGrey")
         (t                    "black")))
  (setq default-cursor-type ;; set-cursor-type
   (cond (overwrite-mode       'box)
         (t                    'bar))))
(add-hook 'post-command-hook 'my-change-cursor)



;;###########################################################################################################
;;                 		Title bar
;;###########################################################################################################

(setq frame-title-format '(buffer-file-name "Emacs: %b (%f)" "Emacs: %b")) ;CHEMIN COMPLET DANS LA BARRE DE TITRE

;--------------------------------------------------------------------------------------------------
;; de jolis noms pour les buffers sur un meme *nom* de fichier
;--------------------------------------------------------------------------------------------------
(require 'uniquify)
(setq uniquify-buffer-name-style 'post-forward-angle-brackets)

;;##################################################################################################
					;;Writing
;;##################################################################################################

;-------------------------------------------------------------------------------
		;; Complétion automatique
		;;Work in progress
;;see http://www.dr-qubit.org/emacs.php
;-------------------------------------------------------------------------------
;-----------------------------------------------------------------
 (abbrev-mode t) ; completion automatique
 (global-set-key (quote [tab]) (quote dabbrev-expand))

    (setq default-abbrev-mode t)
  (define-abbrev-table 'global-abbrev-table '(
 	("\.\.\." "\ldots" nil)
 	("letat" "l'État" nil)
 	("comeur" "Commission Européenne" t 4)
 	("coneur""Conseil Européen" nil)
 	))

;; ;------------------------------------------------------------------
;; ;to enable or disable completion-ui, comment or uncomment the following lines
(add-to-list 'load-path "~/.emacs.d/completion-ui/")
(require 'completion-ui)
(auto-completion-mode)
;(global-set-key [?\M-/] 'complete-dabbrev)

;; ;-------------------------------------------------------------------
;; ;auto-complete-mode

;; (setq dabbrev-case-replace nil)
;; (add-to-list 'load-path "~/.emacs.d/lisp/auto-complete-1.3")
;; (add-to-list  'load-path "~/.emacs.d/lisp/auto-complete-1.3/dict")
;; (require 'auto-complete-config)
;; (auto-complete-mode)
;; (ac-config-default)

;; ;(require 'auto-complete)
;; ;(setq ac-auto-start 1)
;; ;(require 'auto-complete-config)
;; (require 'popup)
;; ;(require 'fuzzy)
;; (global-auto-complete-mode t)
;; (setq ac-auto-start t)
;; ;(autoload 'auto-complete-mode t)

;; ;------------------------------------------------------------------------
;predictive
;; predictive install location
;;   (add-to-list 'load-path "~/.emacs.d/predictive/")
;;   ;; dictionary locations
;;   (add-to-list 'load-path "~/.emacs.d/predictive/latex/")
;;   (add-to-list 'load-path "~/.emacs.d/predictive/texinfo/")
;;   (add-to-list 'load-path "~/.emacs.d/predictive/html/")
;;   ;; load predictive package
;;   (require 'predictive)
;; (autoload 'predictive-mode "~/.emacs.d/predictive/predictive"
;;             "Turn on Predictive Completion Mode." t)


;-------------------------------------------------------------------------------
;;                  SUPPRIME TOUS LES ESPACES EN FIN DE LIGNE
;-------------------------------------------------------------------------------

(autoload 'nuke-trailing-whitespace "whitespace" nil t)

;-------------------------------------------------------------------------------
  			;Wrap Long Lines By Word Boundary
;-------------------------------------------------------------------------------
  (global-visual-line-mode 1) ; 1 for on, 0 for off.
  
;-------------------------------------------------------------------------------
;     			  TEXT AND AUTO FILL MODE
;-------------------------------------------------------------------------------


(setq default-major-mode 'text-mode)
(add-hook 'text-mode-hook 'text-mode-hook-identify)
(add-hook 'text-mode-hook 'turn-on-auto-fill)
  
;-------------------------------------------------------------------------------
;; PARENTHESE MATCHING, PERMET DE VERIFIER AU FUR ET À MESURE DE LA FRAPPE QUE
;; L'ON FERME BIEN CE QUE L'ON OUVRE, AUSSI BIEN POUR LES PARENTHÈSES QUE LES
;; CROCHETS OU LES ACCOLADES.
;-------------------------------------------------------------------------------

(require 'paren)
(show-paren-mode 1)
(setq-default hilight-paren-expression t)
    
;-------------------------------------------------------------------------------
				;;TIME STAMPS
				;;thanks to http://www.djcbsoftware.nl/dot-emacs.html
;-------------------------------------------------------------------------------
;;Emacs permet d'insérer automatiquement des time stamps, typiquement
;;pour indiquer la date de dernière modification d'un fichier.
;;Pour utiliser les time stamps, indiquer dans les 8 premières lignes d'un fichier ceci :
;;Time-stamp: <>
(setq ;; when there's "Time-stamp: <>" in the first 10 lines of the file
  time-stamp-active t        ; do enable time-stamps
  time-stamp-line-limit 10   ; check first 10 buffer lines for Time-stamp: <>
  time-stamp-format "%04y-%02m-%02d %02H:%02M:%02S (%u)") ; date format
(add-hook 'write-file-hooks 'time-stamp) ; update when saving

;;################################################################################
			;; File browser
;;################################################################################

(setq dired-ls-F-marks-symlinks t)
(defun my-dired-mode-init ()
  (hl-line-mode 1)
  (setq truncate-lines t))
(add-hook 'dired-mode-hook 'my-dired-mode-init)
;; Image viewer.
(when (require 'image-mode nil)
  (defun my-image-next-by-number ()
    (interactive)
    (let ((file-name (buffer-file-name))
	  base num suffix
	  num-width fmt)
      (unless (string-match
	       "^\\(.*[^0-9-]\\)?\\(?:[0-9]+-\\)?\\([0-9]+\\)\\(\\.[^.]+\\)?$"
	       file-name)
	(error "Improper file name"))
      (setq base (match-string 1 file-name))
      (setq num (match-string 2 file-name))
      (setq suffix (match-string 3 file-name))
      (setq num-width (length num))
      (setq fmt (format "%%s%%0%dd%%s" num-width))
      (setq num (1+ (string-to-number num)))
      (setq file-name (format fmt base num suffix))
      (unless (file-exists-p file-name)
	(setq fmt (format "%%s%%0%dd-*%%s" num-width))
	(setq file-name (format fmt base num suffix))
	(setq file-name (file-expand-wildcards file-name))
	(if file-name
	    (setq file-name (car file-name))
	  (error "No more files")))
      (find-alternate-file file-name)))
  (defun my-image-scroll-up-or-next-by-number ()
    (interactive)
    (let* ((image (image-get-display-property))
	   (edges (window-inside-edges))
	   (win-height (- (nth 3 edges) (nth 1 edges)))
	   (img-height (ceiling (cdr (image-size image)))))
      (if (< (+ win-height (window-vscroll nil t))
	     img-height)
	  (image-scroll-up)
	(my-image-next-by-number))))
  (define-key image-mode-map (kbd "SPC")
    'my-image-scroll-up-or-next-by-number))

;-------------------------------------------------------------------------------
			;To get a tree view
;-------------------------------------------------------------------------------
;(add-to-list 'load-path "/usr/share/emacs/site-lisp/emhacks/")
;(require 'dir-tree)

;------------------------------------------------------------------------------
  			;Deleting Files to Trash Folder
;-------------------------------------------------------------------------------
  ; deleting files goes to OS's trash folder
(setq delete-by-moving-to-trash t) ; “t” for true, “nil” for false

;-------------------------------------------------------------------------------
;;                    AFFICHAGE DES IMAGES ET FICHIERS COMPRESSÉS
;-------------------------------------------------------------------------------

(setq auto-image-file-mode t)
(setq auto-compression-mode t)

;;; view
;-------------------------------------------------------------------------------
(eval-after-load "view"
  '(progn
     ;; Shift-Space to scroll back.
     (define-key view-mode-map [?\S- ] 'View-scroll-page-backward)
     (define-key view-mode-map " " 'View-scroll-page-forward-set-page-size)
     (define-key view-mode-map "g" (lambda () (interactive) (revert-buffer nil t t)))
     (define-key view-mode-map "l" 'View-goto-line)
     (define-key view-mode-map [f2] 'toggle-truncate-lines)
     ;; (define-key view-mode-map [tab] 'other-window) ; used for next-ref
     ;; global: (define-key view-mode-map [(meta right)] 'find-file-at-point)
     (define-key view-mode-map [(meta left)]
       (lambda ()
         (interactive)
         ;; Go to the top to not store emacs-places.
         (goto-char (point-min))
         (View-quit)))
     (define-key view-mode-map [(meta down)]
       (lambda ()
         (interactive)
         (if (>= (window-end) (point-max))
             (goto-char (point-max))
           (View-scroll-page-forward-set-page-size))))
     (define-key view-mode-map [(meta up)]
       (lambda ()
         (interactive)
         (if (<= (window-start) (point-min))
             (goto-char (point-min))
           (View-scroll-page-backward-set-page-size))))
     ;; qv http://thread.gmane.org/gmane.emacs.devel/111117/focus=112357
     (defadvice View-scroll-line-forward (after my-View-scroll-line-forward activate)
       "Fix point position to be at the bottom line."
       (move-to-window-line -1)
       (beginning-of-line))
     ))

;;; doc-view
;-------------------------------------------------------------------------------
(eval-after-load "doc-view"
  '(progn
     ;; Shift-Space to scroll back.
     (define-key doc-view-mode-map [?\S- ] 'doc-view-scroll-down-or-previous-page)
     ))

;;; image
;-------------------------------------------------------------------------------
;; This is now in `image-dired-cmd-create-standard-thumbnail-command'
;; (used by `C-t C-t' in Dired).
(defun my-make-thumbnail (file)
  (let* ((image-file (concat "file://" (expand-file-name file)))
         (thumb-file (expand-file-name
                      (concat "~/.thumbnails/normal/" (md5 image-file) ".png")))
         (file-attrs (file-attributes file))
         (modif-time (float-time (nth 5 file-attrs))))
    (unless (file-exists-p thumb-file)
      (shell-command
       (mapconcat
        'identity
        (list
         "convert"
         (format "\"%s\"" file)
         ;; "-size 128x128"
         (format "-set \"Description\" \"Thumbnail of %s\"" image-file)
         (format "-set \"Software\" \"ImageMagick, GNU Emacs %s\"" emacs-version)
         (format "-set \"Thumb::URI\" \"%s\"" image-file)
         (format "-set \"Thumb::MTime\" \"%.0f\"" modif-time)
         "-set \"Thumb::Size\" \"%b\""
         "-set \"Thumb::Image::Width\" \"%w\""
         "-set \"Thumb::Image::Height\" \"%h\""
         "-set \"Thumb::Image::Mimetype\" \"image/jpeg\""
         "-resize 128x128" ;; "-resize 64x64"
         "+profile \"*\""
         "-type TrueColorMatte"
         ;; "-sharpen 11" ; TRY THIS
         (format "png:\"%s\"" thumb-file))
        " ")))
    thumb-file))

;;; thumbs
;-------------------------------------------------------------------------------
(defadvice thumbs-mode (after my-thumbs-mode activate)
  (toggle-truncate-lines -1))

;;; dired
;-------------------------------------------------------------------------------
(require 'dired-x)

;; HINT: the following expression is useful for `M-(' `dired-mark-sexp'
;; to mark files by their type:
;; (string-match "perl" (shell-command-to-string (concat "file " name)))

;; Uses editor/viewer info from /usr/bin/run-mailcap
(defun my-dired-run-find-file ()
  "My view file for dired."
  (interactive)
  (let* ((file (dired-get-filename)))
    (cond
     ((let* ((command
              (and (functionp 'mm-mime-info)
                   (mm-mime-info
                    (mm-extension-to-mime (file-name-extension file))))))
        (if (and command (stringp command))
            ;; always return `t' for `cond'
            (or (ignore (shell-command (concat (format command file) "&")))
                t))))
     ;; ((string-match "\\.html?$" file) (w3-open-local file))
     ((string-match "\\.html?$" file)
      (cond
       ((fboundp 'w3m-goto-url-new-session)
        (w3m-find-file-new-session file))
       ((fboundp 'browse-url)
        (browse-url file))))
     ((string-match "\\.elc?$" file)
      (load-file file))
     ((string-match "\\.info?$" file)
      (info file))
     (;; (or (string-match "\\.jpe?g$" file)
      ;;           (string-match "\\.gif$" file)
      ;;           (string-match "\\.pdf$" file))
      (let* ((file-list (list (dired-get-filename)))
             (command (dired-guess-default file-list)))
        (if (listp command)
            (setq command (car command)))
        (if command
            (shell-command
             (dired-shell-stuff-it command file-list nil 0)))))
     (t
      (message file)))))

(define-key dired-mode-map [(control return)] 'my-dired-run-find-file)

;; Add different directory sorting keys
;-------------------------------------------------------------------------------
(mapc (lambda (elt)
        (define-key dired-mode-map (car elt)
          `(lambda ()
            (interactive)
            (dired-sort-other (concat dired-listing-switches ,(cadr elt))))))
      '(([(control f3)]       ""     "by name")
        ([(control f4)]       " -X"  "by extension")
        ([(control f5)]       " -t"  "by date")
        ([(control f6)]       " -S"  "by size")
        ([(control shift f3)] " -r"  "by reverse name")
        ([(control shift f4)] " -rX" "by reverse extension")
        ([(control shift f5)] " -rt" "by reverse date")
        ([(control shift f6)] " -rS" "by reverse size")))
        
;; The following two bindings allow to open file for editing by [f4],
;; and return back to dired without killing the buffer.
;;--------------------------------------------------------------------------------
(define-key dired-mode-map [f3] 'dired-find-file) ;; 'dired-view-file
(define-key global-map [f3] 'dired-jump)

(define-key dired-mode-map [(shift f4)] 'dired-count-sizes)

;;##################################################################################################
						;highlighting
;;##################################################################################################
;;--------------------------------------------------------------------------------
				;; Syntaxe highlighting pour tout
;;--------------------------------------------------------------------------------

(require 'font-lock)
(setq initial-major-mode
      (lambda ()
    (text-mode)
    (font-lock-mode)))
(setq font-lock-mode-maximum-decoration t
      font-lock-use-default-fonts t
      font-lock-use-default-colors t)
      
;;--------------------------------------------------------------------------------
   			   ;; hl-line: highlight the current line 
   			   ;;(thanks to http://www.djcbsoftware.nl/dot-emacs.html)
;;--------------------------------------------------------------------------------
(when (fboundp 'global-hl-line-mode)
  (global-hl-line-mode t)) ;; turn it on for all modes by default

;;--------------------------------------------------------------------------------
;;                                  ACTIVER LA COLORATION SYNTAXIQUE
;;--------------------------------------------------------------------------------
(global-font-lock-mode t)
(setq font-lock-maximum-decoration t)
(setq font-lock-maximum-size nil)
;;--------------------------------------------------------------------------------
;;                              SURLIGNAGE D'UNE RÉGION SÉLECTIONNÉE ET EFFACER
;;--------------------------------------------------------------------------------

(transient-mark-mode 1) ; highlight text selection
(delete-selection-mode 1) ; delete seleted text when typing

;;##################################################################################################
			;;Sauvegardes, bookmarks, etc
;;##################################################################################################
;;--------------------------------------------------------------------------------
				;; bookmarks
;;--------------------------------------------------------------------------------
(setq bookmark-default-file "~/.emacs.d/data/bookmarks" ;; bookmarks
  bookmark-save-flag 1)                            ;; autosave each change

;;--------------------------------------------------------------------------------
;; 		saveplace: save location in file when saving files
;;--------------------------------------------------------------------------------
(setq save-place-file "~/.emacs.d/cache/saveplace")
(setq-default save-place t)            ;; activate it for all buffers
(require 'saveplace)                   ;; get the package

;;--------------------------------------------------------------------------------
;;		 savehist: save some history
;;--------------------------------------------------------------------------------
(setq savehist-additional-variables    ;; also save...
  '(search ring regexp-search-ring)    ;; ... my search entries
  savehist-autosave-interval 60        ;; save every minute (default: 5 min)
  savehist-file "~/.emacs.d/cache/savehist")   ;; keep my home clean
(savehist-mode t)                      ;; do customization before activation


;;--------------------------------------------------------------------------------
			;; Save/restore sessions on exit/startup.
;;--------------------------------------------------------------------------------

; (desktop-save-mode 1)

;;--------------------------------------------------------------------------------
 ;; POUR ENREGISTRER AUTOMATIQUEMENT LA POSITION DU CURSEUR QUAND ON QUITTE UN
;; FICHIER, ET Y RETOURNER AUTOMATIQUEMENT À LA RÉOUVERTURE
;;--------------------------------------------------------------------------------

(require 'saveplace)
(setq-default save-place t)

;;--------------------------------------------------------------------------------
				;; backups
;;--------------------------------------------------------------------------------
(setq make-backup-files t ;; do make backups
  backup-by-copying t     ;; and copy them here
  backup-directory-alist '(("." . "~/.emacs.d/backups")) 
  version-control t
  kept-new-versions 2
  kept-old-versions 5
  delete-old-versions t)

;;##################################################################################################
					;;APPARENCE, etc
;;##################################################################################################
;--------------------------------------------------------------------------------------------------
;; 				Barre d'état
;--------------------------------------------------------------------------------------------------

(column-number-mode t) ;Affiche le numéro de ligne, de colonne
(line-number-mode t)	;Affiche le numéro de colonne

(size-indication-mode t)                 ;; show file size (emacs 22+)

(display-time) ;POUR AVOIR L'HEURE DANS LA BARRE D'ETAT
(setq display-time-24hr-format t)  ;; Format 24 heures

;--------------------------------------------------------------------------------------------------
  			 ; folding mode
  			 ;work in progress \o/
;--------------------------------------------------------------------------------------------------

 (if (load "folding" 'nomessage 'noerror)
 (folding-mode-add-find-file-hook))
    
;--------------------------------------------------------------------------------------------------
  			 ; show hide
;--------------------------------------------------------------------------------------------------
    
 (defun toggle-selective-display (column)
      (interactive "P")
      (set-selective-display
       (or column
          (unless selective-display
             (1+ (current-column))))))
             
   (defun toggle-hiding (column)
      (interactive "P")
      (if hs-minor-mode
          (if (condition-case nil
                  (hs-toggle-hiding)
                (error t))
              (hs-show-all))
        (toggle-selective-display column)))
        
            (global-set-key (kbd "C-+") 'toggle-hiding)
    (global-set-key (kbd "C-\\") 'toggle-selective-display)
    
;--------------------------------------------------------------------------------------------------
				;; tabulations
				;; Comment changer la longueur des tabulations
				;; pour un code écrit par
				;; des sagouins.
;--------------------------------------------------------------------------------------------------

(defun tab4()
  "Les tabulations vaudront 4 espaces"
  (interactive "*")
  (setq tab-width 4)
)

(defun tab8()
  "Les tabulations vaudront 8 espaces"
  (interactive "*")
  (setq tab-width 8)
)

;--------------------------------------------------------------------------------------------------
				;pour ne pas avoir de bandes verticales
				;thanks to http://www.emacswiki.org/emacs/beginner.el
;--------------------------------------------------------------------------------------------------
;(set-fringe-mode 0)
;; don't show tiny scroll bar in echo area
;(set-window-scroll-bars (minibuffer-window) nil)
;--------------------------------------------------------------------------------------------------
					;Misc
;--------------------------------------------------------------------------------------------------

(setq visible-bell t)                                          ;;警告音を消す

;;################################################################################
						;;;  ESS
;;################################################################################

;; (require 'ess-site)
;; ;(require 'ess-eldoc)

;; (ess-add-MM-keys)   ;; notamment pour des "squelettes" de fonctions

;; (autoload 'ess-rdired "ess-rdired"
;;   "View *R* objects in a dire-like buffer." t)

;; (setq-default ess-ask-for-ess-directory t)   ;; demande le dossier de travail à chaque démarrage de R
;; (setq-default ess-directory "/media/ifremer/Analyses/R/")  ;; répertoire de travail proposé par défaut

;; (add-hook 'ess-mode-hook
;;      '(lambda ()
;;        (auto-fill-mode t)
;;        ;;(flyspell-mode t)
;;        (setq-default fill-column 100)
;;        )
;;      )

;; ;; Pour ajouter à la liste d'association les .Rhistory pour les traîter comme
;; ;; des fichiers sources R
;; (setq auto-mode-alist
;;       (append
;;        '(("\\.[rR]history\\'" . R-mode))
;;        auto-mode-alist))

;; (define-key ess-mode-map [f6] 'comint-dynamic-complete-filename)

;; ;; Montrer "au vol" les arguments de fonctions:

;; ;; ess-r-args-noargsmsg is printed, if no argument information could
;; ;; be found. You could set it to an empty string ("") for no message.
;; (setq ess-r-args-noargsmsg "No args found.")

;; ;; ess-r-args-show-as determines how (where) the information is
;; ;; displayed. Set it to "tooltip" for little tooltip windows or to
;; ;; nil (the default) which will use the echo area at the bottom of
;; ;; your Emacs frame.
;; ;; (setq ess-r-args-show-as "tooltip")

;; ;; ess-r-args-show-prefix is a string that is printed in front of the
;; ;; arguments list. The default ist "ARGS: ".
;; (setq ess-r-args-show-prefix "ARGS: ")

;; (defun Rnw-mode ()
;;   (require 'ess-noweb)
;;   (noweb-mode)
;;   (if (fboundp 'R-mode)
;;       (setq noweb-default-code-mode 'R-mode)))

;; (add-hook 'ess-mode-hook 'my-ess-options)
;; (setq-default inferior-R-args "--no-restore-history --no-save ")
;; (add-hook 'inferior-ess-mode-hook 'my-iess-keybindings)

;; (defun my-ess-options ()
;;   (ess-set-style 'C++)
;;   (column-number-mode t)
;;   (add-hook 'write-file-functions
;; 	    (lambda ()
;; 	      (nuke-trailing-whitespace)))
;;   (define-key ess-mode-map [(meta backspace)] 'backward-kill-word))

;; (defun my-iess-keybindings ()
;;   (define-key inferior-ess-mode-map [(control ?a)] 'comint-bol)
;;   (define-key inferior-ess-mode-map [home] 'comint-bol))

;;##################################################################################################

				;;CUSTOMIZATION-FACE : FONT, COLOR
;; Modifications de l'apparence
;; font : aller dans Option --> Set default font ; pour sauvegarder : Option --> Save Options
;; color : pour tester les couleurs, aller dans le Menu --> Tools --> Color Themes
(add-to-list 'load-path "~/.emacs.d/color-theme-6.6.0/")
(require 'color-theme)
(eval-after-load "color-theme"
  '(progn
     (color-theme-initialize)
     (color-theme-andreas)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;    (require 'color-theme)
  ;  (color-theme-initialize)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;    (color-theme-andreas)
;; pour color theme voir aussi dans dans Option --> Customize emacs --> Browse customization groups --> Group "Faces" --> Group "Color Theme" 
;; pour LaTeX :
;; - \emph --> font-latex-italic-face
;; - \footnote --> font-lock-constant-face
;; - commandes (\emph, \textsc) --> font-lock-keyword-face

;;##################################################################################################

;--------------------------------------------------------------------------------------------------
				;Default font
				;thanks to http://www.emacswiki.org/emacs/XftGnuEmacs
;--------------------------------------------------------------------------------------------------
;; To me, the best fonts are as follow ; modify if you prefer Bitstream or another font :

;(set-default-font "Deja Vu Sans Mono 10")

;--------------------------------------------------------------------------------------------------
(custom-set-variables
  ;; custom-set-variables was added by Custom.
  ;; If you edit it by hand, you could mess it up, so be careful.
  ;; Your init file should contain only one such instance.
  ;; If there is more than one, they won't work right.
 '(blink-cursor-mode nil)
 '(column-number-mode t)
 '(display-time-mode t)
 '(show-paren-mode t)
 '(size-indication-mode t))

;;##################################################################################################
;;				MISCELLANEOUS
;;##################################################################################################
;--------------------------------------------------------------------------------------------------
				;; do not show the startup message and other stuff
				;; at http://www.djcbsoftware.nl/dot-emacs.html
;--------------------------------------------------------------------------------------------------

(put 'narrow-to-region 'disabled nil)    ;; enable...
(put 'erase-buffer 'disabled nil)        ;; ... useful things
(file-name-shadow-mode t)                ;; be smart about filenames in mbuf

(setq inhibit-startup-message t          ;; don't show ...    
  inhibit-startup-echo-area-message t)   ;; ... startup messages
  
;--------------------------------------------------------------------------------------------------
;;                   POUR NE PAS AVOIR À TAPER EN ENTIER LA RÉPONSE YES/NO
;--------------------------------------------------------------------------------------------------

(fset 'yes-or-no-p 'y-or-n-p)

;--------------------------------------------------------------------------------------------------
					;; Fichiers annexes dans ~/.emacs.d/lisp
;--------------------------------------------------------------------------------------------------
;;stuff in separate files;; maybe use autoload?

;;inclusion de la gestion des couleurs
;(require 'couleurs nil 'noerror)
;----------------------------------------
;;inclusion du calendrier
(add-to-list 'load-path "~/.emacs.d/lisp/")
;(require 'calendrier nil 'noerror)
;----------------------------------------
;;afficher les numéros de ligne
(load-file "~/.emacs.d/lisp/line-num.el")
;(and (< emacs-major-version 20) (eval-when-compile (require 'cl)))
;----------------------------------------
;(add-to-list 'load-path "~/.emacs.d/lisp/linum.el")
;(require 'linum)
;(autoload 'linum-mode "linum")

;display line numbers in margin (fringe). Emacs 23 only.
;(global-linum-mode 1) ; always show line numbers

;--------------------------------------------------------------------------------------------------
;;                                            THUMBS-MODE
;--------------------------------------------------------------------------------------------------
 (autoload 'thumbs "thumbs" "Preview images in a directory." t)
  
;--------------------------------------------------------------------------------------------------
					;Search and case sensitivity
;--------------------------------------------------------------------------------------------------

; (setq case-fold-search nil) ; make searches case sensitive
 (setq case-fold-search t) ; make searches case insensitive
 
;--------------------------------------------------------------------------------------------------
			;; Switch ispell dictionary locally.
;--------------------------------------------------------------------------------------------------
		;;; Mode Ispell 
;; (require 'ispell)
;;   (setq ispell-dictionary "francais")

;; (global-set-key (kbd "C-c d e")
;;                 (lambda () (interactive)
;;                   (ispell-change-dictionary "english")))
;; (global-set-key (kbd "C-c d f")
;;                 (lambda () (interactive)
;;                   (ispell-change-dictionary "francais")))
  
;--------------------------------------------------------------------------------------------------
 				; Comment rafraîchir un fichier dans .emacs lorsqu'il
 				; a été modifié par un autre programme ?
 				; thanks to http://www.emacswiki.org/emacs/RevertBuffer
;--------------------------------------------------------------------------------------------------
 
  (global-auto-revert-mode 1)
  
 ;-----------------------------------------------------------
 ; a function to revert all buffers :
 ;-----------------------------------------------------------
   (defun revert-all-buffers ()
   "Refreshes all open buffers from their respective files"
   (interactive)
   (let* ((list (buffer-list))
          (buffer (car list)))
     (while buffer
       (when (buffer-file-name buffer)
         (progn
           (set-buffer buffer)
           (revert-buffer t t t)))
       (setq list (cdr list))
       (setq buffer (car list))))
  (message "Refreshing open files"))
  
;--------------------------------------------------------------------------------------------------
(defun my-info-refresh (&optional arg)
  "Display some useful information in the echo area instead of the mode line.
With prefix arg, insert the current timestamp to the current buffer."

;; §§ WORK IN PROGRESS §§ doesn't work !

;--------------------------------------------------------------------------------------------------
  (interactive "P")
  (cond
   ((equal arg '(4))  ; C-u f5
    (insert (format-time-string "%Y%m%d" (current-time))))
   ((equal arg '(16)) ; C-u C-u f5
    (insert (format-time-string "%Y-%m-%d" (current-time))))
   (t (message "%s"
               (concat
                (format-time-string "%Y-%m-%d %H:%M:%S %z" (current-time)) ;; ISO
                " "
                (aref calendar-day-abbrev-array (nth 6 (decode-time (current-time))))
                " : "
                (or (buffer-file-name) default-directory))))))

;(define-key my-map     [f5]  'my-info-refresh)
;(define-key global-map [f5]  'my-info-refresh)

;; open Word files with antiword
(autoload 'no-word "no-word" "word to txt")
(add-to-list 'auto-mode-alist '("\\.doc\\'" . no-word))
(custom-set-faces
  ;; custom-set-faces was added by Custom.
  ;; If you edit it by hand, you could mess it up, so be careful.
  ;; Your init file should contain only one such instance.
  ;; If there is more than one, they won't work right.
 '(default ((t (:inherit nil :stipple nil :background "white" :foreground "black" :inverse-video nil :box nil :strike-through nil :overline nil :underline nil :slant normal :weight normal :height 98 :width normal :foundry "unknown" :family "DejaVu Sans Mono")))))