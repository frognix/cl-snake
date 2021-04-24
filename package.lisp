(defpackage :snake
  (:use :cl :sketch)
  (:export start-snake +default-field+))
(in-package :snake)

(defconstant +window-width+ 756)
(defconstant +window-height+ 756)
(defconstant +cell-count+ 15)
(defconstant +cell-size+ (/ +window-width+ +cell-count+))

(defparameter *current-screen* nil)
(defparameter *window* nil)
