// Generated by gencpp from file elfin_robot_msgs/ElfinIODWrite.msg
// DO NOT EDIT!


#ifndef ELFIN_ROBOT_MSGS_MESSAGE_ELFINIODWRITE_H
#define ELFIN_ROBOT_MSGS_MESSAGE_ELFINIODWRITE_H

#include <ros/service_traits.h>


#include <elfin_robot_msgs/ElfinIODWriteRequest.h>
#include <elfin_robot_msgs/ElfinIODWriteResponse.h>


namespace elfin_robot_msgs
{

struct ElfinIODWrite
{

typedef ElfinIODWriteRequest Request;
typedef ElfinIODWriteResponse Response;
Request request;
Response response;

typedef Request RequestType;
typedef Response ResponseType;

}; // struct ElfinIODWrite
} // namespace elfin_robot_msgs


namespace ros
{
namespace service_traits
{


template<>
struct MD5Sum< ::elfin_robot_msgs::ElfinIODWrite > {
  static const char* value()
  {
    return "0fc64fac1c3cd738d439b721e21f91e5";
  }

  static const char* value(const ::elfin_robot_msgs::ElfinIODWrite&) { return value(); }
};

template<>
struct DataType< ::elfin_robot_msgs::ElfinIODWrite > {
  static const char* value()
  {
    return "elfin_robot_msgs/ElfinIODWrite";
  }

  static const char* value(const ::elfin_robot_msgs::ElfinIODWrite&) { return value(); }
};


// service_traits::MD5Sum< ::elfin_robot_msgs::ElfinIODWriteRequest> should match 
// service_traits::MD5Sum< ::elfin_robot_msgs::ElfinIODWrite > 
template<>
struct MD5Sum< ::elfin_robot_msgs::ElfinIODWriteRequest>
{
  static const char* value()
  {
    return MD5Sum< ::elfin_robot_msgs::ElfinIODWrite >::value();
  }
  static const char* value(const ::elfin_robot_msgs::ElfinIODWriteRequest&)
  {
    return value();
  }
};

// service_traits::DataType< ::elfin_robot_msgs::ElfinIODWriteRequest> should match 
// service_traits::DataType< ::elfin_robot_msgs::ElfinIODWrite > 
template<>
struct DataType< ::elfin_robot_msgs::ElfinIODWriteRequest>
{
  static const char* value()
  {
    return DataType< ::elfin_robot_msgs::ElfinIODWrite >::value();
  }
  static const char* value(const ::elfin_robot_msgs::ElfinIODWriteRequest&)
  {
    return value();
  }
};

// service_traits::MD5Sum< ::elfin_robot_msgs::ElfinIODWriteResponse> should match 
// service_traits::MD5Sum< ::elfin_robot_msgs::ElfinIODWrite > 
template<>
struct MD5Sum< ::elfin_robot_msgs::ElfinIODWriteResponse>
{
  static const char* value()
  {
    return MD5Sum< ::elfin_robot_msgs::ElfinIODWrite >::value();
  }
  static const char* value(const ::elfin_robot_msgs::ElfinIODWriteResponse&)
  {
    return value();
  }
};

// service_traits::DataType< ::elfin_robot_msgs::ElfinIODWriteResponse> should match 
// service_traits::DataType< ::elfin_robot_msgs::ElfinIODWrite > 
template<>
struct DataType< ::elfin_robot_msgs::ElfinIODWriteResponse>
{
  static const char* value()
  {
    return DataType< ::elfin_robot_msgs::ElfinIODWrite >::value();
  }
  static const char* value(const ::elfin_robot_msgs::ElfinIODWriteResponse&)
  {
    return value();
  }
};

} // namespace service_traits
} // namespace ros

#endif // ELFIN_ROBOT_MSGS_MESSAGE_ELFINIODWRITE_H
