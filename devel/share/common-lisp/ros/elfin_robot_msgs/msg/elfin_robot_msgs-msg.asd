
(cl:in-package :asdf)

(defsystem "elfin_robot_msgs-msg"
  :depends-on (:roslisp-msg-protocol :roslisp-utils )
  :components ((:file "_package")
    (:file "JointsFloat64" :depends-on ("_package_JointsFloat64"))
    (:file "_package_JointsFloat64" :depends-on ("_package"))
  ))