import math
import numpy as np
import matplotlib.pyplot as plt
scan = np.loadtxt('laserscan.dat')
angle = np.linspace(-math.pi/2,math.pi/2,np.shape(scan)[0],endpoint='true')



def to_ref_laser(_scan,_angle):
    """
    将雷达采集到的数据转成相对雷达的坐标。
    原理：雷达采集到的数据是极坐标，要转成直角坐标
    """
    _x_ref_laser = _scan*np.cos(_angle)
    _y_ref_laser = _scan*np.sin(_angle)
    return _x_ref_laser,_y_ref_laser

def to_ref_world(_scan,_angle):
    # 将雷达采样点的直角坐标转换为齐次坐标
    _x_ref_laser,_y_ref_laser =to_ref_laser(_scan,_angle)
    homopos_ref_laser = np.stack((_x_ref_laser,_y_ref_laser,np.ones(_x_ref_laser.shape[0])))
    
    # 计算将雷达坐标系转换到机器人坐标系的变换矩阵
    angle_laser_robot = np.pi
    T_laser_robot = np.array([
        [np.cos(angle_laser_robot),-np.sin(angle_laser_robot),0.2],
        [np.sin(angle_laser_robot),np.cos(angle_laser_robot),0.0],
        [0.0, 0.0, 1.0],
    ])
    # 计算采样点在机器人坐标系下的坐标
    homopos_ref_robot = np.matmul(T_laser_robot,homopos_ref_laser)
    
    # 计算机器人坐标系变换到世界坐标系的变换矩阵
    angle_robot_world = np.pi/4
    T_robot_world = np.array([
        [np.cos(angle_robot_world),-np.sin(angle_robot_world),1.0],
        [np.sin(angle_robot_world),np.cos(angle_robot_world),0.5],
        [0.0, 0.0, 1.0],
    ])
    # 计算采样点在世界坐标系下的坐标
    homopos_ref_world = np.matmul(T_robot_world,homopos_ref_robot)
    return homopos_ref_world[0],homopos_ref_world[1]
    

def plot_points(_point_cordinate):
    plt.scatter(_point_cordinate[0],_point_cordinate[1])

# 绘制扫描的各个点相对雷达的坐标
# plot_points(to_ref_laser(scan,angle))

# 绘制机器人，雷达，和雷达扫描到的点
# 绘制机器人中心点
plot_points(np.array([1,0.5]))
# 绘制雷达所在点
plot_points(to_ref_world(np.array([0]),np.array([0])))
# 绘制雷达扫到的点
plot_points(to_ref_world(scan,angle))

plt.gca().set_aspect('equal', adjustable='box')
plt.show()