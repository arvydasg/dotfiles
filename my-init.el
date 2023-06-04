;; (setq backup-directory-alist '(("." . "~/Dropbox/src/emacs/backups")))
;; (setq delete-old-versions -1)

;; ;; Make numeric backup versions unconditionally.
;; (setq version-control t)
;; (setq vc-make-backup-files t)
;; (setq auto-save-file-name-transforms '((".*" "~/Dropbox/src/emacs/auto-save-list/" t)))

(setq make-backup-files nil) ; stop creating backup~ files
(setq auto-save-default nil) ; stop creating #autosave# files

;; (setq make-backup-files nil)
;; (setq auto-save-list-file-name  nil)
;; (setq auto-save-default nil)

(use-package browse-kill-ring
  :ensure t
  :config
  (browse-kill-ring-default-keybindings)
  )

(use-package command-log-mode
  :commands (global-command-log-mode))

;; want a quickier scrolling with c-n/c-p?
;; find "repeat keys" in your system, then modify it

;; startup stuff
(setq inhibit-startup-message t)
(setq initial-scratch-message nil)
(setq use-package-compute-statistics t) ; M-x use-package-report
;; (setq initial-buffer-choice "~/Dropbox/documents/org/roam/Inbox.org")
;; (setq initial-buffer-choice (lambda () (org-roam-dailies-goto-today "d") (current-buffer)))
;; (setq initial-buffer-choice (lambda () (org-agenda nil "a") (current-buffer)))

;;; ---------------------------------------

;; Increase the garbage collection threshold to 100MB to reduced startup time.
;; See https://www.reddit.com/r/emacs/comments/3kqt6e
(setq-default large-file-warning-threshold 100000000) ; set warning of opening large files to 100MB
(setq gc-cons-threshold (* 1024 1024 100))
(setq gc-cons-threshold 100000000)

;; [2021-07-01] Winner Mode is a global minor mode. When activated, it allows you to
;; “undo” (and “redo”) changes in the window configuration with the key
;; commands C-c left and C-c right.
(winner-mode +1)
;; C-k kills line including its newline
(setq kill-whole-line t)
;; Mouse avoidance. becomes visible again when typing.
(setq make-pointer-invisible t)
(add-hook 'before-save-hook 'whitespace-cleanup)
(fset 'yes-or-no-p 'y-or-n-p)
(delete-selection-mode t)               ; Delete marked region when typing over it
(setq ad-redefinition-action 'accept)   ; turn off the error message at emacs launch
(setq-default sentence-end-double-space nil) ; Do not add double space after periods
(global-set-key (kbd "C-x C-b") 'switch-to-buffer) ; no more annoying buffer list combinatios
(setq-default indent-tabs-mode nil)     ; idk man, advised
(setq dired-kill-when-opening-new-dired-buffer t) ;I was annoyed of dired buffers, so added this

;; Character wrap
(setq fill-column 80)
(setq-default global-visual-line-mode nil) ; automatically wraps words at boundaries
(add-hook 'text-mode-hook 'turn-on-auto-fill)

;; White-space
;; (setq whitespace-style '(face trailing tabs tab-mark))
;; (global-whitespace-mode)

;; Add note tag to C-c C-z
;; Upon adding a note to a heading - add a tag automatically
(defun ndk/org-mark-headline-for-note ()
  (let ((tags (org-get-tags nil t)))
    (unless (seq-contains tags "note")
      (progn
        (outline-back-to-heading)
        (org-set-tags (cons "note" tags))))))

;;; ---------------------------------------

(defun my/org-add-note ()
  (interactive)
  (org-add-note)                    ; call the original function
  (ndk/org-mark-headline-for-note)) ; then call the function above to add the tag

(with-eval-after-load 'org
  (define-key org-mode-map (kbd "C-c C-z") #'my/org-add-note))

;;; ---------------------------------------

(defun efs/display-startup-time ()
  (message "Emacs loaded in %s with %d garbage collections."
           (format "%.2f seconds"
                   (float-time
                    (time-subtract after-init-time before-init-time)))
           gcs-done))

(add-hook 'emacs-startup-hook #'efs/display-startup-time)

;;; ---------------------------------------

;; [2022-04-05 Tue] Un-fill region. Needed for when wanting to put
;; text content to a website.
(defun unfill-region (beg end)
  "Unfill the region, joining text paragraphs into a single
      logical line.  This is useful, e.g., for use with
      `visual-line-mode'."
  (interactive "*r")
  (let ((fill-column (point-max)))
    (fill-region beg end)))

;; Handy key definition
(define-key global-map "\C-\M-Q" 'unfill-region)

;;; ---------------------------------------

;; Ask before closing Emacs
(defun ask-before-closing ()
  "Ask whether or not to close, and then close if y was pressed"
  (interactive)
  (if (y-or-n-p (format "Exit Emacs? "))
      (if (< emacs-major-version 22)
          (save-buffers-kill-terminal)
        (save-buffers-kill-emacs))
    (message "Canceled exit")))

(when window-system
  (global-set-key (kbd "C-x C-c") 'ask-before-closing))

;;; ---------------------------------------

;; a function to kill dired buffers. Kind of works. Or you can use "a"
;; to cycle through dired and it leaves no buffers opened
;; DiredReuseDirectoryBuffer - https://www.emacswiki.org/emacs/DiredReuseDirectoryBuffer
;; KillingBuffers - https://www.emacswiki.org/emacs/KillingBuffers
(defun kill-dired-buffers ()
  (interactive)
  (mapc (lambda (buffer)
          (when (eq 'dired-mode (buffer-local-value 'major-mode buffer))
            (kill-buffer buffer)))
        (buffer-list)))

;; can easily check how many buffers got opened
(defun kill-all-dired-buffers ()
  "Kill all dired buffers."
  (interactive)
  (save-excursion
    (let ((count 0))
      (dolist (buffer (buffer-list))
        (set-buffer buffer)
        (when (equal major-mode 'dired-mode)
          (setq count (1+ count))
          (kill-buffer buffer)))
      (message "Killed %i dired buffer(s)." count))))

;;; ---------------------------------------

;; [2021-07-01] A package that displays the available keybindings in a
;; popup. The package is pretty useful, as Emacs seems to have more
;; keybindings than I can remember at any given point.
(use-package which-key
  :ensure t
  :init
  (setq which-key-separator " ")
  (setq which-key-prefix-prefix "+")
  (setq which-key-idle-delay 0.2)
  :config
  (which-key-mode 1))

;; [2022-04-01 Fri] amx: An alternative M-x interface for Emacs. Sort by most recent commands.
;; https://github.com/DarwinAwardWinner/amx
(use-package amx
  :ensure t
  :defer 0.5
  :config (amx-mode))

;; [2022-03-15 An] Improves *help* buffer. Way more info than with
;; regular help.
(use-package helpful
  :ensure t
  :bind
  (("C-h f" . helpful-callable)
   ("C-h v" . helpful-variable)
   ("C-h k" . helpful-key)
   ("C-c C-d" . helpful-at-point)
   ("C-h F" . helpful-function)
   ("C-h C" . helpful-command)))

;; [2022-03-13 Sk]
;; (use-package csv-mode
;;   :ensure t
;;   :mode "\\.csv\\'")

;; shell-other-window
(defun eshell-other-window ()
  "Open a `shell' in a new window."
  (interactive)
  (let ((buf (eshell)))
    (switch-to-buffer (other-buffer buf))
    (switch-to-buffer-other-frame buf)))

;; https://rejeep.github.io/emacs/elisp/2010/03/11/duplicate-current-line-or-region-in-emacs.html
;; for html actually found C-c C-e C from web mode
;; but will leave this for other modes probably
(defun duplicate-current-line-or-region (arg)
  "Duplicates the current line or region ARG times.
If there's no region, the current line will be duplicated. However, if
there's a region, all lines that region covers will be duplicated."
  (interactive "p")
  (let (beg end (origin (point)))
    (if (and mark-active (> (point) (mark)))
        (exchange-point-and-mark))
    (setq beg (line-beginning-position))
    (if mark-active
        (exchange-point-and-mark))
    (setq end (line-end-position))
    (let ((region (buffer-substring-no-properties beg end)))
      (dotimes (i arg)
        (goto-char end)
        (newline)
        (insert region)
        (setq end (point)))
      (goto-char (+ origin (* (length region) arg) arg)))))

(global-set-key (kbd "M-c") 'duplicate-current-line-or-region)

(use-package saveplace
  :ensure t
  :config
  ;; activate it for all buffers
  (setq-default save-place t)
  (save-place-mode 1))

;; (use-package super-save
;;   :ensure nil
;;   ;; :disabled t                           ;fuck that, losing lots of work with this at pkc
;;   :config
;;   (setq super-save-auto-save-when-idle t)
;;   (setq super-save-idle-duration 5) ;; after 5 seconds of not typing autosave
;;   ;; add integration with ace-window
;;   (add-to-list 'super-save-triggers 'ace-window)
;;   (super-save-mode +1))

(use-package beacon
  :ensure t
  :config
  (progn
    (setq beacon-blink-when-point-moves-vertically nil) ; default nil
    (setq beacon-blink-when-point-moves-horizontally nil) ; default nil
    (setq beacon-blink-when-buffer-changes t) ; default t
    (setq beacon-blink-when-window-scrolls t) ; default t
    (setq beacon-blink-when-window-changes t) ; default t
    (setq beacon-blink-when-focused nil) ; default nil

    (setq beacon-blink-duration 0.3) ; default 0.3
    (setq beacon-blink-delay 0.3) ; default 0.3
    (setq beacon-size 20) ; default 40
    ;; (setq beacon-color "yellow") ; default 0.5
    (setq beacon-color 0.5) ; default 0.5

    (add-to-list 'beacon-dont-blink-major-modes 'term-mode)

    (beacon-mode 1)))

(menu-bar-mode -1)
(tool-bar-mode -1)
(scroll-bar-mode -1)
(blink-cursor-mode -1)
(global-hl-line-mode 1)

;; not needed, line numbers show the end of buffer anyway
(setq-default indicate-empty-lines nil)   ; show where buffers end.
(setq visible-bell t)

;; Parentheses
(electric-pair-mode +1)                 ; writes parens automatically for you
(show-paren-mode 1)                     ; highlight parenthesis
(setq show-paren-delay 0)               ; Show matching parens

(column-number-mode 1)                  ; column-number in mode-line.
(size-indication-mode 1)                ; file size indication in mode-line

;; Line numbers
;; (global-display-line-numbers-mode 1)
;; (add-hook 'text-mode-hook #'display-line-numbers-mode)
(add-hook 'prog-mode-hook #'display-line-numbers-mode)

;; (set-face-attribute 'default nil :family "Consolas" :height 110)

(add-to-list 'custom-theme-load-path "~/.emacs.d/misc/themes/")
;; (load-theme 'zenburn t)

;; (cond ((eq system-type 'windows-nt)
;;      ;; Windows-specific code goes here.
;;      (set-face-attribute 'default nil :height 130)
;;      )
;;     ((eq system-type 'gnu/linux)
;;      ;; Linux-specific code goes here.
;;      (set-face-attribute 'default nil :height 130)
;;      ))

;; [2022-03-14 Pr] Transparency
;; (set-frame-parameter (selected-frame) 'alpha '(95 . 95))
;; (add-to-list 'default-frame-alist '(alpha . (95 . 95)))

(use-package rainbow-delimiters
  :ensure t
  :hook (prog-mode . rainbow-delimiters-mode))

(use-package doom-themes
  :ensure t
  :config
  ;; Global settings (defaults)
  (setq doom-themes-enable-bold t    ; if nil, bold is universally disabled
        doom-themes-enable-italic t) ; if nil, italics is universally disabled
  ;; (load-theme 'doom-palenight t)
  (load-theme 'doom-gruvbox t))

(use-package doom-modeline
  :ensure t
  :init
  (setq doom-modeline-env-enable-python t)
  (setq doom-modeline-env-enable-go nil)
  (setq doom-modeline-buffer-encoding 'nondefault)
  (setq doom-modeline-hud t)
  (setq doom-modeline-persp-icon nil)
  (setq doom-modeline-persp-name nil)
  :config
  (setq doom-modeline-minor-modes nil)
  (setq doom-modeline-buffer-state-icon nil)
  (doom-modeline-mode 1)
  :custom
  (doom-modeline-irc t))

;; (use-package dashboard
;;   :ensure t
;;   :config
;;   (dashboard-setup-startup-hook)
;;   :custom
;;   (dashboard-projects-backend  'projectile)
;;   (dashboard-items             '(
;;                                  (bookmarks . 1)
;;                                  (recents   . 5)
;;                                  (projects  . 5)
;;                                  ))
;;   ;; (dashboard-set-footer        nil)
;;   :bind (
;;   (:map dashboard-mode-map
;;         ("C-p" . nil))
;;   )
;; )

(use-package highlight-indentation
  :ensure t
  :defer t
  :custom-face
  (highlight-indentation-face ((t (:foreground "IndianRed"))))
  :hook
  ((c++-mode
    c-mode
    emacs-lisp-mode
    fish-mode
    java-mode
    js-mode
    lisp-interaction-mode
    markdown-mode
    python-mode
    rust-mode
    scala-mode
    sh-mode
    web-mode
    yaml-mode) . highlight-indentation-mode)
)

(use-package volatile-highlights
  :ensure t
  :config
  (volatile-highlights-mode t))

;; (use-package emojify
;;   :ensure nil
;;   :hook (after-init . global-emojify-mode))

;; close header when INSIDE the header
;; https://stackoverflow.com/questions/12737317/collapsing-the-current-outline-in-emacs-org-mode
(setq org-cycle-emulate-tab 'white)

(setq org-log-into-drawer "LOGBOOK")
(setq org-hide-emphasis-markers t) ; Hide * and / in org tex.
(setq org-log-done 'time)
(setq org-startup-indented t)           ; heading indentation
(setq org-return-follows-link t)        ; RET to follow links
(setq org-enforce-todo-dependencies t)  ; no done if mid
(setq org-startup-with-inline-images t)
(setq org-image-actual-width nil)
(setq org-clock-sound "~/.emacs.d/bell.wav")

; rebind active to inactive
(with-eval-after-load 'org
  (bind-key "C-c ." #'org-time-stamp-inactive org-mode-map))

(setq org-todo-keywords
      (quote ((sequence "TODO(t)" "EPIC(e)" "NEXT(n)" "WAITING(w)" "ASK(a)" "PROJECT(p)" "MAYBE(m)" "REPEATING(r)" "STARTED(s)" "|" "DONE(d)" "CANCELLED(c)" "DEFERRED(f)"))))

;; (setq org-todo-keywords
;;       (quote ((sequence "TODO(t)" "ASK(k)" "IN-PROGRESS(p)" "SKAITYK(s)" "WAITING(w)" "IGALIOK(i)" "BUY(b)" "REMINDER(r)" "HOME(h)" "|" "DONE(d)" "CANCELLED(c)"))))

;; (setq org-todo-keywords
;;       (quote ((sequence "10min(1)" "2min(2)" "30min(3)" "1val(v)" "PALEK(p)" "SKAITYK(s)" "NEXT(n)" "|" "DONE(d)" "CANCELLED(c)" "REPEATING(r)"))))

;; (setq org-todo-keywords
;;       (quote ((sequence "REPEATING(r)" "TODO(t)" "NEXT(n)" "DELEGATED(D)" "STARTED(S)" "WAITING(w)" "ASK(a)" "SOMEDAY(s)" "PROJECT(p)" "|" "DONE(d)" "PROJDONE(P)" "CANCELLED(c)"))))

;; ;; ;; list-colors-display
(setq org-todo-keyword-faces
      (quote (
              ;; ("REPEATING" :foreground "gold" :weight bold)
              ("TODO" :foreground "IndianRed1" :weight bold)
              ("NEXT" :foreground "DeepSkyBlue2" :weight bold)
              ;; ("DELEGATED" :foreground "magenta" :weight bold)
              ("STARTED" :foreground "cyan" :weight bold)
              ("WAITING" :foreground "chocolate" :weight bold)
              ("ASK" :foreground "lawn green" :weight bold)
              ("APPT" :foreground "slate gray" :weight bold)
              ;; ("PROJECT" :foreground "IndianRed3" :weight bold)
              )))


;; (setq org-todo-keyword-faces
;;       '(("NEXT" . (:background "Deepskyblue2"
;;                                :foreground "black"
;;                                :weight bold
;;                                         :box (:line-width 2
;;                                                   :style released-button)))
;;         ("WAITING" . (:background "yellow"
;;                                   :foreground "black"
;;                                   :weight bold
;;                                   :box (:line-width 2
;;                                                     :style released-button)
;;                         ))
;;                                  ))

;; (setq org-tag-alist
;;       '(("@ERRAND" . ?e)
;;        ("@HOME" . ?h)
;;        ("@WORK" . ?w)
;;        ("@COMPUTER" . ?c)
;;        ("@TRAVELLING" . ?t)
;;        ("@ASK" . ?a)
;;        ("someday" . ?s)
;;        ("read" . ?r)
;;        ("note" . ?n)
;;        ("peace" . ?p)))

;; (setq org-tag-alist
;;       '(
;;         (:startgroup)
;;         ("Handson" . ?o)
;;         (:grouptags)
;;         ("Write" . ?w) ("Code" . ?c) ("Tel" . ?t)
;;         (:endgroup)

;;         (:startgroup)
;;         ("Handsoff" . ?f)
;;         (:grouptags)
;;         ("Read" . ?r) ("View" . ?v) ("Listen" . ?l)
;;         (:endgroup)

;;         ("Mail" . ?@) ("Print" . ?P) ("Buy" . ?b)))

;; (setq org-todo-keywords
;;   '((sequence
;;      "TODO(t!)" ; Initial creation
;;      "GO(g@)"; Work in progress
;;      "WAIT(w@)" ; My choice to pause task
;;      "BLOCKED(b@)" ; Not my choice to pause task
;;      "REVIEW(r!)" ; Inspect or Share Time
;;      "|" ; Remaining close task
;;      "DONE(d)" ; Normal completion
;;      "CANCELED(c)" ; Not going to od it
;;      "DUPLICATE(p)" ; Already did it
;;      )))

;; (setq org-tag-alist '((:startgroup . nil)
;;                       ("@buy" . ?b)
;;                       ("@computer" . ?c)
;;                       ("@home" . ?h)
;;                       ("@travel" . ?t)
;;                       (:endgroup . nil)
;;                       ("emacs" . ?e)
;;                       ("somedaymaybe" . ?s)
;;                       ("citatos" . ?c)
;;                       ("pkc" . ?p)))

;; (setq org-tag-alist '((:startgroup . nil)
;;                       ("@anywhere" . ?a)
;;                       ("@buy" . ?b)
;;                       ("@call" . ?c)
;;                       ("@home" . ?h)
;;                       ("@komputer" . ?k)
;;                       ("@readreview" . ?r)
;;                       ("@repeating" . ?R)
;;                       ("@travel" . ?t)
;;                       ("@pnvz" . ?z)
;;                       ("@waitingfor" . ?w)
;;                       (:endgroup . nil)
;;                       ("emacs" . ?e)
;;                       ("somedaymaybe" . ?s)
;;                       ("pkc" . ?p)))

;; (setq org-tag-alist '((:startgroup . nil)
;;                       ("@work" . ?w) ("@home" . ?h)
;;                       ("@tennisclub" . ?t)
;;                       (:endgroup . nil)
;;                       ("laptop" . ?l) ("pc" . ?p)))

(setq org-agenda-tags-todo-honor-ignore-options t)
;; (setq org-fast-tag-selection-single-key 'expert)

(add-hook 'org-capture-mode-hook
          (lambda ()
            (setq-local org-tag-alist (org-global-tags-completion-table))))

;; Effort
(setq org-columns-default-format "%80ITEM(Task) %10Effort(Effort){:} %10CLOCKSUM")
(setq org-global-properties (quote (("Effort_ALL" . "1:00 0:00 0:05 0:10 0:30 2:00 3:00 4:00 8:00 10:00 15:00")
                                    ("STYLE_ALL" . "habit"))))

;; https://orgmode.org/manual/Editing-Source-Code.html
(setq org-src-fontify-natively t)
(setq org-src-tab-acts-natively t)

;; [2022-04-10 Sun] org tempo added before, now just added templates
(use-package org-tempo
  :after org
  :config
  (add-to-list 'org-structure-template-alist '("sh" . "src shell"))
  (add-to-list 'org-structure-template-alist '("el" . "src emacs-lisp"))
  (add-to-list 'org-structure-template-alist '("py" . "src python ")))

;; automatically save files that were refiled to. Taken from here:
;; https://github.com/rougier/emacs-gtd/issues/9

;; Automatically get the files in "~/Documents/org"
;; with fullpath
;; (setq org-agenda-files
;;       (mapcar 'file-truename
;;            (file-expand-wildcards "~/Dropbox/documents/org/roam/projects/* .org")))

;; Save the corresponding buffers
(defun gtd-save-org-buffers ()
  "Save `org-agenda-files' buffers without user confirmation.
See also `org-save-all-org-buffers'"
  (interactive)
  (message "Saving org-agenda-files buffers...")
  (save-some-buffers t (lambda ()
                         (when (member (buffer-file-name) org-agenda-files)
                           t)))
  (message "Saving org-agenda-files buffers... done"))

;; Add it after refile
;; (advice-add 'org-refile :after
;;             (lambda (&rest _)
;;               (gtd-save-org-buffers)))

;; Save Org buffers after refiling!
(advice-add 'org-refile :after 'org-save-all-org-buffers)

;; last customization - 2022.09.20
;; changed from one massive archive file that all roam projects output
;; to internal archiving. But then noticed, that when I archive, the
;; buffer gets reverted each time, all headings get opened and yeah..
;; its a mess and I don't like that. Also, even though the task is done
;; and archived, it remains in the file, therefore shows in org agenda
;; under "achievable tasks". When I noticed this, I decided to stay
;; under the default or archive settings, which just automatically
;; creates .org_archive file for each project file. I am happy about
;; this now.. Will still have all files in one place for a particular
;; project, they will be out of my agenda and I will not have any
;; buffer reverting.

;; Archiving notes
;; TUT: more about archiving -
;; http://doc.endlessparentheses.com/Var/org-archive-location.html
;; https://orgmode.org/worg/doc.html#org-archive-location

;; its possible to archive like so:
;; # archiving example
;; #+archive: ~/Dropbox/org/archive.org::* 2023
;; #+archive: ~/Dropbox/documents/org/emacs_backups/archive/%s_datetree::datetree/
;; #+archive: ~/Dropbox/documents/org/emacs_backups/archive/archive.org::datetree/* From %s
;; #+archive: ~/Dropbox/documents/org/emacs_backups/archive/archive.org::** From %s
;; #+archive: ::* Archived Tasks - internal archiving
;; #+archive: ::** Arvydas.dev ARCHIVED
;; #+archive: ~/Dropbox/documents/org/references/archive.org::* From Blog

;; archiving with a help of refile into one big archive.org file -
;; dont need all those archive labels in properties tag. too many date
;; inputs to sort through


;; (cond ((eq system-type 'windows-nt)
;;        ;; Windows-specific code goes here.
;;        (setq org-archive-location "C:\\Users\\arvga\\Dropbox\\org\\archive\\%s_archive::")
;;        )
;;       ((eq system-type 'gnu/linux)
;;        ;; Linux-specific code goes here.
;;        (setq org-archive-location "~/Dropbox/org/archive/%s_archive::")
;;        ))
;; (setq org-archive-location "~/Dropbox/org/archive/archive_.org::")

;; (setq org-archive-location (concat org-directory
;;                                    "../zz_archived.org"                   ;; archive file
;;                                    "::"
;;                                    "* Archived from original file %s"  ;; archive header
;;                                    ))

;internal(in the same file) archiving
(setq org-archive-location "%s::* Archive")

;; (setq org-archive-location "~/Dropbox/documents/org/archive/%s_archive::* archive")
;; (setq org-archive-location "~/Dropbox/documents/org/archive/archive_2022-09.org::* archive September")

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

;; bzg config - https://github.com/bzg/dotemacs/blob/master/emacs.org

;; (cond ((eq system-type 'windows-nt)
;;        ;; Windows-specific code goes here.
;;        (setq org-capture-templates
;;              '(("i" "INBOX")
;;                ("ii" "INBOX QUICK" entry (file+headline "C:\\Users\\arvga\\Dropbox\\org\\notes\\pkc_notes\\inbox.org" "inbox")
;;                 "* TODO %?\n:PROPERTIES:\n:Created: %U\n:END:\n" :prepend t :created t)
;;                ("ia" "INBOX su aprasymu" entry (file+headline "C:\\Users\\arvga\\Dropbox\\org\\notes\\pkc_notes\\inbox.org" "inbox")
;;                 "* TODO %^{Todo} \n:PROPERTIES:\n:Created: %U\n:END:\n\n%?\n- %a" :prepend t :created t)
;;                ("s" "SOMEDAY")
;;                ("ss" "SOMEDAY SCHEDULED" entry (file+headline "C:\\Users\\arvga\\Dropbox\\org\\notes\\pkc_notes\\inbox.org" "With Timestamp")
;;                 "* SOMEDAY %?\n  SCHEDULED: %^t\n  :PROPERTIES:\n  :CAPTURED: %U\n  :END:\n\n- %a" :prepend t)
;;                ("sn" "SOMEDAY NON-SCHEDULED" entry (file+headline "C:\\Users\\arvga\\Dropbox\\org\\notes\\pkc_notes\\inbox.org" "With Timestamp")
;;                 "* SOMEDAY %?\n :PROPERTIES:\n  :CAPTURED: %U\n  :END:\n\n- %a" :prepend t)
;;                ("sd" "SOMEDAY DEADLINE" entry (file+headline "C:\\Users\\arvga\\Dropbox\\org\\notes\\pkc_notes\\inbox.org" "With Timestamp")
;;                 "* SOMEDAY %?\n  DEADLINE: %^t\n  :PROPERTIES:\n  :CAPTURED: %U\n  :END:\n\n- %a" :prepend t)
;;                ))
;;        )
;;       ((eq system-type 'gnu/linux)
;;        ;; Linux-specific code goes here.
;;        (setq org-capture-templates
;;              '(
;;                ("i" "INBOX")
;;                ("j" "JOURNAL" entry (file+datetree "~/Dropbox/org/notes/personal_notes/journal.org")
;;                 "* [%<%Y-%m-%d %H:%M>] %? %^G\n %i\n")
;;                ("ii" "INBOX QUICK" entry (file+headline "~/Dropbox/org/notes/pkc_notes/inbox.org" "inbox")
;;                 "* TODO %?\n:PROPERTIES:\n:Created: %U\n:END:\n" :prepend t :created t)
;;                ("ia" "INBOX su aprasymu" entry (file+headline "~/Dropbox/org/notes/pkc_notes/inbox.org" "inbox")
;;                 "* TODO %^{Todo} \n:PROPERTIES:\n:Created: %U\n:END:\n\n%?\n- %a" :prepend t :created t)
;;                ("s" "SOMEDAY")
;;                ("ss" "SOMEDAY SCHEDULED" entry (file+headline "~/Dropbox/org/notes/pkc_notes/inbox.org" "With Timestamp")
;;                 "* SOMEDAY %?\n  SCHEDULED: %^t\n  :PROPERTIES:\n  :CAPTURED: %U\n  :END:\n\n- %a" :prepend t)
;;                ("sn" "SOMEDAY NON-SCHEDULED" entry (file+headline "~/Dropbox/org/notes/pkc_notes/inbox.org" "With Timestamp")
;;                 "* SOMEDAY %?\n :PROPERTIES:\n  :CAPTURED: %U\n  :END:\n\n- %a" :prepend t)
;;                ("sd" "SOMEDAY DEADLINE" entry (file+headline "~/Dropbox/org/notes/pkc_notes/inbox.org" "With Timestamp")
;;                 "* SOMEDAY %?\n  DEADLINE: %^t\n  :PROPERTIES:\n  :CAPTURED: %U\n  :END:\n\n- %a" :prepend t)
;;                )
;;              )
;;        )
;;       )


(cond ((eq system-type 'windows-nt)
         (setq org-capture-templates
               '(
;;                ("ii" "INBOX" entry (file+headline "C:\\Users\\arvga\\Dropbox\\org\\notes\\pkc_notes\\inbox.org" "inbox")
;;                 "* TODO %?\n:PROPERTIES:\n:Created: %U\n:END:\n" :prepend t :created t)
;;                ("it" "TODO" entry (file+headline "C:\\Users\\arvga\\Dropbox\\org\\notes\\pkc_notes\\inbox.org" "inbox")
;;                 "* TODO %^{Todo} \n:PROPERTIES:\n:Created: %U\n:END:\n\n%?\n- %a" :prepend t :created t)
;;                ("it" "SCHEDULED" entry (file+headline "C:\\Users\\arvga\\Dropbox\\org\\notes\\pkc_notes\\inbox.org" "inbox")
                 ;;                 "* TODO %^{Todo} \n:PROPERTIES:\n:Created: %U\n:END:\n\n%?\n- %a" :prepend t :created t)
                 ("i" "Inbox" entry (file+headline "C:\\Users\\arvga\\.arvydas\\org\\pkc_notes\\gtd.org" "Tasks")
                  "* TOOD %^{Task}\n:PROPERTIES:\n:CAPTURED:%U\n:END:\n\n%?")
                 ("j" "Journal" entry(file+datetree "C:\\Users\\arvga\\.arvydas\\org\\pkc_notes\\journal.org")
                  "* [%<%Y-%m-%d %H:%M>] %^{Title}\n%?":tree-type month)
                 ;; ("j" "Journal-TAG" entry(file+datetree "~/Dropbox/org/notes/journal.org")
                 ;;  "* [%<%Y-%m-%d %H:%M>] %? %^G\n %i\n" :tree-type month)
                 ))
       )
      ((eq system-type 'gnu/linux)
         (setq org-capture-templates
               '(
                 ("i" "Inbox" entry (file+headline "~/Dropbox/org/inbox.org" "Inbox")
                  "* %? \n:PROPERTIES:\n:CAPTURED:%U\n:END:\n\n")
                 ("t" "Todo Entry" entry (file+headline "~/Dropbox/org/inbox.org" "Inbox")
                  "* TODO %? \n:PROPERTIES:\n:CAPTURED:%U\n:END:\n\n")
                 ;; ("a" "Agenda" entry (file+headline "~/Dropbox/org/inbox.org" "Inbox")
                 ;;  "* TODO %^{Task} %^G\n:PROPERTIES:\n:CAPTURED:%U\n:END:\n\n%?")
                 ;; ("j" "Journal" entry(file+datetree "~/Dropbox/org/journal.org")
                 ;;  "* [%<%Y-%m-%d %H:%M>] %^{Title}\n%?":tree-type month)
                 ;; ("d" "Daily review" entry(file+datetree "~/Dropbox/org/journal.org")
                 ;;  "* [%<%Y-%m-%d %H:%M>] Today's summary\n%?\n%[~/Dropbox/org/.daily_review.txt]":tree-type month)
                 ;; ("j" "Journal-TAG" entry(file+datetree "~/Dropbox/org/notes/journal.org")
                 ;;  "* [%<%Y-%m-%d %H:%M>] %? %^G\n %i\n" :tree-type month)
                 ))
         ))

;; WSL-specific setup
(when (and (eq system-type 'gnu/linux)
           (getenv "WSLENV"))
         (setq org-capture-templates
               '(
                 ("i" "Inbox" entry (file+headline "/mnt/c/Users/arvga/stuff/org/inbox.org" "Inbox")
                  "* %? \n:PROPERTIES:\n:CAPTURED:%U\n:END:\n\n")
                 ))
  )

;; (setq org-capture-templates
;;       '(("1" "10min" plain (file+headline "~/Dropbox/org/personal_notes/inbox.org" "Inbox")
;;          "** 10min %?")
;;         ("2" "2min" plain (file+headline "~/Dropbox/org/notes/inbox.org" "Inbox")
;;          "** 2min %?")
;;         ("t" "TOOD" plain (file+headline "~/Dropbox/org/notes/inbox.org" "Inbox")
;;          "** 2min %?")
;;         ("3" "30min" plain (file+headline "~/Dropbox/org/notes/inbox.org" "Inbox")
;;          "** 30min %?")
;;         ("v" "1val" plain (file+headline "~/Dropbox/org/notes/inbox.org" "Inbox")
;;          "** 1val %?")
;;         ("p" "PALEK" plain (file+headline "~/Dropbox/org/notes/inbox.org" "Inbox")
;;          "** PALEK %?")
;;         ("s" "SKAITYK" plain (file+headline "~/Dropbox/org/notes/inbox.org" "Inbox")
;;          "** SKAITYK %?")
;;         ("l" "lokacija" plain (file+headline "~/Dropbox/org/notes/inbox.org" "Inbox")
;;          "** TODO %?\n  %i\n  %a")
;;         ;; ("d" "diary august" plain (file+headline "~/Dropbox/documents/org/roam/personal/20220508141623-diary.org" "diary september") "** %U %^{Title}\n%?"))
;;       ))

;; (setq org-capture-templates
;;       '(("t" "TODO" plain (file+headline "~/Dropbox/documents/org/roam/20220504192335-inbox.org" "Inbox")
;;          "** TODO %?")
;;         ("k" "Inbox" plain (file+headline "~/Dropbox/documents/org/roam/20220504192335-inbox.org" "Inbox")
;;          "** ASK %?")
;;         ("p" "IN-PROGRESS" plain (file+headline "~/Dropbox/documents/org/roam/20220504192335-inbox.org" "Inbox")
;;          "** IN-PROGRESS %?")
;;         ("s" "SKAITYK" plain (file+headline "~/Dropbox/documents/org/roam/20220504192335-inbox.org" "Inbox")
;;          "** SKAITYK %?")
;;         ("w" "WAITING" plain (file+headline "~/Dropbox/documents/org/roam/20220504192335-inbox.org" "Inbox")
;;          "** WAITING %?")
;;         ("i" "IGALIOK" plain (file+headline "~/Dropbox/documents/org/roam/20220504192335-inbox.org" "Inbox")
;;          "** WAITING %?")
;;         ("b" "BUY" plain (file+headline "~/Dropbox/documents/org/roam/20220504192335-inbox.org" "Inbox")
;;          "** BUY %?")
;;         ("r" "REMINDER" plain (file+headline "~/Dropbox/documents/org/roam/20220504192335-inbox.org" "Inbox")
;;          "** REMINDER %?")
;;         ("h" "HOME" plain (file+headline "~/Dropbox/documents/org/roam/20220504192335-inbox.org" "Inbox")
;;          "** HOME %?")
;;         ("d" "Diary" entry (file+datetree "~/Dropbox/documents/org/roam/20220508141623-diary.org" "diary")
;;          "* %<%H:%M>: %?")
;;         ("l" "location" plain (file+headline "~/Dropbox/documents/org/roam/20220504192335-inbox.org" "Inbox")
;;          "** TODO %?\n  %i\n  %a")
;;         ))

;; jeigu nori keybindint directly to a key
;; (define-key global-map (kbd "C-c c")
;;   (lambda () (interactive) (org-capture nil "i")))

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

(setq org-log-note-clock-out t)
(setq org-clock-out-when-done t)        ; Clock out when moving task to a done state
(org-clock-persistence-insinuate)       ; Resume clocking task when emacs is restarted
(setq org-clock-persist t)              ; Save the running clock and all clock history when exiting Emacs, load it on startup
(setq org-clock-in-resume t)            ; Resume clocking task on clock-in if the clock is open
(setq org-clock-persist-query-resume nil) ; Do not prompt to resume an active clock, just resume it
(define-key org-mode-map (kbd "C-c C-x C-r") 'org-clock-report) ; Keybind dissapeared after new org install? When roam.
(setq org-clock-idle-time 15)                                   ; ask what to do with a left and forgotten clock
(setq org-clock-in-switch-to-state "STARTED")
(setq org-clock-out-switch-to-state "WAITING")
(setq org-clock-into-drawer "LOGBOOK")
(global-set-key (kbd "C-c C-x C-j") 'org-clock-goto) ; exists, but remapping to be global
(setq org-clock-history-length 23)                   ; C-c I show history of clocks

;; tipo lengviau clock in padaryti, nes matai a list of recent clocks?
(defun eos/org-clock-in ()
  (interactive)
  (org-clock-in '(4)))

(global-set-key (kbd "C-c i") #'eos/org-clock-in) ; list of tasks, choose one
(global-set-key (kbd "C-c C-x C-o") #'org-clock-out)

;;; ---------------------------------------

;; this functions is later used in clock reports. Check org_clock
;; looking through all the folders inside 2020, great!
;; later this function is used in clock report
(defun add-dailies ()
  (append org-agenda-files
          (file-expand-wildcards "~/Dropbox/documents/org/roam/daily/2022/**/*.org")))

;; only looking through one folder
;; (defun add-dailies ()
;;   (append org-agenda-files
;;           (file-expand-wildcards "~/Dropbox/documents/org/roam/daily/2022/kovo/*.org")))

;;; ---------------------------------------

;; ORG CLOCK REPORT EXAMPLES

;; documentation is here - https://orgmode.org/manual/The-clock-table.html

;; [2022-04-10 Sun] Daily org-diary file report BY TAG
;; #+BEGIN: clocktable :maxlevel 3 :scope file :tags t :sort (1 . ?a) :emphasize t :narrow 100! :match "emacs"

;; [2022-04-10 Sun] Daily org-diary file report without tag, show all tasks
;; #+BEGIN: clocktable :maxlevel 3 :scope file :tags t :sort (1 . ?a) :emphasize t :narrow 100!

;; #+BEGIN: clocktable :maxlevel 3 :scope add-dailies :tags t
;; #+BEGIN: clocktable :maxlevel 3 :scope file :step day :tstart "<-1w>" :tend "<now>" :compact t
;; #+BEGIN: clocktable :maxlevel 5 :compact nil :emphasize t :scope subtree :timestamp t :link t :header "#+NAME: 2022_Vasaris\n"
;; #+BEGIN: clocktable :maxlevel 1 :compact t :emphasize t :timestamp t :link t
;; #+BEGIN: clocktable :maxlevel 5 :compact t :sort (1 . ?a) :emphasize t :scope subtree :timestamp t :link t

;; (use-package org-download
;;   :ensure nil
;;   :defer t
;;   :commands org-download)

;; (setq-default org-download-image-dir "~/Dropbox/documents/org/images_nejudink")

(use-package org-pomodoro
  :ensure t
  :commands (org-pomodoro)
  :config
  (setq org-pomodoro-ticking-sound-p nil)
  ;; (setq alert-user-configuration (quote ((((:category . "org-pomodoro")) libnotify nil))))
  )

(use-package org-static-blog
  :ensure t)

(setq org-static-blog-publish-title "arvydasg.github.io")
(setq org-static-blog-publish-url "https://arvydasg.github.io/")
(setq org-static-blog-publish-directory "~/Dropbox/src/arvydasg.github.io/")
(setq org-static-blog-posts-directory "~/Dropbox/arvydasg.github.io_blog_content/")
(setq org-static-blog-drafts-directory "/home/arvydas/Dropbox/arvydasg.github.io_blog_content/")
;; (setq org-static-blog-drafts-directory "~/Dropbox/src/arvydasg.github.io/drafts/")
(setq org-static-blog-index-length 5)
(setq org-static-blog-preview-link-p t)
(setq org-static-blog-preview-date-first-p t)
(setq org-static-blog-use-preview t)
(setq org-static-blog-enable-tags t)
(setq org-export-with-toc nil)            ;can add in individual file with #+OPTIONS: toc:1/nil
(setq org-export-with-section-numbers nil) ;can add in individual file with #+OPTIONS: num:nil
(setq org-static-blog-no-post-tag "nonpost")

;; This header is inserted into the <head> section of every page:
;;   (you will need to create the style sheet at
;;    ~/projects/blog/static/style.css
;;    and the favicon at
;;    ~/projects/blog/static/favicon.ico)
(setq org-static-blog-page-header
      "<!-- Google Tag Manager -->
<script>(function(w,d,s,l,i){w[l]=w[l]||[];w[l].push({'gtm.start':
new Date().getTime(),event:'gtm.js'});var f=d.getElementsByTagName(s)[0],
j=d.createElement(s),dl=l!='dataLayer'?'&l='+l:'';j.async=true;j.src=
'https://www.googletagmanager.com/gtm.js?id='+i+dl;f.parentNode.insertBefore(j,f);
})(window,document,'script','dataLayer','GTM-MC4ZQHP');</script>
<!-- End Google Tag Manager -->
<meta name=\"author\" content=\"Arvydas Gasparavicius\">
<meta name=\"referrer\" content=\"no-referrer\">
<meta name=\"viewport\" content=\"initial-scale=1,width=device-width,minimum-scale=1\">
<link href= \"static/style.css\" rel=\"stylesheet\" type=\"text/css\" />
<script src=\"static/lightbox.js\"></script>
<script src=\"static/auto-render.min.js\"></script>
<link rel=\"icon\" href=\"static/ag.ico\">")

;; This preamble is inserted at the beginning of the <body> of every page:
;;   This particular HTML creates a <div> with a simple linked headline
(setq org-static-blog-page-preamble
"
<header>
<!-- Google Tag Manager (noscript) -->
<noscript><iframe src=\"https://www.googletagmanager.com/ns.html?id=GTM-MC4ZQHP\"
height=\"0\" width=\"0\" style=\"display:none;visibility:hidden\"></iframe></noscript>
<!-- End Google Tag Manager (noscript) -->
    <div class=\"container\">
        <div class=\"subcontainer\">
            <nav class=\"nav\">
                <a href=\"https://arvydasg.github.io/\" class=\"nav-logo-wrapper\">
                    <p class=\"nav-branding\">Arvydas.dev</p>
                </a>
                <ul class=\"nav-menu\">
                    <li class=\"nav-item\">
                        <a href=\"https://arvydasg.github.io/tag-project.html\" class=\"nav-link\">Projects</a>
                    </li>
                    <li class=\"nav-item\">
                        <a href=\"https://arvydasg.github.io/archive.html\" class=\"nav-link\">Blog</a>
                    </li>
                    <li class=\"nav-item\">
                        <a href=\"https://arvydasg.github.io/tags.html\" class=\"nav-link\">Tags</a>
                    </li>
                    <li class=\"nav-item\">
                        <a href=\"https://arvydas.dev/codeacademy/\" class=\"nav-link\">CodeAcademy</a>
                    </li>
                    <li class=\"nav-item\">
                        <a href=\"https://arvydasg.github.io/freelancing.html\" class=\"nav-link\">Freelancing</a>
                    </li>
                    <li class=\"nav-item\">
                        <a href=\"https://arvydasg.github.io/uses.html\" class=\"nav-link\">Uses</a>
                    </li>
                    <li class=\"nav-item\">
                        <a href=\"https://arvydasg.github.io/about.html\" class=\"nav-link\">About</a>
                    </li>
                </ul>
                <div class=\"hamburger\">
                    <span class=\"bar\"></span>
                    <span class=\"bar\"></span>
                    <span class=\"bar\"></span>
                </div>
            </nav>
        </div>
    </div>
    </header>
    "
)

;; before hamburger
;; (setq org-static-blog-page-preamble
;; "
;; <div id=\"nav-content\">
;; <div class=\"header\">
;;    <a href=\"https://arvydasg.github.io/\">Arvydas.dev</a>
;;   <div class=\"sitelinks\">
;;     <a href=\"https://arvydasg.github.io/about.html\">About</a> | <a href=\"https://arvydasg.github.io/freelancing.html\">Freelancing</a> | <a href=\"https://arvydasg.github.io/tag-project.html\">Projects</a> | <a href=\"https://arvydasg.github.io/archive.html\">Blog</a> | <a href=\"https://arvydasg.github.io/uses.html\">Uses</a> | <a href=\"https://arvydas.dev/codeacademy/\">CodeAcademy</a>
;;   </div>
;; <hr>
;;   </div>
;; </div>"
;; )

;; (setq org-static-blog-page-preamble

;; "<div class=\"header\">
;;   <a href=\"https://arvydasg.github.io/\">Arvydas Scratchpad on the Internet</a>
;;   <div class=\"sitelinks\">
;;     <a href=\"https://github.com/arvydasg\">Github</a> | <a href=\"https://arvydasg.github.io/projects.html\">Projects</a> | <a href=\"https://arvydasg.github.io/archive.html\">Archive</a> | <a href=\"https://arvydasg.github.io/uses.html\">Uses</a> | <a href=\"https://arvydasg.github.io/about.html\">About</a>
;;   </div>
;; </div>"
;;       )

;; This postamble is inserted at the end of the <body> of every page:
;;   This particular HTML creates a <div> with a link to the archive page
;;   and a licensing stub.
(setq org-static-blog-page-postamble
      "<div id=\"footer\">
<hr>
<p>© 2021-2023 Arvydas Gasparavičius</p>
  <button onclick=\"topFunction()\" id=\"myBtn\" title=\"Go to top\">Top</button>
  <script src=\"static/script.js\"></script>
</div>")

;; (setq org-static-blog-page-postamble
;;       "<div id=\"archive\">
;;   <a href=\"./archive.html\">Other posts</a>
;; </div>")

;; This HTML code is inserted into the index page between the preamble and
;;   the blog posts
(setq org-static-blog-index-front-matter
      "<h1> Hello there 👋 </h1>
<hr>
<div id=\"intro\">
<p> My name is Arvydas I am self-taught Python/Django developer. <a class=\"no-link\" href=\"https://github.com/arvydasg\">My Github</a>.</p>
<p> I am currently immersing myself in a comprehensive 9-month web development and Python course led by <a class=\"no-link\" href=\"./tag-codeacademy.html\">CodeAcademy</a>, with the goal of expanding my programming skills and knowledge.<p>
<p> I also work as a freelance developer. <a class=\"no-link\" href=\"./freelancing.html\">Read more about my work.</a><p>
<p> If you are interested in some of my writings, here are some of my latest posts:</p>
</div>
\n\n\n")



;; ----------------------------------------------------------

;; after each emacs restart files that I modified in elpa directory
;; are not recompiled. I was advised by Bastibe to place them in my
;; emacs config. It still does not get evaluated for some reason

;; forgot what I changed here form the original file, but will leave
;; it here nevertheless :)
(defun org-static-blog-get-preview (post-filename)
  "Get title, date, tags from POST-FILENAME and get the first paragraph from the rendered HTML.
If the HTML body contains multiple paragraphs, include only the first paragraph,
and display an ellipsis.
Preamble and Postamble are excluded, too."
  (with-temp-buffer
    (insert-file-contents (org-static-blog-matching-publish-filename post-filename))
    (let ((post-title (org-static-blog-get-title post-filename))
          (post-date (org-static-blog-get-date post-filename))
          (post-taglist (org-static-blog-post-taglist post-filename))
          (post-ellipsis "")
          (preview-region (org-static-blog--preview-region)))
      (when (and preview-region (search-forward "<p>" nil t))
        (setq post-ellipsis
              (concat (when org-static-blog-preview-link-p
                        (format "<a class=\"read-more\" href=\"%s\">"
                                (org-static-blog-get-post-url post-filename)))
                      org-static-blog-preview-ellipsis
                      (when org-static-blog-preview-link-p "</a>\n"))))
      ;; Put the substrings together.
      (let ((title-link
             (format "<h2 class=\"post-title\"><a href=\"%s\">%s</a></h2>"
                     (org-static-blog-get-post-url post-filename) post-title))
            (date-link
             (format-time-string (concat "<div class=\"post-date\">"
                                         (org-static-blog-gettext 'date-format)
                                         "</div>")
                                 post-date)))
        (concat
         (if org-static-blog-preview-date-first-p
             (concat date-link title-link)
           (concat date-link title-link))
         preview-region
         post-ellipsis
         (format "<div class=\"taglist\">%s</div><hr>" post-taglist))))))


;; Read more instead of ( ... )
(defcustom org-static-blog-preview-ellipsis "Read more →"
  "The HTML appended to the preview if some part of the post is hidden.

The contents shown in the preview is determined by the values of
the variables `org-static-blog-preview-start' and
`org-static-blog-preview-end'."
  :type '(string)
  :safe t)

(setq org-agenda-prefix-format '(
  (agenda  . " %i %-12:c%?-12t% s")
  (agenda  . "  • ")
  ;; (timeline  . "  % s")
  ;; (todo  . " %i %-12:c")
  ;; (tags  . " %i %-12:c")
  ;; (search . " %i %-12:c")
  ))
(setq system-time-locale "C")
(setq org-agenda-inhibit-startup t)
(global-set-key (kbd "C-c a") 'org-agenda)
(setq org-agenda-start-with-log-mode '(closed))
(setq org-agenda-skip-scheduled-if-done t) ; if task is scheduled and is DONE - dont show in agenda. dvigubinasi jeigu ijungi ir archived tasks
;; (setq org-agenda-prefix-format "%t %s")
(setq org-agenda-restore-windows-after-quit t)
(setq org-agenda-sticky nil)
(setq org-agenda-show-future-repeats nil)
(setq org-agenda-span 1)
(require 'org-habit)
(setq org-agenda-tags-column 90)
(setq org-habit-graph-column 60)
(setq org-todo-repeat-to-state "REPEATING")
;; (setq org-scheduled-past-days 0)        ;jeigu nenori +1 days

(setq org-complete-tags-always-offer-all-agenda-tags t) ;allows to use tags in ALL agenda files
(setq org-agenda-use-tag-inheritance t) ;xuj znajesh
(setq org-use-tag-inheritance nil)      ;nepaveldi subtasks heading tago

(cond ((eq system-type 'windows-nt)
       ;; Windows-specific code goes here.
       (setq org-directory "C:\\Users\\arvga\\.arvydas\\org\\pkc_notes")
       (setq org-agenda-files (directory-files-recursively "C:\\Users\\arvga\\.arvydas\\org\\pkc_notes" "\\.org$"))
       )
      ((eq system-type 'gnu/linux)
       ;; Linux-specific code goes here.
       (setq org-directory "~/Dropbox/org/")
       (setq org-agenda-files '(
                                "~/Dropbox/src/pagalbaGyvunams/pagalbaGyvunams.org"
                                "~/.emacs.d/my-init.org"
                                ))
       ;; (setq org-agenda-files (directory-files-recursively "~/Dropbox/org/" "\.org$"))
       (setq org-refile-targets '((org-agenda-files :maxlevel . 9)))
       ))

;; siaip abu du apacioje veikia, be gal but jie yra cause tu erroru> Isjungiu, patikrinam.
;; (add-hook 'org-trigger-hook 'save-buffer) ;after every state change - save buffer

;; (setq org-archive-subtree-save-file-p t) ;if archiving from agenda - saves the buffer

;; WSL-specific setup
(when (and (eq system-type 'gnu/linux)
           (getenv "WSLENV"))
  (setq org-directory "/mnt/c/Users/arvga/stuff/org/")
  (setq org-agenda-files '(
                           ;; "~/Dropbox/org/archive.org"
                           ;; "~/Dropbox/org/notebook.org"
                           "/mnt/c/Users/arvga/stuff/org/notebook.org"
                           "/mnt/c/Users/arvga/stuff/org/agenda.org"
                           "/mnt/c/Users/arvga/stuff/org/inbox.org"
                           ))
  )

(setq org-archive-save-context-info '(time file category todo itags olpath ltags)) ;info that gets added when archiving, category is important in my case
;; (setq org-archive-save-context-info '(time))


;; (setq org-archive-mark-done t)          ;not really useful, since archiving notes also?

;; * org-mode configuration
;;  #+STARTUP: overview
;;  #+STARTUP: hidestars
;;  #+STARTUP: logdone
;;  #+PROPERTY: Effort_ALL  0:10 0:20 0:30 1:00 2:00 4:00 6:00 8:00
;;  #+COLUMNS: %38ITEM(Details) %TAGS(Context) %7TODO(To Do) %5Effort(Time){:} %6CLOCKSUM{Total}
;;  #+PROPERTY: Effort_ALL 0 0:10 0:20 0:30 1:00 2:00 3:00 4:00 8:00
;;  #+TAGS: { OFFICE(o) HOME(h) } COMPUTER(c) PROJECT(p) READING(r) ERRANDS(e)
;;  #+TAGS: DVD(d) LUNCHTIME(l)
;;  #+archive: ~/Dropbox/org/notes/archive.org::


;; finally fixed org agenda files on STARTUP here:
;; https://emacs.stackexchange.com/questions/39478/emacs-not-loading-org-agenda-files-on-startup

;; (cond ((eq system-type 'windows-nt)
;;        ;; Windows-specific code goes here.
;;        (setq org-refile-targets (quote (("C:\\Users\\arvga\\.arvydas\\org\\pkc_notes\\gtd.org" :maxlevel . 1)
;;                                         ("C:\\Users\\arvga\\.arvydas\\org\\pkc_notes\\someday.org" :level . 2)
;;                                         ("C:\\Users\\arvga\\.arvydas\\org\\pkc_notes\\references.org" :level . 1)
;;                                         )))
;;        )
;;       ((eq system-type 'gnu/linux)
;;        ;; Linux-specific code goes here.
;;        (setq org-refile-targets (quote (("~/Dropbox/org/notes/gtd.org" :maxlevel . 1)
;;                                         ("~/Dropbox/org/notes/someday.org" :level . 2))))
;;        ))


;; (setq org-refile-targets (quote (
;;                                  ("~/Dropbox/org/agenda.org" :maxlevel . 2)
;;                                  ("~/Dropbox/org/references.org" :maxlevel . 1)
;;                                  ("~/Dropbox/org/notebook.org" :maxlevel . 2)
;;                                  )))

;; (defun set-org-agenda-files ()
;;   "Set different org-files to be used in `org-agenda`."
;;   (setq org-agenda-files (list (concat org-directory "todo.org")
;;                                (concat org-directory "repeating.org")
;;                                (concat org-directory "stasys.org"))))
;; (set-org-agenda-files)

;; (setq org-agenda-custom-commands
;; '(

;; ("p" "Projects"
;; ((todo "PROJECT")))

;; ;; ("h" "Office and Home Lists"
;; ;;      ((agenda)
;; ;;           (tags-todo "OFFICE")
;; ;;           (tags-todo "HOME")
;; ;;           (tags-todo "COMPUTER")
;; ;;           (tags-todo "DVD")
;; ;;           (tags-todo "READING")))

;; ;; ("d" "THE MOST IMPORTANTTTTTTTT!!!!!!!!"
;; ;;      (
;; ;;           (agenda "" ((org-agenda-ndays 1)
;; ;;                       (org-agenda-sorting-strategy
;; ;;                        (quote ((agenda time-up priority-down tag-up) )))
;; ;;                       (org-deadline-warning-days 0)
;; ;;                       ))))
;; )
;; )


(setq org-agenda-custom-commands
      '(
        ("a" "My Agenda"
         (
          (agenda "")
          (todo "STARTED" (
                                (org-agenda-overriding-header "Started")
                                ))
          (todo "PROJECT" (
                                (org-agenda-overriding-header "Projects")
                                ))
          (todo "WAITING" (
                                (org-agenda-overriding-header "Waiting")
                                ))
          (todo "NEXT" (
                             (org-agenda-overriding-header "Next actions:")
                             ))
          (todo "ASK" (
                       (org-agenda-overriding-header "ASK:")
                       ))
          (tags "/+DONE|+CANCELLED"
                ((org-agenda-overriding-header "Archivable tasks")))
          )
         )
        )
      )


;; (setq org-agenda-custom-commands
;;       '(
;;         ("p" "PERSONAL Agenda"
;;          (
;;           (agenda "" (;; (org-agenda-span 7)
;;                       (org-agenda-tag-filter-preset '("-pkc"))))
;;           (tags-todo "-pkc/!STARTED" (
;;                                       (org-agenda-overriding-header "Started")
;;                                       (org-agenda-tag-filter-preset '("-pkc"))
;;                                       ))
;;           (tags-todo "-pkc/!PROJECT" (
;;                                       (org-agenda-overriding-header "Projects")
;;                                       (org-agenda-tag-filter-preset '("-pkc"))
;;                                       ))
;;           (tags-todo "-pkc/!WAITING" (
;;                                       (org-agenda-overriding-header "Waiting")
;;                                       (org-agenda-tag-filter-preset '("-pkc"))
;;                                       ))
;;           (tags-todo "-pkc/!NEXT" (
;;                                    (org-agenda-overriding-header "Next actions:")
;;                                    (org-agenda-tag-filter-preset '("-pkc"))
;;                                    ))
;;           (todo "ASK" (
;;                        (org-agenda-overriding-header "ASK:")
;;                        (org-agenda-tag-filter-preset '("-pkc"))
;;                        ))
;;           )
;;          )
;;         ("w" "WORK agenda "
;;          (
;;           (agenda "" (;; (org-agenda-span 7)
;;                       (org-agenda-tag-filter-preset '("+pkc"))))
;;           (tags-todo "pkc/!PROJECT" (
;;                                      (org-agenda-overriding-header "Projects:")
;;                                      (org-agenda-tag-filter-preset '("+pkc"))
;;                                      ))
;;           (tags-todo "+pkc/!STARTED" (
;;                                       (org-agenda-overriding-header "Started tasks:")
;;                                       (org-agenda-tag-filter-preset '("+pkc"))
;;                                       ))
;;           (tags-todo "+pkc/!WAITING" (
;;                                       (org-agenda-overriding-header "Waiting for something:")
;;                                       (org-agenda-tag-filter-preset '("+pkc"))
;;                                       ))
;;           (tags-todo "+pkc/!NEXT" (
;;                                    (org-agenda-overriding-header "Next actions:")
;;                                    (org-agenda-tag-filter-preset '("+pkc"))
;;                                    ))
;;           (tags-todo "+pkc/!ASK" (
;;                                   (org-agenda-overriding-header "Ask someone:")
;;                                   (org-agenda-tag-filter-preset '("+pkc"))
;;                                   ))
;;           )
;;          )
;;         ;; ("e" "Emacs Tasks" tags-todo "+emacs-arvydasDev-personal")
;;         ))

;; (setq org-agenda-custom-commands
;;       '(("a" "Simple agenda view"
;;          ((agenda "")
;;           (todo "IN-PROGRESS" "")
;;            (tags "/+DONE|+CANCELLED"
;;                  ((org-agenda-overriding-header "Archivable tasks")
;;                   (org-use-tag-inheritance '("project"))))))))

;; (setq org-agenda-custom-commands
;;       '(("ta" "Anywhere" tags-todo "@anywhere-somedaymaybe/!TODO")
;;         ("tb" "Buy" tags-todo "@buy-somedaymaybe/!TODO")
;;         ("tc" "Calls/asks" tags-todo "@call-somedaymaybe-@repeating/!TODO")
;;         ("th" "Home" tags-todo "@home-somedaymaybe-@repeating/!TODO")
;;         ("tk" "Komputer" tags-todo "@komputer-somedaymaybe-@repeating/!TODO")
;;         ("tr" "Readreview" tags-todo "@readreview-somedaymaybe-@repeating/!TODO")
;;         ("tt" "Travel" tags-todo "@travel-somedaymaybe-@repeating/!TODO")
;;         ("tp" "Pkc" tags-todo "pkc-@repeating-somedaymaybe/!TODO"
;;          ((org-agenda-skip-function '(org-agenda-skip-entry-if 'scheduled 'deadline)))
;;          )
;;         ("tz" "Panevezys" tags-todo "@pnvz-somedaymaybe-@repeating/!TODO")
;;         ("tw" "Waitingfor" tags-todo "@waitingfor-somedaymaybe-@repeating/!TODO")
;;         ("ts" "Someday/maybe" tags-todo "-@repeating+somedaymaybe+LEVEL=2" ;show ONLY level 2 heading
;;          ((org-agenda-dim-blocked-tasks nil)))
;;         ("a" "Agenda"
;;          ((agenda ""
;;                   ((org-agenda-span 2)))
;;           (tags-todo "@anywhere-somedaymaybe|@call-somedaymaybe|@internet-somedaymaybe|@komputer-somedaymaybe/!TODO"
;;                      ((org-agenda-overriding-header "Common next actions")
;;                       (org-agenda-dim-blocked-tasks 'invisible)
;;                       (org-agenda-skip-function '(org-agenda-skip-entry-if 'scheduled 'deadline))))
;;           (tags-todo "@home-somedaymaybe/!TODO"
;;                      ((org-agenda-overriding-header "Home actions")
;;                       (org-agenda-dim-blocked-tasks 'invisible)))
;;           (tags-todo "@waitingfor-somedaymaybe/!TODO"
;;                      ((org-agenda-overriding-header "Waiting for")
;;                       (org-agenda-dim-blocked-tasks 'invisible)))
;;           (tags-todo "@pnvz-somedaymaybe/!TODO"
;;                      ((org-agenda-overriding-header "Errands Pnvz")
;;                       (org-agenda-dim-blocked-tasks 'invisible)))
;;           (tags-todo "@readreview-somedaymaybe/!TODO"
;;                      ((org-agenda-overriding-header "Read/review")
;;                       (org-agenda-dim-blocked-tasks 'invisible)))
;;           (tags "/+DONE|+CANCELLED"
;;                 ((org-agenda-overriding-header "Archivable tasks")
;;                  (org-use-tag-inheritance '("project"))))
;;           (tags-todo "-@repeating-pkc-@buy-@travel-emacs-@anywhere-@call-@internet-@komputer-@home-@readreview-@waitingfor-somedaymaybe/!TODO"
;;                 ((org-agenda-overriding-header "Contextless tasks")))
;;           ))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; (setq org-agenda-custom-commands
;;       '(("a" "Agenda asmenine"
;;          ((agenda ""
;;                   ((org-agenda-span 1)))
;;           (tags "PRIORITY=\"A\""
;;                 ((org-agenda-skip-function '(org-agenda-skip-entry-if 'todo 'done))
;;                  (org-agenda-overriding-header "High-priority unfinished tasks:")))
;;           (alltodo ""
;;                     ;kazkodel tik sitas pkc filter turi effect, gal lad in alltodo
;;                    (;; (org-agenda-tag-filter-preset '("-pkc"))
;;                     (org-agenda-skip-function
;;                      '(or (air-org-skip-subtree-if-priority ?A)
;;                           (org-agenda-skip-if nil '(scheduled deadline))))))))
;;         ("p" "pkc"
;;          ((agenda ""
;;                   ((org-agenda-span 1)))
;;           (tags "PRIORITY=\"A\""
;;                 ((org-agenda-skip-function '(org-agenda-skip-entry-if 'todo 'done))
;;                  (org-agenda-overriding-header "High-priority unfinished tasks:")))
;;           (alltodo "-ISMOK"
;;                     ;kazkodel tik sitas pkc filter turi effect, gal lad in alltodo
;;                    ((org-agenda-tag-filter-preset '("+pkc"))
;;                     (org-agenda-skip-function
;;                      '(or (air-org-skip-subtree-if-priority ?A)
;;                           (org-agenda-skip-if nil '(scheduled deadline))
;;                           (org-agenda-skip-entry-if 'todo '("ISMOK"))))))
;;           (todo "ISMOK"
;;                 ((org-agenda-tag-filter-preset '("+pkc"))
;;                  (org-agenda-skip-function
;;                      '(or (air-org-skip-subtree-if-priority ?A)
;;                           (org-agenda-skip-if nil '(scheduled deadline))))))))
;;         ("c" "Calls" tags-todo "namai/!WAITING")))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

        ;; ("x" "Personal agenda"
        ;;  ((agenda "" ((org-agenda-span 7)
        ;;               (org-agenda-tag-filter-preset '("-pkc"))))))

        ;; the longer I tweak the more I see you don't need custom
        ;; views.. all can be achieved inside agenda
        ;; ("p" "PKC view"
        ;;  ((tags "PRIORITY=\"A\""
        ;;         ((org-agenda-skip-function '(org-agenda-skip-entry-if 'todo 'done))
        ;;          (org-agenda-overriding-header "High-priority unfinished tasks:")))
        ;;   (agenda ""
        ;;           ((org-agenda-span 1)))
        ;;   (alltodo ""
        ;;             ;kazkodel tik sitas pkc filter turi effect, gal lad in alltodo
        ;;            (;; (org-agenda-tag-filter-preset '("+pkc"))
        ;;             (org-agenda-skip-function
        ;;              '(or (air-org-skip-subtree-if-priority ?A)
        ;;                   (org-agenda-skip-if nil '(scheduled deadline))))))))

        ;; slashes are must to record second quotes
        ;; ("z" "effort stuff" tags-todo "Effort=\"0:10\"")

;; (defun air-org-skip-subtree-if-priority (priority)
;;   "Skip an agenda subtree if it has a priority of PRIORITY.
;; PRIORITY may be one of the characters ?A, ?B, or ?C."
;;   (let ((subtree-end (save-excursion (org-end-of-subtree t)))
;;         (pri-value (* 1000 (- org-lowest-priority priority)))
;;         (pri-current (org-get-priority (thing-at-point 'line t))))
;;     (if (= pri-value pri-current)
;;         subtree-end
;;       nil)))

;; (add-hook 'after-init-hook 'org-agenda-list)

(use-package plain-org-wiki
  :ensure t)


(cond ((eq system-type 'windows-nt)
       ;; Windows-specific code goes here.
       (setq plain-org-wiki-directory "C:\\Users\\arvga\\.arvydas\\org\\pkc_notes")
       ;; (setq plain-org-wiki-directory "C:\\Users\\arvga\\Dropbox\\org\\notes\\personal_notes")
       ;; (setq plain-org-wiki-extra-files (directory-files-recursively "C:\\Users\\arvga\\Dropbox\\org\\notes\\pkc_notes" "\.org$"))
       )
      ((eq system-type 'gnu/linux)
       ;; Linux-specific code goes here.
       (setq plain-org-wiki-directory "~/Dropbox/org/")
       ;; (setq plain-org-wiki-extra-files (directory-files-recursively "~/Dropbox/org/notes/" "\.org$"))
       ))

;; WSL-specific setup
(when (and (eq system-type 'gnu/linux)
           (getenv "WSLENV"))
  (setq plain-org-wiki-directory "/mnt/c/Users/arvga/stuff/org/")
  )


(global-set-key (kbd "C-c n f") 'plain-org-wiki)

(use-package move-text
  :ensure t
  :config
  (move-text-default-bindings))

(use-package yasnippet
  :ensure t
  :config
  (yas-global-mode 1))

(cond ((eq system-type 'windows-nt)
       ;; Windows-specific code goes here.
       (setq yas-snippet-dirs '("c:\\Users\\arvga\\.arvydas\\src\\emacs\\snippets"))
       )
      ((eq system-type 'gnu/linux)
       ;; Linux-specific code goes here.
       (setq yas-snippet-dirs '("~/.emacs.d/snippets/"))
       ))

(use-package yasnippet-snippets
  :disabled t)

(use-package counsel
  :ensure t
  :after ivy
  :config (counsel-mode))

(use-package expand-region
  :ensure t
  :bind ("C-=" . er/expand-region)
  :config)

(use-package hungry-delete
  :ensure t
  :config
  (global-hungry-delete-mode))

;; (use-package ws-butler
;;   :ensure nil
;;   :config
;;   (ws-butler-global-mode t))

(use-package flycheck
  :ensure t
  :defer t
  :hook
  (python-mode           . flycheck-mode)
  (js-mode               . flycheck-mode)
  (web-mode              . flycheck-mode)
  (lisp-interaction-mode . flycheck-mode)
  (emacs-lisp-mode       . flycheck-mode)
  (markdown-mode         . flycheck-mode)
  :bind ("C-c e" . flycheck-next-error)
)

(add-hook 'text-mode-hook 'flyspell-mode)
(add-hook 'org-mode-hook 'flyspell-mode)
(add-hook 'prog-mode-hook 'flyspell-prog-mode)

;; (global-set-key (kbd "C-1") 'flyspell-auto-correct-previous-word)
;; (global-set-key (kbd "C-2") 'flyspell-auto-correct-word)
;; (global-set-key (kbd "C-3") 'flyspell-goto-next-error)
;; (global-set-key (kbd "C-4") 'flyspell-buffer)

(global-set-key (kbd "<f5>") 'flyspell-mode)

;; <2022-03-20 Sk> removing C-M-i "auto-correct word" because it
;; wouldn't let me to bind org-roam "insert link automatically
;; thingy". Now, as I unbind it (it's not gone, I can still auto
;; correct words with C-.m) I can use C-M-i to org-roam insert link. I
;; am tired, right, repeating myself. Going to sleep. Glad org-roam
;; works and I am finding solutions to make it work according to this
;; https://www.youtube.com/watch?v=AyhPmypHDEw tutorial.

;; (with-eval-after-load "flyspell"
;;   (define-key flyspell-mode-map (kbd "C-M-i") nil))

;; (use-package lorem-ipsum
;;   :ensure nil
;;   :defer t
;;   )

(use-package multiple-cursors
  :ensure t
  :commands multiple-cursors
  :bind (("C->" . mc/mark-next-like-this)
         ("C-<" . mc/unmark-next-like-this)
         ("C-c C-<" . mc/mark-all-like-this)))
(global-set-key (kbd "C->") 'mc/mark-next-like-this)
(global-set-key (kbd "C-<") 'mc/mark-previous-like-this)
(global-set-key (kbd "C-c C-<") 'mc/mark-all-like-this)

(use-package prettier-js
  :ensure t
  :hook (((js2-mode rjsx-mode) . prettier-js-mode)))

(add-hook 'css-mode-hook 'prettier-js-mode)
;; turning off web mode hook, messes up django development
;; (add-hook 'web-mode-hook 'prettier-js-mode)

(use-package lsp-mode
  :ensure t
  ;; :commands (lsp lsp-deferred)          ;both of these commands activate the package. interesting
  :init
  (setq lsp-keymap-prefix "C-c l")      ; Or 'C-l', 's-l'
  :config
  (lsp-enable-which-key-integration t))

;; (add-hook 'prog-mode-hook #'lsp)        ; not reccomended, tries to run in elisp mode..
(add-hook 'web-mode-hook #'lsp)
(add-hook 'python-mode-hook #'lsp)      ;https://vxlabs.com/2018/06/08/python-language-server-with-emacs-and-lsp-mode/
;; (add-hook 'css-mode-hook #'lsp)
(add-hook 'js-mode-hook #'lsp)


;; lsp-ui-workspace-symbol - nusoks i definition - cool
(use-package lsp-ivy
  :ensure t)

;; good for stuff like C-c l G r
(use-package lsp-ui
  :ensure t
  :hook (lsp-mode . lsp-ui-mode))

;; (use-package lsp-treemacs
;;   :ensure t)

;; see errors
;; M-x lsp-treemacs-errors-list
;; M-x lsp-errors-list-mode

;; lsp-treemacs-symbols
;; lsp-treemacs-references/impleentations

;; A guide on disabling/enabling lsp-mode features
;; https://emacs-lsp.github.io/lsp-mode/tutorials/how-to-turn-off/

;; attempting to make lsp quicker
;; https://emacs-lsp.github.io/lsp-mode/page/performance/

;; do M-x lsp-diagnose ir check ar yra errors

(setq lsp-lens-enable t)

;; attempting to make lsp faster (M-x lsp-doctor)
;; check emacs version - apt-cache policy emacs
(setq read-process-output-max (* 1024 1024)) ;; 1mb
(setq gc-cons-threshold 100000000)
(setq lsp-idle-delay 0.500)
;; install emacs 28.. is kind of faster now https://www.how2shout.com/linux/how-to-install-emacs-28-on-ubuntu-20-04-lts-focal-fossa/
;; proper lsp install here - https://emacs-lsp.github.io/lsp-mode/page/
;; (setenv "LSP_USE_PLISTS" "1") ;; add this line to init.el only

(org-babel-do-load-languages
 'org-babel-load-languages (quote ((emacs-lisp . t)
                                    (sqlite . t)
                                    (R . t)
                                    (python . t))))

;; black is a code formatter according to some standards. Without it I
;; am getting various errors about "two lines after that", "too many
;; spaces there.. now it simply reformats my code according those
;; standards of BLACK

;; Run black on save
(add-hook 'elpy-mode-hook (lambda ()
                            (add-hook 'before-save-hook 'elpy-black-fix-code nil t)))

;; IF you can not import modules, says it can not find or w/elfeed
;; do M-x run-python in DIRED, the location of the files.
;; then do C-c C-c or C-RET - the modules will load
;; two hours wasted during my codeacademy first python test... but thanks to this guy:
;; https://emacs.stackexchange.com/questions/43950/modulenotfound-for-absolute-imports-in-emacs-python-repl/74881#74881

;; shortcuts
;; c-c c-d - pydoc on a method

(use-package yaml-mode
  :ensure t)

(use-package dockerfile-mode
  :ensure t)

(use-package elpy
  :ensure t
  :custom (elpy-rpc-backend "jedi")
  :init
  (elpy-enable))
;; :bind (("M-." . elpy-goto-definition)))
(setq elpy-rpc-virtualenv-path 'current)
(set-language-environment "UTF-8")

;; can not find module named... in elpy shell
;; https://emacs.stackexchange.com/questions/50905/wrong-cwd-in-python-mode
'(elpy-shell-starting-directory (quote current-directory))

(setq elpy-rpc-python-command "python3")
(setq python-shell-interpreter "python3")
(setq elpy-get-info-from-shell t)

;; <2022-03-18 Pn> Turned it off, doesn't look nice
(add-hook 'elpy-mode-hook (lambda () (highlight-indentation-mode -1)))

;; tired of "Can't guess python-indent-offset, using defaults 4" message
;; https://stackoverflow.com/questions/18778894/emacs-24-3-python-cant-guess-python-indent-offset-using-defaults-4
(setq python-indent-guess-indent-offset-verbose nil)

(use-package emmet-mode
  :ensure t
  :config
  :hook ((web-mode . emmet-mode)
         (html-mode . emmet-mode)
         ;; turning off dell scss C-c C-c shortcut
         ;; (css-mode . emmet-mode)
         (sgml-mode . emmet-mode)))

(use-package impatient-mode
  :ensure t
  :commands impatient-mode)

;; to be able to preview .md files
;; from here - https://stackoverflow.com/questions/36183071/how-can-i-preview-markdown-in-emacs-in-real-time
;; But Wait... with markdown-mode installed I can already see the markdown live in my emacs...
(defun markdown-html (buffer)
  (princ (with-current-buffer buffer
           (format "<!DOCTYPE html><html><title>Impatient Markdown</title><xmp theme=\"united\" style=\"display:none;\"> %s  </xmp><script src=\"http://strapdownjs.com/v/0.2/strapdown.js\"></script></html>" (buffer-substring-no-properties (point-min) (point-max))))
         (current-buffer)))

;; (use-package js2-mode
;;   :ensure nil
;;   :init
;;   (setq js-basic-indent 2)
;;   (setq-default js2-basic-indent 2
;;                 ;; js2-basic-offset 2
;;                 js2-auto-indent-p t
;;                 js2-cleanup-whitespace t
;;                 js2-enter-indents-newline t
;;                 js2-indent-on-enter-key t
;;                 js2-strict-missing-semi-warning nil ;remove the damn warning after every line whit no semicolon
;;                 js2-global-externs (list "window" "module" "require" "buster" "sinon" "assert" "refute" "setTimeout" "clearTimeout" "setInterval" "clearInterval" "location" "__dirname" "console" "JSON" "jQuery" "$"))

;;   (add-hook 'js2-mode-hook
;;             (lambda ()
;;               (push '("function" . ?ƒ) prettify-symbols-alist)))

;;   (add-to-list 'auto-mode-alist '("\\.js$" . js2-mode)))

;; (add-hook 'js2-mode-hook
;;           (lambda () (flycheck-select-checker "javascript-eslint")))

;; (with-eval-after-load 'js2-mode
;;   ;; disabling the hotkeys to hide things
;;   (define-key js2-mode-map (kbd "C-c C-e") nil)
;;   (define-key js2-mode-map (kbd "C-c C-s") nil)
;;   (define-key js2-mode-map (kbd "C-c C-f") nil)
;;   (define-key js2-mode-map (kbd "C-c C-t") nil)
;;   (define-key js2-mode-map (kbd "C-c C-o") nil)
;;   (define-key js2-mode-map (kbd "C-c C-w") nil))

;; (use-package js-comint
;;   :ensure nil
;;   )

;; (defun inferior-js-mode-hook-setup ()
;;   (add-hook 'comint-output-filter-functions 'js-comint-process-output))
;; (add-hook 'inferior-js-mode-hook 'inferior-js-mode-hook-setup t)

;; (define-key js-mode-map (kbd "C-c b") 'my-js-clear-send-buffer)

;; (defun my-js-clear-send-buffer ()
;;   (interactive)
;;   (js-comint-clear)
;;   (js-comint-send-buffer))

;; (use-package rjsx-mode
;;   ;; Real support for JSX
;;   :ensure nil
;;   )

;; (add-to-list 'auto-mode-alist '("\\.js\\'" . rjsx-mode))

;; (use-package tern
;;    :ensure nil
;;    :init (add-hook 'js2-mode-hook (lambda () (tern-mode t))))

;; (use-package skewer-mode
;;   :ensure nil
;;   :commands skewer-mode run-skewer
;;   :config (skewer-setup))

;; (add-hook 'js2-mode-hook 'skewer-mode)
;; (add-hook 'css-mode-hook 'skewer-css-mode)
;; (add-hook 'web-mode-hook 'skewer-html-mode)

(use-package json-mode
  ;; :ensure t
  :config
  :mode ("\\.json"))

;;; markdown-mode.el --- hoping to get some markdown syntax help
;;; Commentary:
;; primarily for hugo
;;; Code:

(use-package markdown-mode
  :ensure t)

;; preview markdown live
;; https://stackoverflow.com/questions/36183071/how-can-i-preview-markdown-in-emacs-in-real-time
;; https://wikemacs.org/wiki/Markdown#Live_preview_as_you_type
;; M-x httpd-start
;; M-x impatient-mode
;; Open your browser to localhost:8080/imp
;; Tell impatient mode to use it: M-x imp-set-user-filter RET markdown-html RET

(defun markdown-filter (buffer)
  (princ
   (with-temp-buffer
     (let ((tmpname (buffer-name)))
       (set-buffer buffer)
       (set-buffer (markdown tmpname)) ; the function markdown is in `markdown-mode.el'
       (buffer-string)))
   (current-buffer)))

(defun markdown-html (buffer)
  (princ (with-current-buffer buffer
           (format "<!DOCTYPE html><html><title>Impatient Markdown</title><xmp theme=\"united\" style=\"display:none;\"> %s  </xmp><script src=\"http://ndossougbe.github.io/strapdown/dist/strapdown.js\"></script></html>" (buffer-substring-no-properties (point-min) (point-max))))
         (current-buffer)))

(use-package powershell
  :ensure t)

;; (use-package scss-mode
;;   :ensure nil
;;   :config
;;   (setq scss-compile-at-save t))

(use-package web-mode
  :ensure t
  :commands (web-mode)
  :mode (("\\.html" . web-mode)
         ("\\.htm" . web-mode)
         ("\\.sgml\\'" . web-mode))
  :config
  (setq web-mode-engines-alist
        '(("django"    . "\\.html\\'")))
  (setq web-mode-ac-sources-alist
        '(("css" . (ac-source-css-property))
          ("html" . (ac-source-words-in-buffer ac-source-abbrev))))
  (setq web-mode-enable-auto-closing t))
(setq web-mode-enable-auto-quoting t) ; this fixes the quote problem I mentioned
(setq web-mode-enable-current-element-highlight t)

(add-hook 'web-mode 'emmet-mode)

(use-package vterm
  :ensure t)

(use-package shell-pop
  :ensure t
  :bind (("C-2" . shell-pop))
  :config
  (setq shell-pop-full-span t))         ;basically shell window is fullwidht instead of current buffer size(when split)

;; c-u 2 binding - to launch multiple shell buffers, but then how to close each? :p

(use-package exec-path-from-shell
  :ensure t)

(when (memq window-system '(mac ns x))
  (exec-path-from-shell-initialize))

(use-package diff-hl
  :ensure t
  :config
  (add-hook 'emacs-lisp-mode #'diff-hl-mode)
  (add-hook 'prog-mode-hook #'diff-hl-mode)
  (add-hook 'org-mode-hook #'diff-hl-mode)
  (add-hook 'dired-mode-hook 'diff-hl-dired-mode)
  (add-hook 'magit-post-refresh-hook 'diff-hl-magit-post-refresh)
  (add-hook 'magit-pre-refresh-hook 'diff-hl-magit-post-refresh)
  (add-hook 'prog-mode-hook #'diff-hl-margin-mode)
  (add-hook 'org-mode-hook #'diff-hl-margin-mode)
  (add-hook 'dired-mode-hook 'diff-hl-margin-mode))

(use-package magit
  :ensure t
  :bind (("C-x g" . magit-status)
         ("C-x C-g" . magit-status)))

;; Easily jump to my package files in dired
(defun aga-find-packages nil
  "Find the myinit.org file."
  (interactive)

  (cond ((eq system-type 'windows-nt)
         ;; Windows-specific code goes here.
         (dired "C:\\Users\\arvga\\.arvydas\\src\\emacs\\recipes\\")
         )
        ((eq system-type 'gnu/linux)
         ;; Linux-specific code goes here.
         (dired "~/.emacs.d")
         )))

;; (delete-other-windows))
;; Find myinit.org  file
;; (global-set-key (kbd "C-x <C-backspace>") 'aga-find-packages)
(global-set-key (kbd "C-x <C-home>") 'aga-find-packages)

;; Easily jump to my yasnippet snippet directory in dired
(defun aga-find-snippets nil
  "Find the myinit.org file."
  (interactive)

  (cond ((eq system-type 'windows-nt)
         ;; Windows-specific code goes here.
         (dired "C:\\Users\\arvga\\.arvydas\\src\\emacs\\snippets\\")
         )
        ((eq system-type 'gnu/linux)
         ;; Linux-specific code goes here.
         (dired "~/.emacs.d/snippets/")
         )))

;prior is PgUp
(global-set-key (kbd "C-x <C-prior>") 'aga-find-snippets)

;; jump to my main init.el file
(defun aga-find-init.el nil
  (interactive)

  (cond ((eq system-type 'windows-nt)
         ;; Windows-specific code goes here.
         (find-file "C:\\Users\\arvga\\.arvydas\\src\\emacs\\init.el")
         )
        ((eq system-type 'gnu/linux)
         ;; Linux-specific code goes here.
         (find-file "~/.emacs.d/my-init.org")
         )))


;; (delete-other-windows))
;; Find init.el file
;; (global-set-key (kbd "C-x <C-home>") 'aga-find-init.el)
(global-set-key (kbd "C-x <C-backspace>") 'aga-find-init.el)

;; jump to my a random js test file
(defun aga-jump-test.js nil
  (interactive)

  (cond ((eq system-type 'windows-nt)
         ;; Windows-specific code goes here.
         (find-file "C:\\Temp\\test.js")
         )
        ((eq system-type 'gnu/linux)
         ;; Linux-specific code goes here.
         (find-file "~/temp/js/test.js")
         ))
  (erase-buffer))
;; (delete-other-windows))
;; Find test.js file
(global-set-key (kbd "C-x j") 'aga-jump-test.js)

;;--------------------------------------------------------

;; jump to my org blog directory
(defun aga-jump-blog-org nil
  (interactive)

  (cond ((eq system-type 'windows-nt)
         ;; Windows-specific code goes here.
         ;; (find-file "C:\\Temp\\test.js")
         )
        ((eq system-type 'gnu/linux)
         ;; Linux-specific code goes here.
         (find-file "~/Dropbox/arvydasg.github.io_blog_content/")
         ))
  (erase-buffer))

;; (delete-other-windows))
;; Find test.js file
(global-set-key (kbd "C-x C-<end>") 'aga-jump-blog-org)

;; jump to my org blog directory
(defun aga-jump-blog-html nil
  (interactive)

  (cond ((eq system-type 'windows-nt)
         ;; Windows-specific code goes here.
         ;; (find-file "C:\\Temp\\test.js")
         )
        ((eq system-type 'gnu/linux)
         ;; Linux-specific code goes here.
         (find-file "~/Dropbox/src/arvydasg.github.io/")
         ))
  (erase-buffer))

;; (delete-other-windows))
;; Find test.js file
(global-set-key (kbd "C-x C-<next>") 'aga-jump-blog-html)

(use-package rg
  :ensure t
  :commands rg)

(use-package avy
  :ensure t
  :bind
  (("M-s" . avy-goto-char-timer)
   ("M-p" . avy-goto-word-1)))

;; make the background darker
(setq avy-background t)

(use-package ace-window
  :ensure t
  :init (setq aw-keys '(?q ?w ?e ?r ?y ?h ?j ?k ?l)
                                        ;aw-ignore-current t ; not good to turn off since I wont be able to do c-o o <current>
              aw-dispatch-always nil)     ;t means it applies a letter even if there are only two windows. not needed.
  :bind (("C-x o" . ace-window)
         ("M-O" . ace-swap-window)
         ("C-x v" . aw-split-window-horz)))
(defvar aw-dispatch-alist
  '((?x aw-delete-window "Delete Window")
    (?m aw-swap-window "Swap Windows")
    (?M aw-move-window "Move Window")
    (?c aw-copy-window "Copy Window")
    (?f aw-switch-buffer-in-window "Select Buffer")
    (?n aw-flip-window)
    (?u aw-switch-buffer-other-window "Switch Buffer Other Window")
    (?c aw-split-window-fair "Split Fair Window")
    (?h aw-split-window-vert "Split Vert Window")
    (?v aw-split-window-horz "Split Horz Window")
    (?o delete-other-windows)
    ;; (?o delete-other-windows "Delete Other Windows")
    ;; (?o delete-other-windows " Ace - Maximize Window")
    (?? aw-show-dispatch-help))
  "List of actions for `aw-dispatch-default'.")

(use-package ivy
  :defer 0.1
  :diminish
  :bind (("C-c C-r" . ivy-resume)
         ("C-x B" . ivy-switch-buffer-other-window)) ; I never use this
  :custom
  (ivy-count-format "(%d/%d) ")
  ;; nice if you want previously opened buffers to appear after an
  ;; emacs shutdown
  (ivy-use-virtual-buffers t)           ;saves buffers from last session
  :config (ivy-mode))

(use-package ivy-rich
  :after ivy
  :ensure t
  :init (ivy-rich-mode 1))

(use-package all-the-icons-ivy-rich
  :ensure t
  :init (all-the-icons-ivy-rich-mode 1))

(use-package swiper
  :after ivy
  :bind (("C-s" . swiper)
         ("C-r" . swiper)))

(use-package projectile
  :ensure t
  ;; :bind (("C-c p" . projectile-command-map)) ;trying to load this after the command gets invoked the first time, but for some reasons it works only I press it the second time
  :bind-keymap
  ("C-c p" . projectile-command-map)

  :config
  (projectile-global-mode)
  (setq projectile-completion-system 'ivy)
  (setq projectile-sort-order 'recently-active)
  (setq projectile-project-search-path '("~/Dropbox/src/")))

(use-package goto-chg
  :ensure t)
(global-set-key (kbd "M-[") 'goto-last-change)
(global-set-key (kbd "M-]") 'goto-last-change-reverse)

;; (use-package evil
;;   :ensure nil
;;   :init (setq evil-want-C-i-jump nil) ;; allows to use TAB in org mode
;;   :config
;;   (evil-mode 1)
;;   (define-key evil-insert-state-map (kbd "C-g") 'evil-normal-state)
;;   ;;Not sure why this isn’t the default – it is in vim – but this makes C-u to go up half a page
;;   (define-key evil-normal-state-map (kbd "C-u") 'evil-scroll-up)
;;   ;; jump to any char with space only
;;   (define-key evil-normal-state-map (kbd "SPC") 'avy-goto-char-timer)
;;   ;; can not quit windows with evil mode.. now I can
;;   (define-key evil-normal-state-map (kbd "q") 'quit-window)
;;   ;; forcing myself  to use C-w for evil window management
;;   (global-unset-key (kbd "C-x o")))


;; ;; change cursor to indicate different modes of VIM
;; (setq evil-default-cursor (quote (t "#750000"))
;;       evil-visual-state-cursor '("green" hollow)
;;       evil-normal-state-cursor '("green" box)
;;       evil-insert-state-cursor '("pink" (bar . 2)))

;; ;; (use-package evil
;; ;;   :ensure t
;; ;;   :config
;; ;;   (evil-mode 1))

;; (use-package treemacs
;;   :ensure t
;;   :config
;;     ;; Don't follow the cursor
;;   (treemacs-follow-mode -1)
;;   (treemacs-git-mode 'deferred)
;;   :bind
;;   ("C-`" . treemacs-select-window)
;;   )

;; all the treemacs configuration options and their defaults

(use-package treemacs
  :ensure t
  :defer t
  :init
  (with-eval-after-load 'winum
    (define-key winum-keymap (kbd "M-0") #'treemacs-select-window))
  :config
  (progn
    (setq treemacs-collapse-dirs                   (if treemacs-python-executable 3 0)
          treemacs-deferred-git-apply-delay        0.5
          treemacs-directory-name-transformer      #'identity
          treemacs-display-in-side-window          t
          treemacs-eldoc-display                   'simple
          treemacs-file-event-delay                2000
          treemacs-file-extension-regex            treemacs-last-period-regex-value
          treemacs-file-follow-delay               0.2
          treemacs-file-name-transformer           #'identity
          treemacs-follow-after-init               t
          treemacs-expand-after-init               t
          treemacs-find-workspace-method           'find-for-file-or-pick-first
          treemacs-git-command-pipe                ""
          treemacs-goto-tag-strategy               'refetch-index
          treemacs-header-scroll-indicators        '(nil . "^^^^^^")
          treemacs-hide-dot-git-directory          t
          treemacs-indentation                     2
          treemacs-indentation-string              " "
          treemacs-is-never-other-window           nil
          treemacs-max-git-entries                 5000
          treemacs-missing-project-action          'ask
          treemacs-move-forward-on-expand          nil
          treemacs-no-png-images                   nil
          treemacs-no-delete-other-windows         t
          treemacs-project-follow-cleanup          nil
          treemacs-persist-file                    (expand-file-name ".cache/treemacs-persist" user-emacs-directory)
          treemacs-position                        'left
          treemacs-read-string-input               'from-child-frame
          treemacs-recenter-distance               0.1
          treemacs-recenter-after-file-follow      nil
          treemacs-recenter-after-tag-follow       nil
          treemacs-recenter-after-project-jump     'always
          treemacs-recenter-after-project-expand   'on-distance
          treemacs-litter-directories              '("/node_modules" "/.venv" "/.cask")
          treemacs-project-follow-into-home        nil
          treemacs-show-cursor                     nil
          treemacs-show-hidden-files               t
          treemacs-silent-filewatch                nil
          treemacs-silent-refresh                  nil
          treemacs-sorting                         'alphabetic-asc
          treemacs-select-when-already-in-treemacs 'move-back
          treemacs-space-between-root-nodes        t
          treemacs-tag-follow-cleanup              t
          treemacs-tag-follow-delay                1.5
          treemacs-text-scale                      nil
          treemacs-user-mode-line-format           nil
          treemacs-user-header-line-format         nil
          treemacs-wide-toggle-width               70
          treemacs-width                           35
          treemacs-width-increment                 1
          treemacs-width-is-initially-locked       t
          treemacs-workspace-switch-cleanup        nil)

    ;; The default width and height of the icons is 22 pixels. If you are
    ;; using a Hi-DPI display, uncomment this to double the icon size.
    ;;(treemacs-resize-icons 44)

    (treemacs-follow-mode -1)
    (treemacs-filewatch-mode t)
    (treemacs-fringe-indicator-mode 'always)
    (when treemacs-python-executable
      (treemacs-git-commit-diff-mode t))

    (pcase (cons (not (null (executable-find "git")))
                 (not (null treemacs-python-executable)))
      (`(t . t)
       (treemacs-git-mode 'deferred))
      (`(t . _)
       (treemacs-git-mode 'simple)))

    (treemacs-hide-gitignored-files-mode nil))
  :bind
  (:map global-map
        ("C-`"       . treemacs-select-window)
        ("C-x t 1"   . treemacs-delete-other-windows)
        ("C-x t t"   . treemacs)
        ("C-x t d"   . treemacs-select-directory)
        ("C-x t B"   . treemacs-bookmark)
        ("C-x t C-t" . treemacs-find-file)
        ("C-x t M-t" . treemacs-find-tag)))

;; (use-package treemacs-evil
;;   :after (treemacs evil)
;;   :ensure t)

;; (use-package treemacs-projectile
;;   :after (treemacs projectile)
;;   :ensure t)

;; (use-package treemacs-icons-dired
;;   :hook (dired-mode . treemacs-icons-dired-enable-once)
;;   :ensure t)

;; (use-package treemacs-magit
;;   :after (treemacs magit)
;;   :ensure t)

;; (use-package treemacs-persp ;;treemacs-perspective if you use perspective.el vs. persp-mode
;;   :after (treemacs persp-mode) ;;or perspective vs. persp-mode
;;   :ensure t
;;   :config (treemacs-set-scope-type 'Perspectives))

;; (use-package treemacs-tab-bar ;;treemacs-tab-bar if you use tab-bar-mode
;;   :after (treemacs)
;;   :ensure t
;;   :config (treemacs-set-scope-type 'Tabs))

;; jump to treemacs window with ace mode
;; didn't manage this to work, need to  do "after" somehow
;; https://github.com/doomemacs/doomemacs/issues/1177
;; (setq aw-ignored-buffers (delq 'treemacs-mode aw-ignored-buffers))

(use-package dired
  :ensure nil                         ;no need for t, because dired is built in
  :custom ((dired-listing-switches "-agho --group-directories-first"))) ;sort directories first
(global-set-key (kbd "C-x C-d") 'dired-jump) ;open dired buffer in current location
(define-key dired-mode-map (kbd "f") 'dired-find-alternate-file)
;; (global-set-key (kbd "C-x d") 'dired)

;; [2022-03-11 Pn] Adding more colors to dired buffers
;; 22-05-19 isjungiau spalvas - maziau lago
;; (use-package diredfl
;;   :ensure t
;;   :after (dired)
;;   :config
;;   (diredfl-global-mode 1))

;; [2022-03-11 Pn] [[https://github.com/clemera/dired-git-info][dired-git-info]]. This Emacs packages provides a minor mode which shows
;; git information inside the dired buffer.

(use-package dired-git-info
  :ensure t
  :after dired)

;; Bind the minor mode command in dired

;; (with-eval-after-load 'dired
;;   (define-key dired-mode-map ")" 'dired-git-info-mode))

;; Don’t hide normal Dired file info

;; (setq dgi-auto-hide-details-p nil)

;; Enable automatically in every Dired buffer (if in Git repository)
;; (add-hook 'dired-after-readin-hook 'dired-git-info-auto-enable)

(use-package company
  :after lsp-mode
  :config
  (setq company-idle-delay 0) ; lb svarbu, instant suggestion
  ;; (setq company-show-numbers t)
  (setq company-tooltip-limit 10)
  (setq company-minimum-prefix-length 1)
  (setq company-tooltip-align-annotations t)
  (setq company-tooltip-flip-when-above nil) ; flip when narrow place
  (global-company-mode))

;turn off company auto-completion in eshell, because it adds annoying spaces after each completion.. like ls, sucks
(add-hook 'eshell-mode-hook (lambda () (company-mode -1)) 'append)

;; turn off company mode in org major mode. Annoying suggestions with each word.
(defun jpk/org-mode-hook ()
  (company-mode -1))
(add-hook 'org-mode-hook #'jpk/org-mode-hook)

;; makes lsp crash - https://github.com/emacs-lsp/lsp-mode/discussions/3781#discussioncomment-3992134
;; (use-package company-quickhelp
;;   :ensure t
;;   :config
;;   (company-quickhelp-mode 1)
;;   (eval-after-load 'company
;;     '(define-key company-active-map (kbd "C-c h") #'company-quickhelp-manual-begin)))
;; (setq company-quickhelp-delay 0)

(use-package undo-tree
  :ensure t
  :init
  (global-undo-tree-mode))
(setq undo-tree-auto-save-history nil)

;; (use-package elfeed
;;   :ensure nil
;;   :commands elfeed)

;; (setq elfeed-feeds
;;       '("http://nullprogram.com/feed/"
;;         "https://lukesmith.xyz/rss.xml"
;;         "https://planet.emacslife.com/atom.xml"))

;; (use-package erc
;;   :ensure nil
;;   :commands (erc erc-tls)
;;   :config
;;   (setq erc-log-channels-directory "~/Dropbox/src/emacs/erc")
;;   (setq erc-save-buffer-on-part t)
;;   (add-to-list 'erc-modules 'autojoin)
;;   (add-to-list 'erc-modules 'log)
;;   (erc-update-modules)
;;   (setq erc-kill-buffer-on-part t)
;;   (setq erc-track-shorten-start 8))

;; (setq erc-server "irc.libera.chat"
;;       erc-nick "Arvydas"
;;       ;; erc-user-full-name "Emacs User"
;;       erc-autojoin-channels-alist '(("libera.chat" "#systemcrafters" "#emacs")))

;; (setq erc-track-exclude-types '("NICK" "JOIN" "LEAVE" "QUIT" "PART"
;;                                 "301"   ; away notice
;;                                 "305"   ; return from awayness
;;                                 "306"   ; set awayness
;;                                 "324"   ; modes
;;                                 "329"   ; channel creation date
;;                                 "332"   ; topic notice
;;                                 "333"   ; who set the topic
;;                                 "353"   ; Names notice
;;                                 ))

;; [2022-03-12 Št] 5 min tasks taken from all my agenda files.
;; First open agenda, then list all the tasks, then click f9, then choose 5min.
(fset '5minTasks
      (lambda (&optional arg) "Keyboard macro." (interactive "p") (kmacro-exec-ring-item (quote ([3 97 116 f9 61 50] 0 "%d")) arg)))

;;; ---------------------------------------

;; [2022-03-17 Kt] Macro for adding code block called hack
;; [2022-03-29 An] Or add [[https://orgmode.org/manual/Structure-Templates.html][(require 'org-tempo)]] for <s to work again.
;; [2022-04-04 Mon] Removed this macro, next time make one that leaves
;; cursor on language input

;; [2022-03-19 Št] Open nautilus
(fset 'nautilus
      [?\M-! ?n ?a ?u ?t ?i ?l ?u ?s return])
(global-set-key [f1] 'nautilus)

;; [2022-03-19 Št] Open nautilus current buffer
(fset 'nautilus_current
      [?\M-! ?n ?a ?u ?t ?i ?l ?u ?s ?  ?. return])
(global-set-key [f2] 'nautilus_current)

;;; ---------------------------------------

;; [2022-03-27 Sk] Duplicate a task. If I try to auto copy habit to daily
;; file, it gets duplicated with all the clocked times. That's not so
;; good.. to everyday get all the previous clocked times added up. It
;; results in inaccurate data.

;; What I will do here is copy the task, then clock in on it. Easy. The
;; poriginal task (so it wouldn't show in agenda view anymore and would be
;; marked as done), I will mark as "repeating" and I will not include
;; 'repeating' tasks in 'auto copy tasks to dailies' list. Iz pz.

(fset 'duplicate\ and\ clock_in
      [?\C-c ?\C-t ?r ?\C-  ?\M-x return ?\M-w return ?\C-y ?\C-p ?\C-x ?n ?s tab ?\C-n ?\C-k ?\C-k ?\C-k ?\C-k ?\C-k ?\C-p ?\C-x ?n ?w ?\C-l ?\C-n ?\C-k ?\C-p ?\C-c ?\C-x ?\C-i ?\C-x ?\C-s])