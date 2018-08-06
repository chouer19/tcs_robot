#!/usr/bin/env python2
# -*- coding: utf-8 -*-
"""
Created on Monday July 09 11:36:59 2018

@author: Chong Xue

 Software License Agreement (BSD License)

 Copyright (c) 2018, CAIP Co., Ltd.
 All rights reserved.

 Redistribution and use in source and binary forms, with or without
 modification, are permitted provided that the following conditions
 are met:

  * Redistributions of source code must retain the above copyright
    notice, this list of conditions and the following disclaimer.
  * Redistributions in binary form must reproduce the above
    copyright notice, this list of conditions and the following
    disclaimer in the documentation and/or other materials provided
    with the distribution.
  * Neither the name of the copyright holders nor the names of its
    contributors may be used to endorse or promote products derived
    from this software without specific prior written permission.

 THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
 "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
 LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS
 FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE
 COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT,
 INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING,
 BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
 LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
 CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
 LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
 POSSIBILITY OF SUCH DAMAGE.
 
"""
# author: Chong Xue

from __future__ import division
import rospy
import math
import tf
import moveit_commander
from std_msgs.msg import Bool, String, Int64
from std_srvs.srv import SetBool, SetBoolRequest, SetBoolResponse
from elfin_robot_msgs.srv import SetString, SetStringRequest, SetStringResponse, SetFloat64, SetFloat64s
from elfin_robot_msgs.srv import SetInt16, SetInt16Request, SetFloat64Request, SetFloat64sRequest
import wx
from sensor_msgs.msg import JointState
from actionlib import SimpleActionClient
from control_msgs.msg import FollowJointTrajectoryAction, FollowJointTrajectoryGoal
from control_msgs.msg import JointTrajectoryControllerState, JointsFloat64
from geometry_msgs.msg import PoseStamped, PoseArray, Pose
from trajectory_msgs.msg import trajectory_msgs
import threading
import dynamic_reconfigure.client
from dynamic_reconfigure.srv import Reconfigure, ReconfigureRequest
from dynamic_reconfigure.msg import DoubleParameter, Config
import time
import sys

def testcaip(num, num2, num3, num4, num5, num6):
    #print(num)
    caip = CaipElfin()
    #print(caip.JointState)
    caip.listen()
    print('start')
    for i in range(0,10):
        #print('come in function "call_ref_coordinate()"')
        time.sleep(0.4)
        #caip.want_end_coordinate()
        #print(caip.EndCoordinate)
        caip.want_stop()
        
        name=['elfin_joint1', 'elfin_joint2', 'elfin_joint3',
              'elfin_joint4', 'elfin_joint5', 'elfin_joint6']
        pos = [i*5 / 180 * math.pi] * 6
        #print(num)
        if num == 0:
            caip.do_joints_goal(name,pos)
        elif num == 1:
            caip.do_cart_goal(0.10 + i * 0.05, 0.10 + i * 0.06, 0.7 - 0.06 * i, 0,0,0,1 )
        elif num == 2:
            caip.set_cart_path()
            caip.do_cart_path()
        elif num == 3:
            caip.want_joint(num2)
            caip.want_joint(num3)
        elif num == 4:
            caip.want_home()
        elif num == 5:
            caip.want_cart(num2)
        elif num == 6:
            caip.do_joint_cmd(num2)
        print(caip.get_joints_state)

    caip.want_stop()
    print('end')
    pass

class Tcs_robot():

    def __init__(self):
        # The current status of the joints.
        self.JointState = JointTrajectoryControllerState()

        # The servo power's status of the robot.
        self.ServoPowerState = Bool()

        # The fault power's status of the robot.
        self.PowerFaultState = Bool()

        # The reference coordinate in the calculations of the elfin_basic_api node
        self.RefCoordinate = String()

        # The end coordinate in the calculations of the elfin_basic_api node
        self.EndCoordinate = String()

        #The value of the dynamic parameters of elfin_basic_api, e.g. velocity scaling.
        self.DynamicArgs = Config()

        # get the reference coordinate name of elfin_basic_api from the response of this service.
        self.call_ref_coordinate = rospy.ServiceProxy('elfin_basic_api/get_reference_link', SetBool)
        self.call_ref_coordinate_req = SetBoolRequest()

        # get the current position of elfin_ros_control from the response of this service.
        self.call_current_position = rospy.ServiceProxy('elfin_ros_control/elfin/get_current_position', SetBool)
        self.call_current_position_req = SetBoolRequest()

        # call service recognize_position of elfin_ros_control.
        self.call_recognize_position = rospy.ServiceProxy('elfin_ros_control/elfin/recognize_position', SetBool)
        self.call_recognize_position_req = SetBoolRequest()
        self.call_recognize_position_req.data = True

        # get the end coordinate name of elfin_basic_api from the response of this service.
        self.call_end_coordinate = rospy.ServiceProxy('elfin_basic_api/get_end_link', SetBool)
        self.call_end_coordinate_req = SetBoolRequest()

        # for publishing joint goals to elfin_basic_api
        self.JointsPub = rospy.Publisher('elfin_basic_api/joint_goal', JointState, queue_size=1)
        self.JointsGoal = JointState()

        # for publishing cart goals to elfin_basic_api
        self.CartGoalPub = rospy.Publisher('elfin_basic_api/cart_goal', PoseStamped, queue_size=1)
        self.CartPos = PoseStamped()

        # for pub cart path
        self.CartPathPub = rospy.Publisher('elfin_basic_api/cart_path_goal', PoseArray, queue_size=1)
        self.CartPath = PoseArray()
        self.CartPath.header.stamp=rospy.get_rostime()
        self.CartPath.header.frame_id='elfin_base_link'

        # for pub one specific joint action to elfin_teleop_joint_cmd_no_limit
        self.JointCmdPub = rospy.Publisher('elfin_teleop_joint_cmd_no_limit', Int64 , queue_size=1)
        self.JointCmd = Int64()

        # for pub multi specific joint action to elfin_teleop_joint_cmd_no_limit
        self.JointsCmdPub = rospy.Publisher('changyuan_joints_cmd', JointsFloat64, queue_size=1)
        self.JointsCmd = JointsFloat64()

        # action client, send goal to move_group
        self.action_client = SimpleActionClient('elfin_module_controller/follow_joint_trajectory',
                                              FollowJointTrajectoryAction)
        self.action_goal = FollowJointTrajectoryGoal()
        #self.goal_list = JointTrajectoryPoint()
        self.goal_list = []

        self.joints_ = []
        self.ps_ = []

        self.listener = tf.TransformListener()
        self.robot=moveit_commander.RobotCommander()
        self.scene=moveit_commander.PlanningSceneInterface()
        self.group=moveit_commander.MoveGroupCommander('elfin_arm')

        self.ref_link_name=self.group.get_planning_frame()
        self.end_link_name=self.group.get_end_effector_link()

        self.ref_link_lock=threading.Lock()
        self.end_link_lock=threading.Lock()

    
        self.call_teleop_stop=rospy.ServiceProxy('elfin_basic_api/stop_teleop', SetBool)
        self.call_teleop_stop_req=SetBoolRequest()


        self.call_teleop_joint=rospy.ServiceProxy('elfin_basic_api/joint_teleop',SetInt16)
        self.call_teleop_joint_req=SetInt16Request()


        self.call_teleop_joints=rospy.ServiceProxy('elfin_basic_api/joints_teleops',SetFloat64s)
        self.call_teleop_joints_req=SetFloat64sRequest()


        self.call_teleop_cart=rospy.ServiceProxy('elfin_basic_api/cart_teleop', SetInt16)
        self.call_teleop_cart_req=SetInt16Request()

 
        self.call_move_homing=rospy.ServiceProxy('elfin_basic_api/home_teleop', SetBool)
        self.call_move_homing_req=SetBoolRequest()

        self.call_reset=rospy.ServiceProxy(self.elfin_driver_ns+'clear_fault', SetBool)
        self.call_reset_req=SetBoolRequest()
        self.call_reset_req.data=True

        self.call_power_on = rospy.ServiceProxy(self.elfin_driver_ns+'enable_robot', SetBool)
        self.call_power_on_req=SetBoolRequest()
        self.call_power_on_req.data=True

        self.call_power_off = rospy.ServiceProxy(self.elfin_driver_ns+'disable_robot', SetBool)
        self.call_power_off_req = SetBoolRequest()
        self.call_power_off_req.data=True

        self.call_velocity_setting = rospy.ServiceProxy('elfin_basic_api/set_velocity_scale', SetFloat64)
        self.call_velocity_req = SetFloat64Request()
        self._velocity_scale = 0.78
        self.set_velocity_scale(self._velocity_scale)

        pass

    # call for service of one joint operation
    def want_joint(self,data):
        self.call_teleop_joint_req.data = data
        resp=self.call_teleop_joint.call(self.call_teleop_joint_req)
        return resp.success, resp.message

    # modify for new api whitch added jointsTeleop_cb(service of multi-joint teleopration)
    # call for service of multi joints operation
    def want_joints(self,data):
        self.call_teleop_joints_req.data = data
        resp=self.call_teleop_joints.call(self.call_teleop_joints_req)
        return resp.success, resp.message

    # call for service of clear_fault
    def want_clear_fault(self):
        resp = self.call_reset.call(self.call_reset_req)
        return resp.success, resp.message

    # call for service of power off
    def want_disable_robot(self):
        resp = self.call_power_off.call(self.call_power_off_req)
        return resp.success, resp.message

    # call for service of power on 
    def want_enable_robot(self):
        resp = self.call_power_on.call(self.call_velocity_req)
        return resp.success, resp.message

    # call for service of power on
    def want_power_on(self):
        resp = self.call_power_on.call(self.call_power_on_req)
        return resp.success, resp.message

    # call for service of home
    def want_home(self):
        self.call_move_homing_req.data = True
        resp=self.call_move_homing.call(self.call_move_homing_req)
        return resp.success, resp.message

    # call for service of home
    def want_cart(self, data):
        self.call_teleop_cart_req.data =data
        resp=self.call_teleop_cart.call(self.call_teleop_cart_req)
        return resp.success, resp.message

    # call for service of home
    def want_stop(self):
        self.call_teleop_stop_req.data=True
        resp=self.call_teleop_stop.call(self.call_teleop_stop_req)
        return resp.success, resp.message

    # call for service of setting velocity
    def set_velocity_scale(self, scale):
        self.call_velocity_req.data = scale
        resp = self.call_velocity_setting.call(self.call_velocity_req)
        if resp.success is True:
            self._velocity_scale = scale
        pass
        return resp.success, resp.message

    # get current velocity_scale
    def get_velocity_scale(self):
        return self._velocity_scale
        pass

    # pub one joint cmd once one time
    def do_joint_cmd(self, data):
        cmd = Int64()
        cmd.data = data
        self.JointCmdPub.publish(cmd)
        pass

    # modify for new api whitch added joints_cmds(subcribe of multi-joint teleopration)
    def do_joints_cmd(self, data):
        cmd = JointsFloat64()
        cmd.data = data
        self.JointsCmdPub.publish(cmd)
        pass

    # stop elfin by actionlib
    def do_action_stop():
        self.action_client.wait_for_server()
        self.action_goal.trajectory.header.stamp.secs=0
        self.action_goal.trajectory.header.stamp.nsecs=0
        self.action_goal.trajectory.points=[]
        self.action_client.send_goal(self.action_goal)


    # send path arg
    def set_cart_path(self):
        ps=Pose()
        ps.position.x=0.264
        ps.position.y=0.125
        ps.position.z=1.143
        ps.orientation.x=0
        ps.orientation.y=0
        ps.orientation.z=0
        ps.orientation.w=1

        ps1=Pose()
        ps1.position.x=0.324
        ps1.position.y=0.245
        ps1.position.z=1.143
        ps1.orientation.x=0
        ps1.orientation.y=0
        ps1.orientation.z=0
        ps1.orientation.w=1

        ps2=Pose()
        ps2.position.x=0.504
        ps2.position.y=0.330
        ps2.position.z=1.143
        ps2.orientation.x=0
        ps2.orientation.y=0
        ps2.orientation.z=0
        ps2.orientation.w=1

        ps3=Pose()
        ps3.position.x=0.505
        ps3.position.y=0.225
        ps3.position.z=1.143
        ps3.orientation.x=0
        ps3.orientation.y=0
        ps3.orientation.z=0
        ps3.orientation.w=1

        self.CartPath.poses.append(ps)
        self.CartPath.poses.append(ps1)
        self.CartPath.poses.append(ps2)
        #self.CartPath.poses.append(ps3)
        #self.CartPath.poses.append(ps1)
        pass

    # pub cart path to api
    def do_cart_path(self,path=None):
        if path is not None:
            self.CartPathPub.publish(path)
        else:
            self.CartPathPub.publish(self.CartPath)

    def set_cart_pos(self,x,y,z,ox,oy,oz,ow):
        self.CartPos.header.stamp=rospy.get_rostime()
        self.CartPos.header.frame_id='elfin_base_link'
        self.CartPos.pose.position.x=x
        self.CartPos.pose.position.y=y
        self.CartPos.pose.position.z=z
        self.CartPos.pose.orientation.x=ox
        self.CartPos.pose.orientation.y=oy
        self.CartPos.pose.orientation.z=oz
        self.CartPos.pose.orientation.w=ow
        pass

    def set_action_goal(self, name = None, goal_list = None):
        if name is not None and goal_list is not None:
            self.action_goal.trajectory.joint_names = name
            self.action_goal.trajectory.points = goal_list
        else:
            point_goal=JointTrajectoryPoint()
            point_goal.positions=[0.4, -0.5]
            point_goal.velocities=[0, 0]
            point_goal.accelerations=[0, 0]
            point_goal.time_from_start=rospy.Time(secs=2, nsecs=0)
            self.action_goal.trajectory.points.append(point_goal)

        self.action_goal.trajectory.header.stamp.secs=0
        self.action_goal.trajectory.header.stamp.nsecs=0
        pass

    # do action goal through actionlib
    def do_action_goal(self, action_goal = None):
        self.action_client.wait_for_server()
        if action_goal is None:
            self.action_client.send_goal(self.action_goal)
            self.action_goal.trajectory.points=[]
        else:
            self.action_client.send_goal(self.action_goal)

        pass

    # pub cart goal
    def do_cart_goal(self,x=None, y=None, z=None, ox=None, oy=None, oz=None, ow=None):
        if x is None or y is None or z is None or ox is None or oy is None or oz is None or ow is None:
             pass
        else:
            self.set_cart_pos(x,y,z,ox,oy,oz,ow)
        self.CartGoalPub.publish(self.CartPos)
        pass

    def set_joints_goal(self, name=None, pos=None):
        if name is None:
            name=['elfin_joint1', 'elfin_joint2', 'elfin_joint3',
                 'elfin_joint4', 'elfin_joint5', 'elfin_joint6']
        if pos is not None:
            name=['elfin_joint1', 'elfin_joint2', 'elfin_joint3',
                 'elfin_joint4', 'elfin_joint5', 'elfin_joint6']
            name = name[:len(pos)]
        else:
            pos = [0.4, 0.4, 0.4, 0.4, 0.4, 0.4]
        self.JointsGoal.name = name
        self.JointsGoal.position = pos
        self.JointsGoal.header.stamp=rospy.get_rostime()

    # pub joint goal
    def do_joints_goal(self, name=None, pos=None):
        if name is not None and pos is not None:
            self.set_joints_goal(name, pos)
        elif pos is not None:
            name=['elfin_joint1', 'elfin_joint2', 'elfin_joint3',
                 'elfin_joint4', 'elfin_joint5', 'elfin_joint6']
            name = name[:len(pos)]
            self.set_joints_goal(name, pos)
        self.JointsPub.publish(self.JointsGoal)

    # call service of end_link
    def want_end_coordinate(self):
        self.call_end_coordinate_req.data = True
        resp = self.call_end_coordinate.call(self.call_end_coordinate_req)
        if resp.success:
            self._end_coordinate(resp)
        #print(resp)
        return resp.success, self.EndCoordinate

    # call service of ref_link
    def want_ref_coordinate(self):
        self.call_ref_coordinate_req.data = True
        resp = self.call_ref_coordinate.call(self.call_ref_coordinate_req)
        if resp.success:
            self._ref_coordinate(resp)
        return resp.success, self.RefCoordinate
        #print(resp)

    # call service of current positions
    def want_current_pos(self):
        self.call_current_position_req.data = True
        resp = self.call_current_position.call(self.call_current_position_req)
        return resp.success, resp.message

    # call service of recognize positions
    def want_recognize_pos(self):
        self.call_recognize_position_req.data = True
        resp = self.call_recognize_position.call(self.call_recognize_position_req)
        return resp.success, resp.message

    # callback of subscribing joints_state
    def _joints_state(self, data):
         self.JointState = data
         #print(self.JointState)

    # get joints_state
    def get_joints_state(self):
         return self.JointState

    # callback of subcribe powr_enable status
    def _servo_power_state(self, data):
         self.ServoPowerState = data.data
         #print(data.data)

    def get_servo_power_state(self):
         return self.ServoPowerState

    def _power_fault_state(self,data):
        self.PowerFaultState = data.data
        #print(self.PowerFaultState)

    def get_power_fault_state(self):
        return self.PowerFaultState

    def _ref_coordinate(self,data):
        if hasattr(data, 'message'):
            self.RefCoordinate = data.message
        else:
            self.RefCoordinate = data.data
        #print(self.RefCoordinate)

    def get_ref_coordinate(self):
        return self.RefCoordinate

    def _end_coordinate(self,data):
        if hasattr(data, 'message'):
            self.EndCoordinate = data.message
        else:
            self.EndCoordinate = data.data
        #print(self.EndCoordinate)

    def get_end_coordinate(self):
        return self.EndCoordinate

    def _dynamic_args(self,data):
        self.DynamicArgs = data
        #print(self.DynamicArgs)
        
    def get_dynamic_args(self,data):
        return self.DynamicArgs

    # get joints angular
    def get_joints(self):
        return self.joints_

    # get current position
    def get_ps_(self):
        return self.ps_

    # monitor status
    def monitor_status(self, evt):
        self.key=[]
        self.joints_ = []
        self.ps_ = []
    
        current_joint_values=self.group.get_current_joint_values()
        for i in xrange(len(current_joint_values)):
            self.key.append(str(round(current_joint_values[i]*180/math.pi, 2)))
            self.joints_.append(current_joint_values[i]*180)

        if self.ref_link_lock.acquire():
            ref_link=self.ref_link_name
            self.ref_link_lock.release()

        if self.end_link_lock.acquire():
            end_link=self.end_link_name
            self.end_link_lock.release()

        while not rospy.is_shutdown():
            try:
                self.listener.waitForTransform(ref_link, end_link, rospy.Time(0), rospy.Duration(100))
                (xyz,qua) = self.listener.lookupTransform(ref_link, end_link, rospy.Time(0))
                break
            except (tf.LookupException, tf.ConnectivityException, tf.ExtrapolationException):
                continue

        rpy=tf.transformations.euler_from_quaternion(qua)

        self.key.append(str(round(xyz[0]*1000, 2)))
        self.ps_.append(xyz[0]*1000)
        self.key.append(str(round(xyz[1]*1000, 2)))
        self.ps_.append(xyz[1]*1000)
        self.key.append(str(round(xyz[2]*1000, 2)))
        self.ps_.append(xyz[2]*1000)

        self.key.append(str(round(rpy[0]*180/math.pi, 2)))
        self.ps_.append(rpy[0]*1000)
        self.key.append(str(round(rpy[1]*180/math.pi, 2)))
        self.ps_.append(rpy[1]*1000)
        self.key.append(str(round(rpy[2]*180/math.pi, 2)))
        self.ps_.append(rpy[2]*1000)
        
    def listen(self):
        rospy.Subscriber('elfin_arm_controller/state', JointTrajectoryControllerState, self._joints_state)
        rospy.Subscriber('elfin_ros_control/elfin/enable_state', Bool, self._servo_power_state)
        rospy.Subscriber('elfin_ros_control/elfin/fault_state', Bool, self._power_fault_state)
        rospy.Subscriber('elfin_basic_api/reference_link_name', String, self._ref_coordinate)
        rospy.Subscriber('elfin_basic_api/end_link_name', String, self._end_coordinate)
        rospy.Subscriber('elfin_basic_api/parameter_updates', Config, self._dynamic_args)
        rospy.Timer(rospy.Duration(nsecs=50000000), self.monitor_status)
        pass

  
if __name__=='__main__':  
    rospy.init_node('elfin_gui')

    #app=wx.App(False)  
    #myframe=MyFrame(parent=None,id=-1)  
    #myframe.Show(True)

    #myframe.listen()

    #app.MainLoop()
    num = 0
    num2 = 0
    num3 = 0
    num4 = 0
    num5 = 0
    num6 = 0
    if len(sys.argv) >= 2:
        num = int(sys.argv[1])
    if len(sys.argv) >= 3:
        num2 = int(sys.argv[2])
    if len(sys.argv) >= 4:
        num2 = int(sys.argv[3])
    if len(sys.argv) >= 5:
        num2 = int(sys.argv[4])
    if len(sys.argv) >= 6:
        num2 = int(sys.argv[5])
    if len(sys.argv) >= 7:
        num2 = int(sys.argv[6])
    testcaip(num, num2, num3, num4, num5, num6)
    rospy.spin()
