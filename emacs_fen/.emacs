(setq package-archives '(("gnu" . "https://elpa.gnu.org/packages/")
                         ("melpa" . "https://melpa.org/packages/")))
;;config
(setq inhibit-splash-screen   t)
(setq inhibit-startup-message t)
(tool-bar-mode -1)
(menu-bar-mode -1)
(when (fboundp `toggle-scroll-bar) (toggle-scroll-bar -1))

;;Writing how-to instructions in Scratch buffer with all currently used hotkeys
(setq initial-scratch-message "
Hotkeys:
        M-<right> -- next tab              (centaur-tabs)
        M-<left>  -- previous tab          (centaur-tabs) 
        M-x       -- open command buffer   (selectrum)
        C-x C-f   -- find/open file        (selectrum)
        C-x C-s   -- find matching text    (ctrlf)
        C-x t RET -- switch to tab by name (centaur-tabs?)
")

;;disable auto-save feature

;;removes *scratch* buffer after switching to any major mode
;;except treemacs
(defun remove-scratch-buffer ()
  (if (get-buffer "*scratch*")
      (kill-buffer "*scratch*")))
(add-hook 'after-change-major-mode-hook
	  (lambda()
	    (unless (derived-mode-p 'treemacs-mode)
	      (remove-scratch-buffer))))

;;removes *messages* buffer
(setq-default message-log-max nil)
(kill-buffer "*Messages*")

;;make ESC exit prompts
(global-set-key (kbd "<escape>") 'keyboard-escape-quit)

;;centaur-tabs
(use-package centaur-tabs :ensure t :demand :config (centaur-tabs-mode t)
  :bind
  ("<M-left>"  . centaur-tabs-backward)
  ("<M-right>" . centaur-tabs-forward))

(use-package all-the-icons :ensure t)
(use-package treemacs-all-the-icons :ensure t)
(use-package treemacs-projectile :after treemacs projectile :ensure t)
(use-package treemacs-magit :after treemacs magit :ensure t)

;;treemacs
(use-package treemacs :ensure t :defer t :init :config
  (progn
    (setq treemacs-position 'left
	  treemacs-show-hidden-files t
	  treemacs-space-between-root-nodes t
	  treemacs-follow-after-init t
	  treemacs-eldoc-display t
	  treemacs-no-delete-other-windows t
	  treemacs-project-follow-cleanup nil
	  treemacs-width 25))
  (treemacs-follow-mode t)
  (treemacs-filewatch-mode t)
  (treemacs-git-mode 'simple)
  (treemacs-load-theme "all-the-icons")
  (treemacs))
  (add-hook 'treemacs-mode-hook (lambda() (display-line-numbers -1)))

;;doom-themes
(use-package doom-themes :ensure t :config
  (setq doom-themes-enable-bold t
	doom-themes-enable-italic t)
  (load-theme 'doom-flatwhite t)
  (doom-themes-treemacs-config))

;;company addons
(use-package company-c-headers :ensure t)
(use-package company-glsl :ensure t)

;;company
(use-package company
  :hook ('after-init-hook 'global-company-mode)
  :config
  (add-to-list 'company-backends 'company-c-headers)
  (add-to-list 'company-backends 'company-glsl))

;;markdown-mode
(use-package markdown-mode :ensure t
  :mode (("README\\.md\\'" . gfm-mode)
	 ("\\.md\\'" . markdown-mode)
	 ("\\.markdown\\'" . markdown-mode))
  :init (setq markdown-command "multimarkdown"))

;;Adding APKBUILD file extension to sh-mode
(use-package sh-mode
  :mode ("APKBUILD" . sh-mode))

;;file opening/searching in
(use-package selectrum :ensure t :config (selectrum-mode 1))
(use-package ctrlf :ensure t :config (ctrlf-mode 1))

;;flymake - on the fly errors checking/highlighing
(require 'flymake)
(use-package flymake-easy :ensure t)
(use-package flymake-shell :ensure t)

(use-package flymake-cppcheck :ensure t :config (require 'flymake-cppcheck))
(add-hook 'c-mode-hook 'flymake-cppcheck-load)
(add-hook 'c++-mode-hook 'flymake-cppcheck-load)
(remove-hook 'flymake-diagnostic-functions 'flymake-proc-legacy-flymake)
(flymake-mode)
  
;;modern c++ syntax-highlighting
(use-package modern-cpp-font-lock :ensure t :config
  (add-hook 'c++-mode-hook #'modern-c++-font-lock-mode))
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-safe-themes
   '("6c9cbcdfd0e373dc30197c5059f79c25c07035ff5d0cc42aa045614d3919dab4" "4bca89c1004e24981c840d3a32755bf859a6910c65b829d9441814000cf6c3d0" default))
 '(package-selected-packages
   '(flymake-cppcheck flymake-shell writeroom-mode use-package treemacs-projectile treemacs-magit treemacs-all-the-icons smex selectrum monokai-pro-theme modern-cpp-font-lock markdown-mode doom-themes ctrlf cpputils-cmake company-glsl company-c-headers cmake-project cmake-font-lock centaur-tabs)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
