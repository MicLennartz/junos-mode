;;; junos-mode.el --- Major mode for Junos configuration files

;; Copyright (C) 2014  Free Software Foundation, Inc.

;; Author: Vincent Bernat
;; Keywords: extensions

;; This file is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation; either version 2, or (at your option)
;; any later version.

;; This file is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with GNU Emacs; see the file COPYING.  If not, write to
;; the Free Software Foundation, Inc., 59 Temple Place - Suite 330,
;; Boston, MA 02111-1307, USA.

;;; Commentary:

;; Simple mode for Junos-like files

;;; Code:
(unless (fboundp 'setq-local)
  (defmacro setq-local (var val)
    `(set (make-local-variable ',var) ,val)))

(defvar junos-mode-syntax-table
   (let ((st (make-syntax-table)))
     (modify-syntax-entry ?- "w" st)
     (modify-syntax-entry ?+ "w" st)
     (modify-syntax-entry ?_ "w" st)
     (modify-syntax-entry ?. "w" st)
     (modify-syntax-entry ?/ "w 124" st)
     (modify-syntax-entry ?* ". 23b" st)
     (modify-syntax-entry ?\# "<" st)
     (modify-syntax-entry ?\n ">" st)
     (modify-syntax-entry ?\; "." st)
     (modify-syntax-entry ?{ "(" st)
     (modify-syntax-entry ?} ")" st)
     st)
   "Syntax table for `junos-mode'.")

(defvar junos-font-lock-keywords
  '(("^\\s-*\\(\\(inactive\\|active\\|delete\\|replace\\|protect\\|unprotect\\):\\s-+\\)?\\(\\sw+\\)\\s-*\\(\\(\\sw+\\s-+\\)*\\){\\s-*\\(\\s<.*\\)?$"
     (1 'font-lock-keyword-face nil t)
     (3 'font-lock-function-name-face)
     (4 'font-lock-variable-name-face nil t))
    ("^\\s-*\\(\\(inactive\\|active\\|delete\\|replace\\|protect\\|unprotect\\):\\s-+\\)?\\(\\sw+\\)"
     (1 'font-lock-keyword-face nil t)
     (3 'font-lock-type-face))
    ;; Major sections of the configuration
    ("\\b\\(system\\|forwarding-options\\|routing-options\\|routing-instances\\|logical-systems\\|vlans\\|bridge-domains\\|dynamic-profiles\\|interfaces\\|snmp\\|poe\\|ethernet-switching-options\\|security\\|groups\\|policy-options\\|protocols\\|chassis\\|firewall\\|applications\\|multi-chassis\\|redundant-power-system\\|version\\|services\\|virtual-chassis\\|event-options\\|class-of-service\\|access\\|accounting-options\\|diameter\\|fabric\\|multicast-snooping-options\\|switch-options\\|wlan\\|smtp\\|schedulers\\)\\b" . 'font-lock-keyword-face)
    ;; policy reject actions
    ("\\(deny\\|discard\\|reject\\)" . 'custom-invalid)
    ;; policy allow actions
    ("\\(accept\\|permit\\)" . 'custom-state)
    ;; interface names
    ("\\b\\(ge\\|et\\|so\\|fe\\|gr\\|xe\\|lt\\|vt\\si\\|sp\\|st\\|lo\\|me\\|vme\\|ae\\|irb\\)\\([-/\.]*[[:digit:]]+\\)\\{1,4\\}" . 'font-lock-builtin-face)
    ;; descriptions, even without quotes
    ("\\bdescription\s\\([a-zA-Z0-9/<>:_-]+\\)" 1 'font-lock-string-face)
    ;; user specified arbitrary names
    ("\s\\(logical-systems\\|dynamic-profiles\\|jsrc-partition\\|partition\\|filter input\\|filter output\\|access-profile\\|dscp\\|dscp-ipv6\\|exp\\|ieee-802\.1\\|ieee-802\.1ad\\|inet-precedence\\|scheduler-map\\|scheduler-maps\\|input-traffic-control-profile-remaining\\|input-traffic-control-profile\\|traffic-control-profiles\\|output-traffic-control-profile-remaining\\|output-traffic-control-profile\\|output-forwarding-class-map\\|scheduler-map-chassis\\|fragmentation-maps\\|source-prefix-list\\|bridge-domains\\|group\\|mime-pattern\\|url-pattern\\|label-switched-path\\|admin-groups\\|custom-url-category\\|profile\\|url-whitelist\\|url-blacklist\\|ca-profile\\|idp-policy\\|active-policy\\|interface-set\\|interface-range\\|count\\|destination-prefix-list\\|schedulers\\|drop-profiles\\|forwarding-class\\|forwarding-class-map\\|import\\|export\\|instance\\|utm-policy\\|ids-option\\|next-hop-group\\|routing-instances\\|rule\\|rule-set\\|pool\\|class\\|unit\\|port-mirror-instance\\|from-zone\\|to-zone\\|apply-groups\\|file\\|host-name\\|domain-name\\|path\\|domain-search\\|community delete\\|community add\\|community set\\|community\\|trap-group\\|policy\\|policy-statement\\|import-policy\\|instance-export\\|instance-import\\|vrf-import\\|vrf-export\\|import\\|export\\|keep-import\\|inter-area-prefix-import\\|inter-area-prefix-export\\|network-summary-export\\|network-summary-import\\|egress-policy\\|bootstrap-import\\|bootstrap-export\\|filter\\|prefix-list\\|proposal\\|address-set\\|scheduler\\|rib-groups\\|groups\\|security-zone\\|term\\|application\\|application-set\\|vlans\\|gateway\\|user\\|policer\\|lsp\\|condition\\)\s\\([a-zA-Z0-9_-]+\\)" 2 'font-lock-variable-name-face)
    ;; numbers
    ("\s\\([[:digit:]]+\\)\\(\s\\|;\\|$\\)" 1 'font-lock-constant-face)
    ;; Jinja2 fields
    ("{{.+?}}" . 'font-lock-preprocessor-face)
    ;; IP
    ("\\([[:digit:]]+\\.\\)\\{3\\}[[:digit:]]+\\(/[[:digit:]]+\\)?" . 'font-lock-constant-face)
    ("\\(?:\\(?:[[:xdigit:]]+\\)?:\\)+[[:xdigit:]]*\\(/[[:digit:]]+\\)?" . 'font-lock-constant-face))
  "Keyword highlighting specification for `junos-mode'.")

;;;###autoload
(define-derived-mode junos-mode c-mode "Junos"
  "A major mode for editing Junos files."
  :syntax-table junos-mode-syntax-table
  (c-set-offset 'label '+)
  (setq-local comment-start "# ")
  (setq-local comment-end "")
  (setq-local comment-start-skip "#+\\s-*")
  (setq-local font-lock-defaults
              '(junos-font-lock-keywords)))

(provide 'junos-mode)
;;; junos-mode.el ends here
