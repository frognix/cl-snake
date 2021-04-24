(in-package :cl-user)

(pushnew '*default-pathname-defaults* asdf:*central-registry*)

(ql:quickload :sketch)

(asdf:load-system 'snake)

(snake:start-snake)
