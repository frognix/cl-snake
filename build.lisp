(in-package :cl-user)
(load "/usr/lib/quicklisp/setup")

(pushnew '*default-pathname-defaults* asdf:*central-registry*)

(ql:quickload :sketch)

(asdf:load-system 'snake)

(defun executable-name ()
    (case (uiop/os:detect-os)
      (:OS-UNIX "snake")
      (:OS-WINDOWS "snake.exe")
      (t (error "Unexpected OS type"))))

(defun additional-args ()
    (case (uiop/os:detect-os)
      (:OS-WINDOWS '(:application-type :gui))
      (t '())))

(defmacro save-executable ()
    `(sb-ext:save-lisp-and-die ,(executable-name)
                               :toplevel #'snake:start-snake
                               :executable t
                               ,@(additional-args)))

(save-executable)
