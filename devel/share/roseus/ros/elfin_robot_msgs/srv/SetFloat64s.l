;; Auto-generated. Do not edit!


(when (boundp 'elfin_robot_msgs::SetFloat64s)
  (if (not (find-package "ELFIN_ROBOT_MSGS"))
    (make-package "ELFIN_ROBOT_MSGS"))
  (shadow 'SetFloat64s (find-package "ELFIN_ROBOT_MSGS")))
(unless (find-package "ELFIN_ROBOT_MSGS::SETFLOAT64S")
  (make-package "ELFIN_ROBOT_MSGS::SETFLOAT64S"))
(unless (find-package "ELFIN_ROBOT_MSGS::SETFLOAT64SREQUEST")
  (make-package "ELFIN_ROBOT_MSGS::SETFLOAT64SREQUEST"))
(unless (find-package "ELFIN_ROBOT_MSGS::SETFLOAT64SRESPONSE")
  (make-package "ELFIN_ROBOT_MSGS::SETFLOAT64SRESPONSE"))

(in-package "ROS")





(defclass elfin_robot_msgs::SetFloat64sRequest
  :super ros::object
  :slots (_data ))

(defmethod elfin_robot_msgs::SetFloat64sRequest
  (:init
   (&key
    ((:data __data) (make-array 0 :initial-element 0.0 :element-type :float))
    )
   (send-super :init)
   (setq _data __data)
   self)
  (:data
   (&optional __data)
   (if __data (setq _data __data)) _data)
  (:serialization-length
   ()
   (+
    ;; float64[] _data
    (* 8    (length _data)) 4
    ))
  (:serialize
   (&optional strm)
   (let ((s (if strm strm
              (make-string-output-stream (send self :serialization-length)))))
     ;; float64[] _data
     (write-long (length _data) s)
     (dotimes (i (length _data))
       (sys::poke (elt _data i) (send s :buffer) (send s :count) :double) (incf (stream-count s) 8)
       )
     ;;
     (if (null strm) (get-output-stream-string s))))
  (:deserialize
   (buf &optional (ptr- 0))
   ;; float64[] _data
   (let (n)
     (setq n (sys::peek buf ptr- :integer)) (incf ptr- 4)
     (setq _data (instantiate float-vector n))
     (dotimes (i n)
     (setf (elt _data i) (sys::peek buf ptr- :double)) (incf ptr- 8)
     ))
   ;;
   self)
  )

(defclass elfin_robot_msgs::SetFloat64sResponse
  :super ros::object
  :slots (_success _message ))

(defmethod elfin_robot_msgs::SetFloat64sResponse
  (:init
   (&key
    ((:success __success) nil)
    ((:message __message) "")
    )
   (send-super :init)
   (setq _success __success)
   (setq _message (string __message))
   self)
  (:success
   (&optional __success)
   (if __success (setq _success __success)) _success)
  (:message
   (&optional __message)
   (if __message (setq _message __message)) _message)
  (:serialization-length
   ()
   (+
    ;; bool _success
    1
    ;; string _message
    4 (length _message)
    ))
  (:serialize
   (&optional strm)
   (let ((s (if strm strm
              (make-string-output-stream (send self :serialization-length)))))
     ;; bool _success
       (if _success (write-byte -1 s) (write-byte 0 s))
     ;; string _message
       (write-long (length _message) s) (princ _message s)
     ;;
     (if (null strm) (get-output-stream-string s))))
  (:deserialize
   (buf &optional (ptr- 0))
   ;; bool _success
     (setq _success (not (= 0 (sys::peek buf ptr- :char)))) (incf ptr- 1)
   ;; string _message
     (let (n) (setq n (sys::peek buf ptr- :integer)) (incf ptr- 4) (setq _message (subseq buf ptr- (+ ptr- n))) (incf ptr- n))
   ;;
   self)
  )

(defclass elfin_robot_msgs::SetFloat64s
  :super ros::object
  :slots ())

(setf (get elfin_robot_msgs::SetFloat64s :md5sum-) "5739026f6f0517440e663ba60441de94")
(setf (get elfin_robot_msgs::SetFloat64s :datatype-) "elfin_robot_msgs/SetFloat64s")
(setf (get elfin_robot_msgs::SetFloat64s :request) elfin_robot_msgs::SetFloat64sRequest)
(setf (get elfin_robot_msgs::SetFloat64s :response) elfin_robot_msgs::SetFloat64sResponse)

(defmethod elfin_robot_msgs::SetFloat64sRequest
  (:response () (instance elfin_robot_msgs::SetFloat64sResponse :init)))

(setf (get elfin_robot_msgs::SetFloat64sRequest :md5sum-) "5739026f6f0517440e663ba60441de94")
(setf (get elfin_robot_msgs::SetFloat64sRequest :datatype-) "elfin_robot_msgs/SetFloat64sRequest")
(setf (get elfin_robot_msgs::SetFloat64sRequest :definition-)
      "float64[] data
---
bool success
string message

")

(setf (get elfin_robot_msgs::SetFloat64sResponse :md5sum-) "5739026f6f0517440e663ba60441de94")
(setf (get elfin_robot_msgs::SetFloat64sResponse :datatype-) "elfin_robot_msgs/SetFloat64sResponse")
(setf (get elfin_robot_msgs::SetFloat64sResponse :definition-)
      "float64[] data
---
bool success
string message

")



(provide :elfin_robot_msgs/SetFloat64s "5739026f6f0517440e663ba60441de94")


