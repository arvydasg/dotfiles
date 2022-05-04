;;; org_capture.el --- org_capture setuf
;;; Commentary:
;; not using it anymore since org roam
;;; Code:

;; MANY small files below
(define-key global-map "\C-cc" 'org-capture)
;; (setq org-capture-templates '(
;; ("a" "Arvydas.dev" entry (file+headline "~/Dropbox/documents/org/arvydasdev.org" "arvydas.dev") "* TODO %?\n%^{Effort}p")
;; ("e" "Emacs" entry (file+headline "~/Dropbox/documents/org/src_emacs.org" "Emacs") "* TODO %?\n%^{Effort}p")
;; ("s" "Smuti Fruti" entry (file+headline "~/Dropbox/documents/org/src_smutifruti.org" "Smuti Fruti") "* TODO %?\n%^{Effort}p")
;; ("f" "Facebook_django" entry (file+headline "~/Dropbox/documents/org/src_facebook_django.org" "Facebook_django") "* TODO %?\n%^{Effort}p")
;; ("p" "Personal" entry (file+headline "~/Dropbox/documents/org/personal.org" "Personal") "* TODO %?\n%^{Effort}p")
;; ("d" "Diary" entry (file+datetree "~/Dropbox/documents/org/notes/diary.org" "Diary") "* %U %^{Title}\n%?")))
;; ("p" "Planned" entry (file+headline "~/Dropbox/1.planai/tickler.org" "Planned") "* %i%? %^{SCHEDULED}p" :prepend t)
;; ("r" "Repeating" entry (file+headline "~/Dropbox/1.planai/tickler.org" "Repeating") "* %i%? %^{SCHEDULED}p")))


(setq org-capture-templates
      '(("t" "TODO" entry (file+headline "~/Dropbox/documents/org/roam/20220504192335-inbox.org" "Tasks")
         "** TODO %?")
        ("i" "Inbox" entry (file+headline "~/Dropbox/documents/org/roam/20220504192335-inbox.org" "Inbox")
         "** %?")
        ("c" "Current" plain (clock) "" :clock-in :clock-keep)))


;; ONE BIG FILE BELOW
;; (setq org-capture-templates '(
;;                               ("i" "Inbox No Timesamp" entry (file+headline "~/Dropbox/documents/org/roam/Inbox.org" "Inbox No Timestamp") "* TODO %?\n %^{Effort}p")
;;                               ("I" "Inbox Timestamp" entry (file+headline "~/Dropbox/documents/org/roam/Inbox.org" "Inbox Timestamp") "* TODO %?\n%^{Effort}p\n%^{SCHEDULED}p")
;;                               ("t" "Tickler" entry (file+headline "~/Dropbox/documents/org/roam/20220323172208-tickler.org" "Tasks") "* %? \n%^{SCHEDULED}p")
;;                               ("e" "Emacs" entry (file+headline "~/Dropbox/documents/org/roam/20220323162627-emacs.org" "Tasks") "* TODO %(org-set-tags \"emacs\")%?\n%^{Effort}p")
;;                               ("o" "Obelsdumas" entry (file+headline "~/Dropbox/documents/org/roam/20220323163909-obelsdumas.org" "Tasks") "* TODO %(org-set-tags \"obelsdumas\")%?\n%^{Effort}p")
;;                               ("p" "Portfolio" entry (file+headline "~/Dropbox/documents/org/roam/20220323164133-portfolio.org" "Tasks") "* TODO %(org-set-tags \"portfolio\")%?\n%^{Effort}p")
;;                               ("s" "Smuti Fruti" entry (file+headline "~/Dropbox/documents/org/roam/20220323164321-smuti_fruti.org" "Tasks") "* TODO %(org-set-tags \"smuti_fruti\")%?\n%^{Effort}p")
;;                               ("d" "Diary" entry (file+datetree "~/Dropbox/documents/org/roam/diary.org" "diary") "* %U %^{Title}\n%?")
;;                               ("f" "Facebook" entry (file+headline "~/Dropbox/documents/org/roam/20220323163825-facebook_group_automatization.org" "Tasks") "* TODO %(org-set-tags \"facebook\")%?\n%^{Effort}p")))

;;; org_capture.el ends here
