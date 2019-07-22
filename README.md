# easy_slam_tutorial

[![Build Status](https://travis-ci.org/AtsushiSakai/PythonRobotics.svg?branch=master)](https://travis-ci.org/varyshare/easy_slam_tutorial)
[![Documentation Status](https://readthedocs.org/projects/pythonrobotics/badge/?version=latest)](https://github.com/varyshare/easy_slam_tutorial/blob/master/README.md)
[![Build status](https://ci.appveyor.com/api/projects/status/sb279kxuv1be391g?svg=true)](https://ci.appveyor.com/project/varyshare/easy_slam_tutorial)
[![Language grade: Python](https://img.shields.io/lgtm/grade/python/g/AtsushiSakai/PythonRobotics.svg?logo=lgtm&logoWidth=18)](https://lgtm.com/projects/g/AtsushiSakai/PythonRobotics/context:python)
[![CodeFactor](https://www.codefactor.io/repository/github/atsushisakai/pythonrobotics/badge/master)](https://www.codefactor.io/repository/github/varyshare/easy_slam_tutorial/overview/master)
[![tokei](https://tokei.rs/b1/github/varyshare/easy_slam_tutorial/)](https://github.com/AtsushiSakai/PythonRobotics)
[![Say Thanks!](https://img.shields.io/badge/Say%20Thanks-!-1EAEDB.svg)](https://www.zhihu.com/people/yuanmuou/activities)

简单的从零开始实现视觉SLAM理论与实践教程，使用Python实现。包括：ORB特征点提取，对极几何，视觉里程计后端优化，实时三维重建地图。A easy SLAM practical tutorial (Python).

## 目录

##  [特征提取](./feature_extract/)
###  [从零开始实现FAST特征点提取算法教程](./feature_extract/从零开始实现FAST特征点提取算法教程.md)
[FAST教程](./feature_extract/从零开始实现FAST特征点提取算法教程.md) [代码](./feature_extract/FAST_feature_extraction.py)

![在这里插入图片描述](https://img-blog.csdnimg.cn/20190722103253875.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3ZhcnlzaGFyZQ==,size_16,color_FFFFFF,t_70)

### 计算机图形学Bresenham画圆法Python实现
[教程](./feature_extract/易懂的Bresenham 布雷森汉姆算法画圆的原理与Python编程实现教程.md) [代码](./feature_extract/bresenham_circle.py)

![在这里插入图片描述](https://img-blog.csdnimg.cn/20190721174903599.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3ZhcnlzaGFyZQ==,size_16,color_FFFFFF,t_70)

### ORB特征提取Python调用OpenCV2实现
ORB特征提取主要是[FAST提取特征点](./feature_extract/从零开始实现FAST特征点提取算法教程.md)+[BRIEF算法](https://blog.csdn.net/varyshare/article/details/96568030)提取周围信息
[代码](./feature_extract/ORB_feature_extract.py)

![1563794343832](C:\Users\varys\AppData\Roaming\Typora\typora-user-images\1563794343832.png)