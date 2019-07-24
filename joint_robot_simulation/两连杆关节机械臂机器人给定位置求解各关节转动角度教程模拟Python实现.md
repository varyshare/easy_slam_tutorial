# 两连杆关节机械臂机器人给定位置求解各关节转动角度教程模拟Python实现
我们要解决的问题是**已知一个目标点坐标(x,y)，已知两个连杆的长度a1,a2，我们的目标是求q1,q2这两个关节角**.如下图所示：
![在这里插入图片描述](https://img-blog.csdnimg.cn/20190723152329992.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3ZhcnlzaGFyZQ==,size_16,color_FFFFFF,t_70)
因为已知坐标(x,y)即我们已知下图中的三角形的两个直角边。根据勾股定理可以得到斜边的长度为$r=\sqrt{x^2+y^2}$.
![在这里插入图片描述](https://img-blog.csdnimg.cn/20190723152504849.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3ZhcnlzaGFyZQ==,size_16,color_FFFFFF,t_70)
因此下面这个三角形所有的边都是已知的了。
![在这里插入图片描述](https://img-blog.csdnimg.cn/20190723152813954.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3ZhcnlzaGFyZQ==,size_16,color_FFFFFF,t_70)
高中的几何学告诉我们三条边已知的话那就可以根据余弦定理求出一个角。因此我们是计划把那个大角$\alpha$求出来。为什么？因为求出$\alpha$那么我们就可以求出关节角q2，因为它们是互为补角。$q2=180-\alpha$。现在我们已经求出一个关节角了。
![在这里插入图片描述](https://img-blog.csdnimg.cn/20190723153338783.png)
现在我们知道了角度q2.而且知道第2个杆的长度a2. 因此我们可以解出下面这个三角形的两条边.
![在这里插入图片描述](https://img-blog.csdnimg.cn/20190723153448942.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3ZhcnlzaGFyZQ==,size_16,color_FFFFFF,t_70)
于是乎，我们现在已知下面这个直角三角形的两条直角边。根据反切公式可以求出$\beta$这个锐角。为什么要求$\beta$这个锐角？请看后面的分析。
![在这里插入图片描述](https://img-blog.csdnimg.cn/20190723153617365.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3ZhcnlzaGFyZQ==,size_16,color_FFFFFF,t_70)
下面这个图的三角形的两个直角边就是目标点的横坐标和纵坐标x,y。那么我们是可以求出边y对着的那个角，并且$\beta$我们已经求出了。因此我们可以求出我们想要的关节角q1.
![在这里插入图片描述](https://img-blog.csdnimg.cn/20190723154206689.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3ZhcnlzaGFyZQ==,size_16,color_FFFFFF,t_70)
# 总结：
现在我们得到了两个关节角的求解方式。
![在这里插入图片描述](https://img-blog.csdnimg.cn/20190723154341456.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3ZhcnlzaGFyZQ==,size_16,color_FFFFFF,t_70)
但是由于cos函数是一个对称函数，所以同一个值会对应两个可能的角度。**这也符合我们的预期，因为除非两个杆完全在同一条线上，否则任意给定一个目标位置就一定可以给出两种不同的弯曲方式**。
**情况1**：
![在这里插入图片描述](https://img-blog.csdnimg.cn/20190723154526445.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3ZhcnlzaGFyZQ==,size_16,color_FFFFFF,t_70)
**情况2**：
![在这里插入图片描述](https://img-blog.csdnimg.cn/20190723154712884.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3ZhcnlzaGFyZQ==,size_16,color_FFFFFF,t_70)
![在这里插入图片描述](https://img-blog.csdnimg.cn/20190723154813450.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3ZhcnlzaGFyZQ==,size_16,color_FFFFFF,t_70)
# Python编程实践模拟一个二连杆机器人
## 前向运动可视化
```python
"""
@author 李韬——知乎@Ai酱
教程地址：https://blog.csdn.net/varyshare/article/details/96885179
"""
import numpy as np
from math import sin,cos,pi
import matplotlib.pyplot as plt
class TwoLinkArm:
    """
    两连杆手臂模拟。
    所使用的变量与模拟实体对应关系如下所示：
    (joint0)——连杆0——(joint1)——连杆1——[joint2]
    注意：joint0是基座也是坐标原点(0,0)
    """
    def __init__(self,_joint_angles=[0,0]):
        # 第0个关节是基座所以坐标固定是原点(0,0)
        self.joint0 = np.array([0,0])
        # 机器人两段连杆（手臂）的长度
        self.link_lengths = [1,1]
        self.update_joints(_joint_angles)
        self.forward_kinematics()
        

    def update_joints(self, _joint_angles):
        self.joint_angles = _joint_angles
    
    def forward_kinematics(self):
        """
        根据各个关节角计算各个关节的位置.
        注意：所使用的变量与模拟实体对应关系如下所示：
        (joint0)——连杆0——(joint1)——连杆1——[joint2]
        """

        # 计算关节1的位置
        # q0,q1分别是第0和第1个关节的关节角
        q0 = self.joint_angles[0]
        a0 = self.link_lengths[0]
        self.joint1 = self.joint0 + [a0*cos(q0), a0*sin(q0)]

        # 计算关节2的位置
        q1 = self.joint_angles[1]
        a1 = self.link_lengths[1]
        # 注意：q1是杆1相对于杆0的延长线的转角，而杆0相对水平线的转角是q0
        # 所以杆1相对水平线的转角是(q0+q1), 而joint2是杆1的末端
        self.joint2 = self.joint1 + [a1*cos(q0+q1), a1*sin(q0+q1)]
    
    def plot(self):
        """
        绘制当前状态下的机械臂
        """
        # 三个关节的坐标
        x = [self.joint0[0],self.joint1[0],self.joint2[0]]
        y = [self.joint0[1],self.joint1[1],self.joint2[1]]
        # 绘制这样的一条线——连杆0————连杆1——
        plt.plot(x, y,c='red',zorder=1)
        # 绘制三个黑圆点代表关节,zorder=2是为了让绘制的点盖在直线上面
        plt.scatter(x,y,c='black',zorder=2)
        plt.show()
    def transform(_points,_theta,_origin):
        """
        求这些点_points绕_origin这个点旋转_theta度后相对世界坐标系的坐标。
        注意_points的坐标是相对以_origin为原点的坐标系下的坐标。
        _origin: 旋转中心点在世界坐标系下的坐标
        _points: 相对旋转中心这个
        _theta: 旋转的角度
        """
        T = np.array([
            [cos(_theta), -sin(_theta),  _origin[0]],
            [sin(_theta), cos(_theta),   _origin[1]],
            [0,           0,                      1]
        ])
        

arm_robot = TwoLinkArm([pi/6,pi/4])
arm_robot.plot()
```
运行截图：
![在这里插入图片描述](https://img-blog.csdnimg.cn/2019072320201481.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3ZhcnlzaGFyZQ==,size_16,color_FFFFFF,t_70)
## 鼠标选定屏幕上一点，然后求逆解进行运动Python实现代码

代码地址（同一个文件夹）:[two_joint_arm_robot.py](two_joint_arm_robot.py)

下面是效果图，**打开你的编辑器跟着我写的代码实践吧，你的赞和关注是我持续分享的动力**。
![在这里插入图片描述](https://img-blog.csdnimg.cn/20190724160425592.gif)



参考文献：
[1] https://robotacademy.net.au/lesson/inverse-kinematics-for-a-2-joint-robot-arm-using-geometry/