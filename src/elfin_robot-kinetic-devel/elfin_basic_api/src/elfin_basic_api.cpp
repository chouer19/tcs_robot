/*
Created on Mon Dec 15 10:58:42 2017

@author: Cong Liu

 Software License Agreement (BSD License)

 Copyright (c) 2017, Han's Robot Co., Ltd.
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
 LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN
 ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
 POSSIBILITY OF SUCH DAMAGE.
*/
// author: Cong Liu

#include <elfin_basic_api/elfin_basic_api.h>

namespace elfin_basic_api {

ElfinBasicAPI::ElfinBasicAPI(moveit::planning_interface::MoveGroupInterface *group, std::string action_name, planning_scene_monitor::PlanningSceneMonitorPtr planning_scene_monitor):
    group_(group), action_client_(action_name, true), planning_scene_monitor_(planning_scene_monitor), local_nh_("~")
{
    teleop_api_=new ElfinTeleopAPI(group, action_name, planning_scene_monitor);
    motion_api_=new ElfinMotionAPI(group, action_name, planning_scene_monitor);

    //dynamic_reconfigure_server_.setCallback(boost::bind(&ElfinBasicAPI::dynamicReconfigureCallback, this, _1, _2));

    set_ref_link_server_=local_nh_.advertiseService("set_reference_link", &ElfinBasicAPI::setRefLink_cb, this);
    set_end_link_server_=local_nh_.advertiseService("set_end_link", &ElfinBasicAPI::setEndLink_cb, this);
    set_velocity_scale_=local_nh_.advertiseService("set_velocity_scale", &ElfinBasicAPI::setVelocityScale_cb, this);

    ref_link_name_publisher_=local_nh_.advertise<std_msgs::String>("reference_link_name", 1, true);
    end_link_name_publisher_=local_nh_.advertise<std_msgs::String>("end_link_name", 1, true);

    ref_link_name_msg_.data=group_->getPlanningFrame();
    end_link_name_msg_.data=group_->getEndEffectorLink();

    ref_link_name_publisher_.publish(ref_link_name_msg_);
    end_link_name_publisher_.publish(end_link_name_msg_);
}

// Function: setVelocityScale_cb
// Author: XueChong
// Belong: Constant Source Technology TianJin Campany
// Data: 2018.08.01
// Description: 
//             add a service for the client to set velocity scale

bool ElfinBasicAPI::setVelocityScale_cb(elfin_robot_msgs::SetFloat64::Request &req, elfin_robot_msgs::SetFloat64::Response &resp){
    double scale = req.data;
    if(scale <0 || scale > 1){
        resp.success=false;
        resp.message="the scale is not in right range";
        return false;
    }
    velocity_scaling_ = scale;
    teleop_api_->setVelocityScaling(velocity_scaling_);

    resp.success=true;
    resp.message="new velocity has been set successfully";
    return true;

}

ElfinBasicAPI::~ElfinBasicAPI()
{
    if(teleop_api_ != NULL)
        delete teleop_api_;
    if(motion_api_ != NULL)
        delete motion_api_;
}

void ElfinBasicAPI::dynamicReconfigureCallback(ElfinBasicAPIDynamicReconfigureConfig &config, uint32_t level)
{
    setVelocityScaling(config.velocity_scaling);
}

void ElfinBasicAPI::setVelocityScaling(double data)
{
    velocity_scaling_=data;
    teleop_api_->setVelocityScaling(velocity_scaling_);
}

bool ElfinBasicAPI::setRefLink_cb(elfin_robot_msgs::SetString::Request &req, elfin_robot_msgs::SetString::Response &resp)
{
    if(!tf_listener_.frameExists(req.data))
    {
        resp.success=false;
        std::string result="There is no frame named ";
        result.append(req.data);
        resp.message=result;
        return true;
    }

    teleop_api_->setRefFrames(req.data);
    motion_api_->setRefFrames(req.data);

    ref_link_name_msg_.data=req.data;
    ref_link_name_publisher_.publish(ref_link_name_msg_);

    resp.success=true;
    resp.message="Setting reference link succeed";
    return true;
}

bool ElfinBasicAPI::setEndLink_cb(elfin_robot_msgs::SetString::Request &req, elfin_robot_msgs::SetString::Response &resp)
{
    if(!tf_listener_.frameExists(req.data))
    {
        resp.success=false;
        std::string result="There is no frame named ";
        result.append(req.data);
        resp.message=result;
        return true;
    }

    teleop_api_->setEndFrames(req.data);
    motion_api_->setEndFrames(req.data);

    end_link_name_msg_.data=req.data;
    end_link_name_publisher_.publish(end_link_name_msg_);

    resp.success=true;
    resp.message="Setting end link succeed";
    return true;
}

}
