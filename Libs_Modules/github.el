;;; github.el --- Visualize GitHub tickets (illustrates a GNU/Linux mag. French article)             -*- lexical-binding: t; -*-

;; Copyright (C) 2017  Damien Cassou

;; Author: Damien Cassou <damien@cassou.me>

;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <http://www.gnu.org/licenses/>.

;;; Commentary:

;;

;;; Code:

(require 'json)
(require 'map)
(require 'seq)

(pop-to-buffer
 (url-retrieve-synchronously
  "https://api.github.com/repos/NixOS/nixpkgs/issues"))

(defun github-retrieve-issues (owner project)
  "Return GitHub issues from OWNER/PROJECT."
  (let ((url (format "https://api.github.com/repos/%s/%s/issues" owner project)))
    (with-current-buffer (url-retrieve-synchronously url)
      (json-read))))

(github-retrieve-issues "NixOS" "nixpkgs")

(define-derived-mode github-tabulated-mode tabulated-list-mode "GitHub"
  "Displays GitHub issues in a tabulated list."
  (setq tabulated-list-format
        [("Num" 5 t)
         ("Description" 0 t)])
  (setq tabulated-list-sort-key (cons "Num" nil))
  (tabulated-list-init-header))

(defun github-display-issues (issues)
  "Display ISSUES in a table.
ISSUES must be suitable for `tabulated-list-entries'."
  (let ((buffer (get-buffer-create "*Github Issues*")))
    (with-current-buffer buffer
      (setq tabulated-list-entries issues)
      (github-tabulated-mode)
      (tabulated-list-print))
    (pop-to-buffer buffer)))

(github-display-issues '((1 ["1" "An issue"])
                         (2 ["2" "Another one"])))

(setq github-issue (seq-elt (github-retrieve-issues "NixOS" "nixpkgs") 1))

(map-elt github-issue 'title)

(ert-deftest github-convert-issue ()
  (let ((issue '((html_url . "url") (number . 25376) (title . "title") (something . 'else))))
    (should (equal (github-convert-issue issue)
                   (list 25376 (vector "25376" "title"))))))

(defun github-convert-issue (issue)
  "Convert ISSUE to a line for `github-display-issues'.
ISSUE is a map of key/value pairs as returned by `github-retrieve-issues'."
  (let ((number (map-elt issue 'number)))
    (list number
          (vector (int-to-string number)
                  (map-elt issue 'title)))))

(defun github-convert-issues (issues)
  "Convert ISSUES to lines for `github-display-issues'.
ISSUES is a list of maps as returned by `github-retrieve-issues'."
  (seq-map #'github-convert-issue issues))

(defun github-display-project-issues (owner project)
  "Display a tabulated list of issues in OWNER/PROJECT."
  (interactive (list
                (read-from-minibuffer "Owner: ")
                (read-from-minibuffer "Project: ")))
  (github-display-issues
   (github-convert-issues (github-retrieve-issues owner project))))

(github-display-project-issues "NixOS" "nixpkgs")

(define-key-after
  menu-bar-tools-menu
  [github-display-project-issues]
  '("Display GitHub Issues" . github-display-project-issues))

(defun github-convert-issue-number-to-link (issue)
  "Convert ISSUE's number to a link to GitHub's page for ISSUE."
  (list (int-to-string (map-elt issue 'number))
        'action (lambda (_) (browse-url (map-elt issue 'html_url)))))

(defun github-convert-issue (issue)
  "Convert ISSUE to a line for `github-display-issues'.
ISSUE is a map of key/value pairs as returned by `github-retrieve-issues'."
  (let ((number (map-elt issue 'number)))
    (list number
          (vector (github-convert-issue-number-to-link issue)
                  (map-elt issue 'title)))))

(ert-deftest github-convert-issue ()
  (let ((issue '((html_url . "url") (number . 25376) (title . "title") (something . 'else))))
    (pcase (github-convert-issue issue)
      (`(25376 [("25376" action ,_) "title"]) t)
      (_ (ert-fail (github-convert-issue issue))))))

(provide 'github)
;;; github.el ends here
