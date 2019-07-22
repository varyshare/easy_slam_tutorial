'''
使用OpenCV实现ORB特征点提取
作者：知乎@Ai酱
代码地址：https://github.com/varyshare/easy_slam_tutorial/tree/master/feature_extract
'''
    
# -*- coding: utf-8 -*-
import cv2
import numpy as np
# 0. 读取图片
img = cv2.imread('./right.png',cv2.IMREAD_GRAYSCALE)
# 1. 创建一个ORB检测器实例
orb = cv2.ORB_create()
# 2. 检测关键点
keypoint, descript = orb.detectAndCompute(img,None)
# 3. 绘制关键点
result_img = cv2.drawKeypoints(img,keypoint,None,color=(0,255,0),flags=cv2.IMREAD_GRAYSCALE)
# 4. 显示含有关键点的图片
cv2.imshow("ORB feature point extract",result_img)
cv2.waitKey(0)


