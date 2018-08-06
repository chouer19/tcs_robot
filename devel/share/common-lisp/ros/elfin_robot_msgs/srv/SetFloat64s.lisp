; Auto-generated. Do not edit!


(cl:in-package elfin_robot_msgs-srv)


;//! \htmlinclude SetFloat64s-request.msg.html

(cl:defclass <SetFloat64s-request> (roslisp-msg-protocol:ros-message)
  ((data
    :reader data
    :initarg :data
    :type (cl:vector cl:float)
   :initform (cl:make-array 0 :element-type 'cl:float :initial-element 0.0)))
)

(cl:defclass SetFloat64s-request (<SetFloat64s-request>)
  ())

(cl:defmethod cl:initialize-instance :after ((m <SetFloat64s-request>) cl:&rest args)
  (cl:declare (cl:ignorable args))
  (cl:unless (cl:typep m 'SetFloat64s-request)
    (roslisp-msg-protocol:msg-deprecation-warning "using old message class name elfin_robot_msgs-srv:<SetFloat64s-request> is deprecated: use elfin_robot_msgs-srv:SetFloat64s-request instead.")))

(cl:ensure-generic-function 'data-val :lambda-list '(m))
(cl:defmethod data-val ((m <SetFloat64s-request>))
  (roslisp-msg-protocol:msg-deprecation-warning "Using old-style slot reader elfin_robot_msgs-srv:data-val is deprecated.  Use elfin_robot_msgs-srv:data instead.")
  (data m))
(cl:defmethod roslisp-msg-protocol:serialize ((msg <SetFloat64s-request>) ostream)
  "Serializes a message object of type '<SetFloat64s-request>"
  (cl:let ((__ros_arr_len (cl:length (cl:slot-value msg 'data))))
    (cl:write-byte (cl:ldb (cl:byte 8 0) __ros_arr_len) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 8) __ros_arr_len) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 16) __ros_arr_len) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 24) __ros_arr_len) ostream))
  (cl:map cl:nil #'(cl:lambda (ele) (cl:let ((bits (roslisp-utils:encode-double-float-bits ele)))
    (cl:write-byte (cl:ldb (cl:byte 8 0) bits) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 8) bits) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 16) bits) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 24) bits) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 32) bits) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 40) bits) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 48) bits) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 56) bits) ostream)))
   (cl:slot-value msg 'data))
)
(cl:defmethod roslisp-msg-protocol:deserialize ((msg <SetFloat64s-request>) istream)
  "Deserializes a message object of type '<SetFloat64s-request>"
  (cl:let ((__ros_arr_len 0))
    (cl:setf (cl:ldb (cl:byte 8 0) __ros_arr_len) (cl:read-byte istream))
    (cl:setf (cl:ldb (cl:byte 8 8) __ros_arr_len) (cl:read-byte istream))
    (cl:setf (cl:ldb (cl:byte 8 16) __ros_arr_len) (cl:read-byte istream))
    (cl:setf (cl:ldb (cl:byte 8 24) __ros_arr_len) (cl:read-byte istream))
  (cl:setf (cl:slot-value msg 'data) (cl:make-array __ros_arr_len))
  (cl:let ((vals (cl:slot-value msg 'data)))
    (cl:dotimes (i __ros_arr_len)
    (cl:let ((bits 0))
      (cl:setf (cl:ldb (cl:byte 8 0) bits) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 8) bits) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 16) bits) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 24) bits) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 32) bits) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 40) bits) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 48) bits) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 56) bits) (cl:read-byte istream))
    (cl:setf (cl:aref vals i) (roslisp-utils:decode-double-float-bits bits))))))
  msg
)
(cl:defmethod roslisp-msg-protocol:ros-datatype ((msg (cl:eql '<SetFloat64s-request>)))
  "Returns string type for a service object of type '<SetFloat64s-request>"
  "elfin_robot_msgs/SetFloat64sRequest")
(cl:defmethod roslisp-msg-protocol:ros-datatype ((msg (cl:eql 'SetFloat64s-request)))
  "Returns string type for a service object of type 'SetFloat64s-request"
  "elfin_robot_msgs/SetFloat64sRequest")
(cl:defmethod roslisp-msg-protocol:md5sum ((type (cl:eql '<SetFloat64s-request>)))
  "Returns md5sum for a message object of type '<SetFloat64s-request>"
  "5739026f6f0517440e663ba60441de94")
(cl:defmethod roslisp-msg-protocol:md5sum ((type (cl:eql 'SetFloat64s-request)))
  "Returns md5sum for a message object of type 'SetFloat64s-request"
  "5739026f6f0517440e663ba60441de94")
(cl:defmethod roslisp-msg-protocol:message-definition ((type (cl:eql '<SetFloat64s-request>)))
  "Returns full string definition for message of type '<SetFloat64s-request>"
  (cl:format cl:nil "float64[] data~%~%~%"))
(cl:defmethod roslisp-msg-protocol:message-definition ((type (cl:eql 'SetFloat64s-request)))
  "Returns full string definition for message of type 'SetFloat64s-request"
  (cl:format cl:nil "float64[] data~%~%~%"))
(cl:defmethod roslisp-msg-protocol:serialization-length ((msg <SetFloat64s-request>))
  (cl:+ 0
     4 (cl:reduce #'cl:+ (cl:slot-value msg 'data) :key #'(cl:lambda (ele) (cl:declare (cl:ignorable ele)) (cl:+ 8)))
))
(cl:defmethod roslisp-msg-protocol:ros-message-to-list ((msg <SetFloat64s-request>))
  "Converts a ROS message object to a list"
  (cl:list 'SetFloat64s-request
    (cl:cons ':data (data msg))
))
;//! \htmlinclude SetFloat64s-response.msg.html

(cl:defclass <SetFloat64s-response> (roslisp-msg-protocol:ros-message)
  ((success
    :reader success
    :initarg :success
    :type cl:boolean
    :initform cl:nil)
   (message
    :reader message
    :initarg :message
    :type cl:string
    :initform ""))
)

(cl:defclass SetFloat64s-response (<SetFloat64s-response>)
  ())

(cl:defmethod cl:initialize-instance :after ((m <SetFloat64s-response>) cl:&rest args)
  (cl:declare (cl:ignorable args))
  (cl:unless (cl:typep m 'SetFloat64s-response)
    (roslisp-msg-protocol:msg-deprecation-warning "using old message class name elfin_robot_msgs-srv:<SetFloat64s-response> is deprecated: use elfin_robot_msgs-srv:SetFloat64s-response instead.")))

(cl:ensure-generic-function 'success-val :lambda-list '(m))
(cl:defmethod success-val ((m <SetFloat64s-response>))
  (roslisp-msg-protocol:msg-deprecation-warning "Using old-style slot reader elfin_robot_msgs-srv:success-val is deprecated.  Use elfin_robot_msgs-srv:success instead.")
  (success m))

(cl:ensure-generic-function 'message-val :lambda-list '(m))
(cl:defmethod message-val ((m <SetFloat64s-response>))
  (roslisp-msg-protocol:msg-deprecation-warning "Using old-style slot reader elfin_robot_msgs-srv:message-val is deprecated.  Use elfin_robot_msgs-srv:message instead.")
  (message m))
(cl:defmethod roslisp-msg-protocol:serialize ((msg <SetFloat64s-response>) ostream)
  "Serializes a message object of type '<SetFloat64s-response>"
  (cl:write-byte (cl:ldb (cl:byte 8 0) (cl:if (cl:slot-value msg 'success) 1 0)) ostream)
  (cl:let ((__ros_str_len (cl:length (cl:slot-value msg 'message))))
    (cl:write-byte (cl:ldb (cl:byte 8 0) __ros_str_len) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 8) __ros_str_len) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 16) __ros_str_len) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 24) __ros_str_len) ostream))
  (cl:map cl:nil #'(cl:lambda (c) (cl:write-byte (cl:char-code c) ostream)) (cl:slot-value msg 'message))
)
(cl:defmethod roslisp-msg-protocol:deserialize ((msg <SetFloat64s-response>) istream)
  "Deserializes a message object of type '<SetFloat64s-response>"
    (cl:setf (cl:slot-value msg 'success) (cl:not (cl:zerop (cl:read-byte istream))))
    (cl:let ((__ros_str_len 0))
      (cl:setf (cl:ldb (cl:byte 8 0) __ros_str_len) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 8) __ros_str_len) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 16) __ros_str_len) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 24) __ros_str_len) (cl:read-byte istream))
      (cl:setf (cl:slot-value msg 'message) (cl:make-string __ros_str_len))
      (cl:dotimes (__ros_str_idx __ros_str_len msg)
        (cl:setf (cl:char (cl:slot-value msg 'message) __ros_str_idx) (cl:code-char (cl:read-byte istream)))))
  msg
)
(cl:defmethod roslisp-msg-protocol:ros-datatype ((msg (cl:eql '<SetFloat64s-response>)))
  "Returns string type for a service object of type '<SetFloat64s-response>"
  "elfin_robot_msgs/SetFloat64sResponse")
(cl:defmethod roslisp-msg-protocol:ros-datatype ((msg (cl:eql 'SetFloat64s-response)))
  "Returns string type for a service object of type 'SetFloat64s-response"
  "elfin_robot_msgs/SetFloat64sResponse")
(cl:defmethod roslisp-msg-protocol:md5sum ((type (cl:eql '<SetFloat64s-response>)))
  "Returns md5sum for a message object of type '<SetFloat64s-response>"
  "5739026f6f0517440e663ba60441de94")
(cl:defmethod roslisp-msg-protocol:md5sum ((type (cl:eql 'SetFloat64s-response)))
  "Returns md5sum for a message object of type 'SetFloat64s-response"
  "5739026f6f0517440e663ba60441de94")
(cl:defmethod roslisp-msg-protocol:message-definition ((type (cl:eql '<SetFloat64s-response>)))
  "Returns full string definition for message of type '<SetFloat64s-response>"
  (cl:format cl:nil "bool success~%string message~%~%~%~%"))
(cl:defmethod roslisp-msg-protocol:message-definition ((type (cl:eql 'SetFloat64s-response)))
  "Returns full string definition for message of type 'SetFloat64s-response"
  (cl:format cl:nil "bool success~%string message~%~%~%~%"))
(cl:defmethod roslisp-msg-protocol:serialization-length ((msg <SetFloat64s-response>))
  (cl:+ 0
     1
     4 (cl:length (cl:slot-value msg 'message))
))
(cl:defmethod roslisp-msg-protocol:ros-message-to-list ((msg <SetFloat64s-response>))
  "Converts a ROS message object to a list"
  (cl:list 'SetFloat64s-response
    (cl:cons ':success (success msg))
    (cl:cons ':message (message msg))
))
(cl:defmethod roslisp-msg-protocol:service-request-type ((msg (cl:eql 'SetFloat64s)))
  'SetFloat64s-request)
(cl:defmethod roslisp-msg-protocol:service-response-type ((msg (cl:eql 'SetFloat64s)))
  'SetFloat64s-response)
(cl:defmethod roslisp-msg-protocol:ros-datatype ((msg (cl:eql 'SetFloat64s)))
  "Returns string type for a service object of type '<SetFloat64s>"
  "elfin_robot_msgs/SetFloat64s")