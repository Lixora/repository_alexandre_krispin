(require 'cl)
(load "cl-seq")
(load "cl-extra")
(load "cl-macs")
(require 'misc)

(let* ((easymacs-dir (file-name-directory (or load-file-name
                                              buffer-file-name))))
  (add-to-list 'load-path easymacs-dir)
  (add-to-list 'load-path (concat easymacs-dir "lib/"))
  (add-to-list 'load-path (concat easymacs-dir "auctex/"))
  (add-to-list 'load-path (concat easymacs-dir "dictionary/"))
  (add-to-list 'load-path (concat easymacs-dir "nxml-mode/"))
  (setq TeX-lisp-directory (concat easymacs-dir "auctex/"))
  (setq TeX-auto-global (concat easymacs-dir "auctex/var/")))

(load "cua-base")
(load "cua-rect")
(load "cua-gmrk")
     
(require 'uniquify)
(require 'color-file-completion)
(when (boundp 'disp-table)
  (require 'disp-table)) ;; for Emacs 21.3.50

(require 'scroll-bar)
(require 'mouse-sel)
(require 'mwheel)
(require 'tool-bar)
(require 'image)
(require 'tooltip)

(require 'recentf)
(require 'jit-lock)
(require 'paren)
(require 'server)
(require 'keypad)
(require 'easy-mmode)
(load "dictionary-init")
(load "scrat")
(require 'iswitchb)
(require 'msb)
(require 'dired-x)
(require 'cal-desk-calendar)

(require 'scroll-in-place)
(require 'redo)
(require 'hideshow)
(require 'outline)
(require 'fold-dwim)
(require 'color-theme)
(require 'generic-x)
(require 'tramp)
(require 'session)

(require 'ibuffer)
(require 'printing)
(require 'bm)
(require 'marker-visit)
(require 'dired)
(require 'info)
(require 'goto-addr)

(require 'flyspell-babel)
(require 'flyspell-xml-lang)
(require 'convert-quotes)
(load "rng-auto")
(require 'html-script)
(require 'easymacs-xml-unicode)
(require 'tei-html-docs-p4)
(require 'tei-html-docs-p5)
(require 'perldoc)

(require 'tex-site)

(require 'screen-lines)
(require 'buffer-stack)

