# 从零开始实现FAST特征点提取算法教程Python代码实现

FAST的全称是：Features from Accelerated Segment Test

> 特征点提取与匹配在计算机视觉中是一个很重要的环节。比如人脸识别，目标跟踪，三维重建，等等都是先提取特征点然后匹配特征点最后执行后面的算法。因此学习特定点提取和匹配是计算机视觉中的基础。本文将介绍FAST特征点提取与匹配算法的原理，并使用Python不调用OpenCV包实现FAST特征点提取算法。

# 特征点提取到底是提取的是什么？
答：**首先，提取的是角点，边缘**。提取角点可以进行跟踪，提取边就可以知道图像发生了怎样的旋转。反正都是提取的是那些周围发生颜色明显变化的那些地方。这个也很容易想通，要是它周围全一样的颜色那肯定是物体的内部，一来没必要跟踪。二来它发生了移动计算机也无法判断，因为它周围都一样颜色计算机咋知道有没有变化。**其次，提取的是周围信息（学术上叫做：描述子）**。我们**只要提到特征点提取就一定要想到提取完后我们是需要匹配的**。为了判断这个点有没有移动，我们需要比较前后两帧图片中相同特征点之间是否有位移。为了判断是否是相同特征点那就要进行比对（匹配）。**怎么比较两个特征点是否是同一个**？**这就需要比较这两个特征点周围信息是否一样。周围信息是一样那就认为是同一个特征点**。那么怎么比较周围信息呢？一般会把周围的像素通过一系列计算方式变成一个数字。然后比较这个数字是否相同来判断周围信息是否相同。
![在这里插入图片描述](https://img-blog.csdnimg.cn/20190718145644785.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3ZhcnlzaGFyZQ==,size_16,color_FFFFFF,t_70)

# 所有特征提取与匹配算法通用过程
1. 找到那些周围有明显变化的像素点作为特征点。如下图所示，那些角点和边缘这些地方明显颜色变化的那些像素点被作为特征点。
![在这里插入图片描述](https://img-blog.csdnimg.cn/20190718152825942.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3ZhcnlzaGFyZQ==,size_16,color_FFFFFF,t_70)
2. **提取这些特征点周围信息。一般是在当前这个点周围随机采样选几个像素点作为当前特征点的周围信息，或者画个圈圈进行采样**。不同采样方法构成了不同算法。反正你想一个采样方法那你就创建了一种算法。

3. 特征点匹配。比如我要跟踪某个物体，我肯定是要先从这个物体提取一些特征点。然后看下一帧相同特征点的位置在哪，计算机就知道这个物体位置在哪了。怎么匹配？前面提到了我们第2步有提取当前特征点周围信息，只要周围信息一样那就是相同特征点。特征匹配也有很多种算法，最土的是前后两帧图片上的特征点一个一个的比对。
![在这里插入图片描述](https://img-blog.csdnimg.cn/20190718152119359.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3ZhcnlzaGFyZQ==,size_16,color_FFFFFF,t_70)
**记住学习任何特征提取与匹配算法都要时刻想起上面提到的三步骤。这样你不会太陷入那些书里面的细节中而学了很久都不懂。或者学完就忘。事实上那些算法非常简单，只不过你不知道他们各个步骤之间的联系是什么为什么这么设计。不知道这些当然就看不懂了。**
# FAST特征点提取算法
FAST (Features from Accelerated Segment Test)是一个特征点提取算法的缩写。这是一个点提取算法。它原理非常简单，**遍历所有的像素点，判断当前像素点是不是特征点的唯一标准就是在以当前像素点为圆心以3像素为半径画个圆（圆上有16个点），统计这16个点的像素值与圆心像素值相差比较大的点的个数。超过9个差异度很大的点那就认为圆心那个像素点是一个特征点**。那么什么叫做差异度很大呢？答：就是像素值相减取绝对值，然后我们设置一个数字只要前面那个绝对值大于这个数字，那就认为差异大。比如我**设置阈值是3。第1个像素点的像素值是4，中间圆心像素值是10，然后10-4=6，这是大于阈值3的。所以第1个像素点算所一个差异度较大的像素点**。就这样**统计1~16个中有多少个是和圆心相比差异度比较大的点。只要超过9个那就认为圆心是一个特征点。**是不是很简单？其实这些算法只要你知道他们想干嘛，你也可以设计一个不错的算法的。
![在这里插入图片描述](https://img-blog.csdnimg.cn/20190718160218250.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3ZhcnlzaGFyZQ==,size_16,color_FFFFFF,t_70)
为了简化问题我们构造一个带有角点的7x7的小图片，注意下面坐标轴单位是像素。
![在这里插入图片描述](https://img-blog.csdnimg.cn/2019072210335231.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3ZhcnlzaGFyZQ==,size_16,color_FFFFFF,t_70)
然后使用bresenham算法画圆（如下图所示），可以看到周围有超过9个点与中心那个像素点的像素值很大差异。因此程序会判断当前圆心所在的像素点是关键点。
![在这里插入图片描述](https://img-blog.csdnimg.cn/20190722103253875.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3ZhcnlzaGFyZQ==,size_16,color_FFFFFF,t_70)
现在稍微有一丝丝难度的是怎么画圆。因为这个圆它是一个像素一个像素的画。这个圆其实你自己可以随便设计一个算法画圆。今天我们要讲FAST算法当然还是介绍下他是怎么画圆的。他就用了最普通的图形学画圆算法（[Bresenham 画圆法](http://en.wikipedia.org/wiki/Midpoint_circle_algorithm) ）。

**其实到这里FAST算法我们就介绍完了。为了节省大家的时间（你的赞和关注是支持我分享的动力）**，我把Bresenham 画圆法也讲讲。
## Bresenham 布雷森汉姆算法画圆的原理与编程实现教程
注意：Bresenham的圆算法只是中点画圆算法的优化版本。区别在于Bresenham的算法只使用整数算术，而中点画圆法仍需要浮点数。**你不了解中点画圆法并没有任何影响**，因为他们只是思想一样，但是思路并不是一样。

Bresenham也是根据待选的两个点哪个离圆弧近就下一步选哪个。它是怎么判断的呢？这两个点一定有一个在圆弧内一个在圆弧外。到底选哪个？Bresenham的方法就是直接计算两个点离圆弧之间的距离，然后判断哪个更近就选哪个。如下图所示：
![在这里插入图片描述](https://img-blog.csdnimg.cn/20190719115849411.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3ZhcnlzaGFyZQ==,size_16,color_FFFFFF,t_70)
那么怎么用数学量化他们离圆弧的距离呢？
答：前面我们提到了，当前粉红色这个点坐标为$(x_k,y_k)$，下一步它有两种可能的走法绿色$(x_k-1,y_k+1)$，紫色坐标为$(x_k,y_k+1)$
$d1 = (x_k-1)^2+(y_k+1)^2-r^2$
$d2 = (x_k)^2+(y_k+1)^2-r^2$
注意：$d1 = (x_k-1)^2+(y_k+1)^2-r^2$小于0的，因为绿色那个点一定在圆内侧。$d2 = (x_k)^2+(y_k+1)^2-r^2$一定是大于等于0的，因为紫色那个点一定在圆外侧。

**所以我们只用比较$P_k = d1+d2$到底是大于0还是小于0就能确定选哪个点了。大于0选绿色$(x_k-1,y_k+1)$那个点（因为紫色那个点偏离圆弧程度更大）。小于0则选紫色$(x_k,y_k+1)$那个点**。

**好了Bresenham画圆法我讲完了**。

你或许会问，不对啊。我在网上看到的关于Bresenham画圆法的博客还有其他公式。确实我还有一个小细节没讲。**你用上面的方法是已经可以画圆了，剩下的就是一些提高计算效率的小细节**。

$P_k = d1+d2= (x_k-1)^2+(y_k+1)^2-r^2+(x_k)^2+(y_k+1)^2-r^2$这个公式走到下一步时候$P_{k+1} = d1+d2$又要重新计算。为了提高效率。人们就想能不能通过递推的方式来算$P_{k+1}$，即能不能找一个这样的公式$P_{k+1}=P_k+Z$提高计算效率。

这个也很简单，这个递推公式关键在于求Z。而我们变换下公式$P_{k+1}=P_k+Z$得到$Z=P_{k+1}-P_k$。
注意：$P_k= d1+d2= (x_k-1)^2+(y_k+1)^2-r^2+(x_k)^2+(y_k+1)^2-r^2$我们已知的，而$P_{k+1}$这个根据$P_k$大于0还是小于0也可以算出来。
1. 当$P_k>=0$则证明靠近外侧的那个待选点$(x_k,y_k+1)$离圆弧更远，所以我们下一步选的点是另外一个靠近内侧圆弧的那个点$(x_k-1,y_k+1)$。也就是说第k+1步那个点$(x_{k+1},y_{k+1})=(x_k-1,y_k+1)$。
$Z=P_{k+1}-P_k= (x_{k+1}-1)^2+(y_{k+1}+1)^2-r^2+(x_{k+1})^2+(y_{k+1}+1)^2-r^2 
-[ (x_k-1)^2+(y_k+1)^2-r^2+(x_k)^2+(y_k+1)^2-r^2] \\
= (x_k-1-1)^2+(y_k+1+1)^2-r^2+(x_k-1)^2+(y_k+1+1)^2-r^2 
-[ (x_k-1)^2+(y_k+1)^2-r^2+(x_k)^2+(y_k+1)^2-r^2]\\
=-4x_k+4y_k+10$。所以$P_{k+1}=P_k-4x_k+4y_k+10$
2. 当$P_k<0$时，们下一步选的点是另外一个靠近内侧圆弧的那个点是$(x_k,y_k+1)$。也就是说第k+1步那个点$(x_{k+1},y_{k+1})=(x_k,y_k+1)$。我们看看现在的Z是多少。
$Z=P_{k+1}-P_k= (x_{k+1}-1)^2+(y_{k+1}+1)^2-r^2+(x_{k+1})^2+(y_{k+1}+1)^2-r^2 
-[ (x_k-1)^2+(y_k+1)^2-r^2+(x_k)^2+(y_k+1)^2-r^2] \\
= (x_k-1)^2+(y_k+1+1)^2-r^2+(x_k)^2+(y_k+1+1)^2-r^2 
-[ (x_k-1)^2+(y_k+1)^2-r^2+(x_k)^2+(y_k+1)^2-r^2]\\
=4y_k+6$。所以$P_{k+1}=P_k+4y_k+6$
注意：根据初始点为(r,0)来计算$P_k$的初始值=$-2r+3$。
```python
# -*- coding: utf-8 -*-
"""
Created on Sun Jul 21 15:02:36 2019
Bresenham画圆法实现
博客教程地址：
https://blog.csdn.net/varyshare/article/details/96724103
@author: 知乎@Ai酱
"""
import numpy as np
import matplotlib.pyplot as plt

img = np.zeros((105,105)) # 创建一个105x105的画布

def draw(x,y):
    """ 
     绘制点(x,y)
     注意：需要把(x,y)变换到数组坐标系（图形学坐标系）
     因为数组(0,0)是左上，而原先坐标系(0,0)是中心点
     而且数组行数向下是增加的。
    """
    # 平移原点
    x += int(img.shape[0]/2)
    y += int(img.shape[1]/2)
    # 
    img[-y,x] = 1
pass

r_pixel = 50 # 圆的半径,单位：像素
# 初始化,画第一个点，从水平最右边那个点开始画
(x,y) = (r_pixel,0)

"""
从定义来讲就是
P_k=d1+d2
d1 = 第1个下一步待选点离圆弧的距离（负数）
d2 = 第2个下一步待选点离圆弧的距离（正数）
但是为了提高效率通常使用递推来求P_{k+1}=P_k + 一个数
"""
P_k = -2*r_pixel + 3

# 迭代的求完1/8圆弧
while x>=y:
    # 下一步有两个待选点，具体选哪个要看P_k>0 或 <0
    if P_k>=0:# 外侧候选点偏离圆弧更远
        P_k_next =  P_k - 4*x + 4*y + 10
        (x_next,y_next) = (x-1, y+1)
    else:# 内侧候选点偏离圆弧更远
        P_k_next =  P_k + 4*y + 6
        (x_next,y_next) = (x, y+1)
    # 对称法画其他地方
    draw(x,y)
    draw(-x,y) 
    draw(x,-y) 
    draw(-x,-y) 

    draw(y,x) 
    draw(y,-x) 
    draw(-y,x) 
    draw(-y,-x) 
    # 更新坐标和P_k
    (x,y) = (int(x_next),int(y_next))
    P_k = P_k_next
pass
# 绘制图片
plt.imshow(img)
```

程序运行的结果为：
![在这里插入图片描述](https://img-blog.csdnimg.cn/20190721174835219.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3ZhcnlzaGFyZQ==,size_16,color_FFFFFF,t_70)
Bresenham画圆github代码下载地址: https://gist.github.com/varyshare/adc2960a36da9571674861fb6cfea58a
上图的半径是40像素，当然FAST画圆的半径是3像素.我们只用修改一行设置半径的代码为`r_pixel = 3 # 圆的半径,单位：像素`。半径为3像素的圆如下图所示：
![在这里插入图片描述](https://img-blog.csdnimg.cn/20190721190029188.png)


使用OpenCV库中的FAST特征点检测算法
```python
'''
Features from Accelerated Segment Test (FAST)
Python实现，
从0开始，最原始最简单的FAST特征点提取方法（无金字塔采样）
代码地址：https://github.com/varyshare/easy_slam_tutorial/tree/master/feature_extract
欢迎fork参与这个开源项目,star这项目
教程地址：https://blog.csdn.net/varyshare/article/details/96430924
代码没有怎么经过优化，所以会有0.8s左右的卡顿
'''
import numpy as np
import matplotlib.pyplot as plt
import cv2 # 用于读取图片
   

# 1. 读取图片(为了简化问题我就直接构造一个数组作为图片)
img = cv2.imread('feature.png',cv2.IMREAD_GRAYSCALE)

# 2. 设置参数
# 设置灰度值相差多大才算较大差异，
# 以及周围点超过多少个高差异点才算当前中心像素点是关键点
h_gray_scale = 20 # 在ORB特征提取中使用的FAST像素差阈值默认是20
k_diff_point = 9 # 超过k_diff_point个差异那就认为是关键点（周围共16个点）
r_pixel = 3 # 获取周围像素所用的圆的半径,单位：像素


# 3. 遍历所有的像素进行检测关键点
def bresenham_circle():
    """
    return: 圆周上所有的点相对圆心的坐标列表。
    即，返回圆心在(0,0)处时圆周上各点的坐标。
    返回一个r_pixel*r_pixel的矩阵，圆周上的点标记为1，其他地方标记为0
    """

    _masked_canvas = np.zeros((2*r_pixel+1,2*r_pixel+1))
    def save(x,y):
        """ 
         把(x,y)加入到结果列表中
         注意：需要把(x,y)变换到数组坐标系（图形学坐标系）
        """
        _masked_canvas[-y+r_pixel,x+r_pixel] = 1
    pass

    # 初始化,画第一个点，从水平最右边那个点开始画
    (x,y) = (r_pixel,0)
    
    """
    从定义来讲就是
    P_k=d1+d2
    d1 = 第1个下一步待选点离圆弧的距离（负数）
    d2 = 第2个下一步待选点离圆弧的距离（正数）
    但是为了提高效率通常使用递推来求P_{k+1}=P_k + 一个数
    """
    P_k = -2*r_pixel + 3
    
    # 迭代的求完1/8圆弧
    while x>=y:
        # 下一步有两个待选点，具体选哪个要看P_k>0 或 <0
        if P_k>=0:# 外侧候选点偏离圆弧更远
            P_k_next =  P_k - 4*x + 4*y + 10
            (x_next,y_next) = (x-1, y+1)
        else:# 内侧候选点偏离圆弧更远
            P_k_next =  P_k + 4*y + 6
            (x_next,y_next) = (x, y+1)
        # 对称法画这对称的8个地方
        save(x,y)
        save(-x,y) 
        save(x,-y) 
        save(-x,-y) 
    
        save(y,x) 
        save(y,-x) 
        save(-y,x) 
        save(-y,-x) 
        # 更新当前坐标和P_k
        (x,y) = (int(x_next),int(y_next))
        P_k = P_k_next
    pass

    return _masked_canvas

# 先bresenham算法算出半径为r_pixel时圆周上的点相对圆心的坐标
masked_canvas = bresenham_circle()
def key_point_test(_row,_col):
    """
    检测像素点(_row,_col)是否是关键点。
    满足关键点只有一个条件：周围16个像素点与中心像素点相比
    差异度较大(>h_gray_scale)的像素点个数超过k_diff_point个
    return: boolean
    """
    # 获取以(_row,_col)为几何中心的7x7正方形区域内的像素值
    surround_points = img[_row-3:_row+3+1,_col-3:_col+3+1]
    
    # 获取圆周上的点与圆心的像素差值的绝对值
    _dist = np.abs((surround_points - img[_row,_col])) * masked_canvas
    
    if (_dist>h_gray_scale).sum()> k_diff_point:
        return True
    else:
        return False


key_point_list = []

for row in range(r_pixel,img.shape[0]-r_pixel):
    for col in range(r_pixel,img.shape[1]-r_pixel):
        
        if key_point_test(row,col):
            key_point_list.append(cv2.KeyPoint(x=row,y=col,_size=1))
        else:
            continue
            
    pass
pass


img_with_keypoints = cv2.drawKeypoints(img,key_point_list,outImage=np.array([]),color=(0,0,255))
cv2.imshow("show key points",img_with_keypoints)
cv2.waitKey(0)
```
下图是我们对一个小图片进行检测程序运行的结果，可以看到最明显的几个角点找到了，但是也有几个点漏掉了。这是因为我们设置16个点中超过9个点和中心点不同这个数值9对于这张图来说大了些。你如果设置为7那就都能检测到了。
![在这里插入图片描述](https://img-blog.csdnimg.cn/20190722110318186.png)
参考文献：
[1] https://medium.com/software-incubator/introduction-to-feature-detection-and-matching-65e27179885d
[2] https://docs.opencv.org/3.0-beta/doc/py_tutorials/py_feature2d/py_fast/py_fast.html#fast
[3] https://medium.com/software-incubator/introduction-to-fast-features-from-accelerated-segment-test-4ed33dde6d65
[4] https://www.youtube.com/watch?v=1Te8U_JR8SI