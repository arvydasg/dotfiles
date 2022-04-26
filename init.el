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

(load "~/.emacs.d/recipes/ace-window.el")
(load "~/.emacs.d/recipes/avy.el")
(load "~/.emacs.d/recipes/backups.el")
(load "~/.emacs.d/recipes/beacon.el")
(load "~/.emacs.d/recipes/browse-kill-ring.el")
(load "~/.emacs.d/recipes/company.el")
(load "~/.emacs.d/recipes/counsel.el")
(load "~/.emacs.d/recipes/diff-hl.el")
(load "~/.emacs.d/recipes/dired.el")
(load "~/.emacs.d/recipes/doom.el")
(load "~/.emacs.d/recipes/elfeed.el")
(load "~/.emacs.d/recipes/elpy.el")
(load "~/.emacs.d/recipes/emmet.el")
(load "~/.emacs.d/recipes/emojify.el")
(load "~/.emacs.d/recipes/erc.el")
(load "~/.emacs.d/recipes/expand-region.el")
(load "~/.emacs.d/recipes/flycheck.el")
(load "~/.emacs.d/recipes/flyspell.el")
(load "~/.emacs.d/recipes/general.el")
(load "~/.emacs.d/recipes/goto-chg.el")
(load "~/.emacs.d/recipes/hungry-delete.el")
(load "~/.emacs.d/recipes/impatient-mode.el")
(load "~/.emacs.d/recipes/ivy.el")
(load "~/.emacs.d/recipes/jump.el")
(load "~/.emacs.d/recipes/lorem-ipsum.el")
(load "~/.emacs.d/recipes/macros.el")
(load "~/.emacs.d/recipes/magit.el")
(load "~/.emacs.d/recipes/move-text.el")
(load "~/.emacs.d/recipes/multiple-cursors.el")
(load "~/.emacs.d/recipes/org.el")
(load "~/.emacs.d/recipes/org-agenda.el")
;; (load "~/.emacs.d/recipes/org-capture.el")
(load "~/.emacs.d/recipes/org-roam.el")
(load "~/.emacs.d/recipes/org-clock.el")
(load "~/.emacs.d/recipes/org-download.el")
;; (load "~/.emacs.d/recipes/pop-eshell.el")
(load "~/.emacs.d/recipes/projectile.el")
(load "~/.emacs.d/recipes/rainbow-delimiters.el")
(load "~/.emacs.d/recipes/rg.el")
(load "~/.emacs.d/recipes/saveplace.el")
(load "~/.emacs.d/recipes/swiper.el")
(load "~/.emacs.d/recipes/undo-tree.el")
(load "~/.emacs.d/recipes/visuals.el")
(load "~/.emacs.d/recipes/volatile-highlights.el")
(load "~/.emacs.d/recipes/web-mode.el")
(load "~/.emacs.d/recipes/ws-butler.el")
(load "~/.emacs.d/recipes/yasnippet.el")

;;; init.el ends here
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(org-agenda-files
   (quote
    ("/home/arvydas/Dropbox/documents/org/roam/20220323164015-know_your_area.org" "/home/arvydas/Dropbox/documents/org/roam/20220323163644-cs.org" "/home/arvydas/Dropbox/documents/org/roam/20220417171832-org_site.org" "/home/arvydas/Dropbox/documents/org/roam/20220416072754-tolearn.org" "/home/arvydas/Dropbox/documents/org/roam/20220323163825-facebook_group_automatization.org" "/home/arvydas/Dropbox/documents/org/roam/20220323163522-citatos.org" "/home/arvydas/Dropbox/documents/org/roam/20220415070807-someday.org" "/home/arvydas/Dropbox/documents/org/roam/20220323162627-emacs.org" "/home/arvydas/Dropbox/documents/org/roam/20220323164321-smuti_fruti.org" "/home/arvydas/Dropbox/documents/org/roam/20220323163909-obelsdumas.org" "/home/arvydas/Dropbox/documents/org/roam/20220323163743-dpd.org" "/home/arvydas/Dropbox/documents/org/roam/20220403094017-facebook.org" "/home/arvydas/Dropbox/documents/org/roam/20220328183135-python.org" "/home/arvydas/Dropbox/documents/org/roam/20220414190538-pkc.org" "/home/arvydas/Dropbox/documents/org/roam/20220323164133-portfolio.org" "/home/arvydas/Dropbox/documents/org/roam/20220323172208-tickler.org" "/home/arvydas/Dropbox/documents/org/roam/20220426071354-alpine.org")))
 '(package-selected-packages
   (quote
    (ws-butler web-mode volatile-highlights undo-tree rg rainbow-delimiters projectile org-download org-roam multiple-cursors move-text magit lorem-ipsum all-the-icons-ivy-rich ivy-rich impatient-mode hungry-delete goto-chg csv-mode helpful amx which-key use-package flycheck expand-region emojify emmet-mode elpy elfeed doom-themes doom-modeline diredfl dired-git-info diff-hl counsel company-quickhelp browse-kill-ring beacon ace-window))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
(put 'dired-find-alternate-file 'disabled nil)
