;;; init.el --- Main init
;;; Commentary:
;; Emacs outshines all other editing software in approximately the
;; same way that the noonday sun does the stars. It is not just bigger
;; and brighter: it simply makes everything else vanish. – Neal Stephenson,
;; In the Beginning was the Command Line (1998)
;;; Code:

;; Initialize package sources
(require 'package)

(setq package-archives '(("melpa" . "https://melpa.org/packages/")
                         ("melpa-stable" . "https://stable.melpa.org/packages")
                         ("elpa" .  "https://elpa.gnu.org/packages/" )))

(package-initialize)
(unless package-archive-contents
 (package-refresh-contents))

(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

;; (org-babel-load-file (expand-file-name "~/Dropbox/src/emacs/myinit.org"))

(load "~/Dropbox/src/emacs/recipes/ace-window.el")
(load "~/Dropbox/src/emacs/recipes/avy.el")
(load "~/Dropbox/src/emacs/recipes/backups.el")
(load "~/Dropbox/src/emacs/recipes/beacon.el")
(load "~/Dropbox/src/emacs/recipes/browse-kill-ring.el")
(load "~/Dropbox/src/emacs/recipes/company.el")
(load "~/Dropbox/src/emacs/recipes/counsel.el")
(load "~/Dropbox/src/emacs/recipes/diff-hl.el")
(load "~/Dropbox/src/emacs/recipes/dired.el")
(load "~/Dropbox/src/emacs/recipes/doom-themes.el")
(load "~/Dropbox/src/emacs/recipes/doom-modeline.el")
(load "~/Dropbox/src/emacs/recipes/elfeed.el")
(load "~/Dropbox/src/emacs/recipes/elpy.el")
(load "~/Dropbox/src/emacs/recipes/emmet.el")
(load "~/Dropbox/src/emacs/recipes/emojify.el")
(load "~/Dropbox/src/emacs/recipes/erc.el")
(load "~/Dropbox/src/emacs/recipes/expand-region.el")
(load "~/Dropbox/src/emacs/recipes/flycheck.el")
(load "~/Dropbox/src/emacs/recipes/flyspell.el")
(load "~/Dropbox/src/emacs/recipes/general.el")
(load "~/Dropbox/src/emacs/recipes/goto-chg.el")
(load "~/Dropbox/src/emacs/recipes/hungry-delete.el")
(load "~/Dropbox/src/emacs/recipes/impatient-mode.el")
(load "~/Dropbox/src/emacs/recipes/ivy.el")
(load "~/Dropbox/src/emacs/recipes/jump.el")
(load "~/Dropbox/src/emacs/recipes/lorem-ipsum.el")
(load "~/Dropbox/src/emacs/recipes/macros.el")
(load "~/Dropbox/src/emacs/recipes/magit.el")
(load "~/Dropbox/src/emacs/recipes/move-text.el")
(load "~/Dropbox/src/emacs/recipes/multiple-cursors.el")
(load "~/Dropbox/src/emacs/recipes/org.el")
(load "~/Dropbox/src/emacs/recipes/org-agenda.el")
(load "~/Dropbox/src/emacs/recipes/org-capture.el")
(load "~/Dropbox/src/emacs/recipes/org-roam.el")
(load "~/Dropbox/src/emacs/recipes/org-clock.el")
(load "~/Dropbox/src/emacs/recipes/org-download.el")
;; (load "~/Dropbox/src/emacs/recipes/pop-eshell.el")
(load "~/Dropbox/src/emacs/recipes/projectile.el")
(load "~/Dropbox/src/emacs/recipes/rainbow-delimiters.el")
(load "~/Dropbox/src/emacs/recipes/rg.el")
(load "~/Dropbox/src/emacs/recipes/super-save.el")
;; (load "~/Dropbox/src/emacs/recipes/saveplace.el")
(load "~/Dropbox/src/emacs/recipes/swiper.el")
(load "~/Dropbox/src/emacs/recipes/undo-tree.el")
(load "~/Dropbox/src/emacs/recipes/visuals.el")
;; (load "~/Dropbox/src/emacs/recipes/volatile-highlights.el")
(load "~/Dropbox/src/emacs/recipes/web-mode.el")
;; (load "~/Dropbox/src/emacs/recipes/ws-butler.el")
(load "~/Dropbox/src/emacs/recipes/yasnippet.el")
(load "~/Dropbox/src/emacs/recipes/secrets.el")
(put 'dired-find-alternate-file 'disabled nil)
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(org-agenda-files
   (quote
    ("/home/arvydas/Dropbox/documents/org/roam/20220504202624-smuti_fruti.org" "/home/arvydas/Dropbox/documents/org/roam/20220504180110-pkc.org" "/home/arvydas/Dropbox/documents/org/roam/20220504202102-know_your_area.org" "/home/arvydas/Dropbox/documents/org/roam/20220504192051-emacs.org" "/home/arvydas/Dropbox/documents/org/roam/20220504192335-inbox.org" "/home/arvydas/Dropbox/documents/org/roam/20220504191201-personal.org" "/home/arvydas/Dropbox/documents/org/roam/20220504200737-citatos.org" "/home/arvydas/Dropbox/documents/org/roam/20220504203435-arvydasg_github_io.org" "/home/arvydas/Dropbox/documents/org/roam/20220508123624-cs.org"))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
