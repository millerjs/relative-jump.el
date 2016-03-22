;;; relative-jump.el --- Relative, alphanumertic line jumping

;; Copyright (C) 2016 by Joshua Miller

;; Author: Joshua Miller <jsmiller@uchicago.edu>
;; URL: https://github.com/millerjs/relative-jump
;; Version: 0.01
;; Keywords: linum, relative, jump, navigation
;; Package-Requires: ((dash "2.11.0") (linum-relative "20160117.2200"))

;;; Commentary:

;; Allows the user to jump relative lines using an alphanumeric
;; relative line numbering.
;;
;; Example:
;;
;; With the following bindings
;;
;; (global-set-key (kbd "C-M-n") 'jump-forward)
;; (global-set-key (kbd "C-M-p") 'jump-backward)
;;
;; The keystrokes `C-M-p c RET` will jump forward to line `c`
;; containing `((symbolp x) (symbol-value x)))`.
;;
;; d ›
;; c ›
;; b ›  (cond ((numberp x) x)
;; a ›        ((stringp x) x)
;;   ›        ((bufferp x)
;; a ›         (setq temporary-hack x) ; multiple body-forms
;; b ›         (buffer-name x))        ; in one clause
;; c ›        ((symbolp x) (symbol-value x)))
;; d ›

;;; Code:

(require 'dash)
(require 'linum-relative)

(defgroup relative-jump nil
  "Relative, alphanumeric line jumping."
  :group 'convenience)

;;;; Customize Variables

(defvar relative-jump-last-parsed 0
  "Store the last parsed position.")

(defvar relative-jump-last-line-delta 0
  "Store the last number of lines jumped.")

;;;; Functions

(defun relative-jump-set-line-delta (cmd)
  "Sets the number of lines to jump forward or backward."
  (interactive "srelative line: ")
  (setq relative-jump-last-parsed (s-match "\\([a-z0-9]\\)*" cmd))
  (setq relative-jump-last-line-delta
        (- (aref (-first-item relative-jump-last-parsed) 0) 96))
  (setq relative-jump-last-line-delta
        (+ relative-jump-last-line-delta
           (* (- (max (string-to-number
                       (nth 1 relative-jump-last-parsed)) 1) 1) 26))))

(defun relative-jump-forward (cmd)
  "Jumps forward lines as noted by line numbering. a2 goes forward 27 lines"
  (interactive "srelative line: ")
  (relative-jump-set-line-delta cmd)
  (forward-line relative-jump-last-line-delta))

(defun relative-jump-backward (cmd)
  "Jumps backward lines as noted by line numbering. a2 goes backward 27 lines"
  (interactive "srelative line: ")
  (relative-jump-set-line-delta cmd)
  (forward-line (- relative-jump-last-line-delta)))

(defun linum-relative-alpha-numeric (line-number)
  "Create alpha-numeric line numbering for ergonomic jumping"
  (let* ((diff1 (abs (- line-number linum-relative-last-pos)))
         (diff (if (minusp diff1)
                   diff1
                 (+ diff1 linum-relative-plusp-offset)))
         (current-p (= diff linum-relative-plusp-offset))
         (current-symbol (if (and linum-relative-current-symbol current-p)
                             linum-relative-current-symbol
                           (number-to-string diff)))
         (face (if current-p 'linum-relative-current-face 'linum)))
    (propertize (format linum-relative-format
                        (if (< (string-to-number current-symbol) 131)
                            (substring "  a b c d e f g h i j k l m n o p q r s t u v w x y z a2b2c2d2e2f2g2h2i2j2k2l2m2n2o2p2q2r2s2t2u2v2w2x2y2z2a3b3c3d3e3f3g3h3i3j3k3l3m3n3o3p3q3r3s3t3u3v3w3x3y3z3a4b4c4d4e4f4g4h4i4j4k4l4m4n4o4p4q4r4s4t4u4v4w4x4y4z4a4b4c4d4e4f4g4h4i4j4k4l4m4n4o4p4q4r4s4t4u4v4w4x4y4z4a5b5c5d5e5f5g5h5i5j5k5l5m5n5o5p5q5r5s5t5u5v5w5x5y5z5"
                                       (* 2 (string-to-number current-symbol))
                                       (+ (* 2 (string-to-number current-symbol)) 2)) "-" ))
                'face face)))

(defun linum-relative-toggle ()
  "Toggle between linum formats."
  (interactive)
  (cond ((eq linum-format 'dynamic)
         (setq linum-format 'linum-relative))
        ((eq linum-format 'linum-relative)
         (setq linum-format 'linum-relative-alpha-numeric))
        ((eq linum-format 'linum-relative-alpha-numeric)
         (setq linum-format 'dynamic))))

(setq linum-format 'linum-relative-alpha-numeric)

(provide 'relative-jump)
;;; Relative-jump.el ends here
