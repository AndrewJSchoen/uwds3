#!/usr/bin/env python
# -*- coding: UTF-8 -*-

import os
import rospy
import cv2
import sensor_msgs
import numpy as np
from cv_bridge import CvBridge
from pyuwds3.types.camera import Camera


class CameraPublisher(object):
    """ """
    def __init__(self):
        """Default constructor"""

        self.rgb_image_topic = rospy.get_param("~rgb_image_topic", "/camera/rgb/image_raw")
        self.camera_publisher = rospy.Publisher(self.rgb_image_topic, sensor_msgs.msg.Image, queue_size=1)

        self.camera_pub_frequency = rospy.get_param("~camera_pub_frequency", 30)
        self.camera_id = rospy.get_param("~camera_id", 0)

        self.bridge = CvBridge()
        self.camera_info_topic = rospy.get_param("~camera_info_topic", "/camera/rgb/camera_info")
        self.camera_info = sensor_msgs.msg.CameraInfo()
        self.camera_info_publisher = rospy.Publisher(self.camera_info_topic, sensor_msgs.msg.CameraInfo, queue_size=1)

        self.camera_frame_id = rospy.get_param("~camera_frame_id", "camera_link")
        self.camera_info.header.frame_id = self.camera_frame_id

        self.capture = cv2.VideoCapture(self.camera_id)
        ok, frame = self.capture.read()

        if frame is None:
            rospy.logerr("Unable to read the camera {}! Shutdown the camera publisher..".format(self.camera_id))
        else:
            height, width, _ = frame.shape

            self.camera = Camera(height=height, width=width)

            self.camera_info = self.camera.to_msg().info

            self.timer = rospy.Timer(rospy.Duration(1.0/self.camera_pub_frequency), self.timer_callback)
            rospy.loginfo("Camera publisher ready !")
            while not rospy.is_shutdown():
                rospy.spin()

        self.capture.release()

    def timer_callback(self, event):
        ok, frame = self.capture.read()
        if ok:
            bgr_image_msg = self.bridge.cv2_to_imgmsg(frame, "bgr8")
            bgr_image_msg.header.stamp = rospy.Time().now()
            self.camera_info.header = bgr_image_msg.header
            bgr_image_msg.header.frame_id = self.camera_frame_id
            self.camera_publisher.publish(bgr_image_msg)
            self.camera_info_publisher.publish(self.camera_info)


if __name__ == '__main__':
    rospy.init_node("camera_publisher", anonymous=False)
    c = CameraPublisher()
