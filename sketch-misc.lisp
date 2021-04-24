(defpackage :sketch-misc
  (:use :cl :sketch)
  (:export centered-text make-default-font *default-font*
           *window-width* *window-height*))
(in-package :sketch-misc)

(defconstant +path-to-font+ "/usr/share/fonts/adobe-source-code-pro/SourceCodePro-Regular.otf")
(defparameter *default-font* nil)
(defparameter *window-width* nil)
(defparameter *window-height* nil)

(defun text-size (text)
    (let* ((font (sketch::env-font sketch::*env*))
           (resource (sketch::text-line-image text))
           (spacing (* (sketch::font-size font) (sketch::font-line-height font)))
           (scale (sketch::text-scale (list resource) spacing 1 1)))
        (mapcar (lambda (x) (round (/ 1 x))) scale)))

(defun centered-text (text &key (line 0) (font *default-font*))
    (with-font font
        (let* ((list (text-size text))
               (width (nth 0 list))
               (height (nth 1 list)))
            (text text
                  (/ (- *window-width* width) 2)
                  (+ (/ (- *window-height* height) 2) (* line height))))))

(defun make-default-font (&key color size)
    (make-font :face (make-instance 'sketch::typeface
                                    :filename +path-to-font+
                                    :pointer (sdl2-ttf:open-font +path-to-font+ size))
               :color color
               :size size))
