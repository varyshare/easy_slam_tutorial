## Bresenham 布雷森汉姆算法画圆的原理与Python编程实现教程
注意：Bresenham的圆算法只是中点画圆算法的优化版本。区别在于Bresenham的算法只使用整数算术，而中点画圆法仍需要浮点数。注意：不要因为我提到了中点画圆法你就去先看完[计算机图形学中点画圆法教程](https://blog.csdn.net/varyshare/article/details/96839691)再看Bresenham算法，这样是浪费时间。**中点画圆法和Bresenham画圆法只是思想一样，但是思路并没有很大关联。所以直接看Bresenham算法就可以**。

看下面这个图，这就是一个像素一个像素的画出来的。我们平常的圆也是一个像素一个像素的画出来的，你可以试试在“画图”这个软件里面画一个圆然后放大很多倍，你会发现就是一些像素堆积起来的。
![在这里插入图片描述](https://img-blog.csdnimg.cn/20190718192037816.png)
![在这里插入图片描述](https://img-blog.csdnimg.cn/2019071819203165.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3ZhcnlzaGFyZQ==,size_16,color_FFFFFF,t_70)
我们看出来圆它是一个上下左右都对称，而且也是中心对称的。所以我们只用画好八分之一圆弧就可以，其他地方通过对称复制过去就好。
![在这里插入图片描述](https://img-blog.csdnimg.cn/20190718192849587.png)
看下面这幅图，绿线夹住的那部分就是八分之一圆弧。**注意我们是逆时针画圆的（即从水平那个地方即(r,0)开始画因为一开始我们只知道水平位置的像素点该放哪其他地方我们都不知道）**。Bresenham 算法画完一个点(x,y)后`注意x,y都是整数。他们代表的是x,y方向上的第几个像素。`，它下一步有两个选择(x,y+1),(x-1,y+1)。也就是说y一定增加,但是x要么保持不变要么减一（你也可以让x一定增加y要么不变要么加一，其实差不多的）。当程序画到粉红色那个像素点的时候，程序选择下一步要绘制的点为(x-1，y+1)。当程序画到黄色的那个像素点时候，程序选择下一步要绘制的点为(x,y+1)。
![在这里插入图片描述](https://img-blog.csdnimg.cn/20190718193719108.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3ZhcnlzaGFyZQ==,size_16,color_7F1FFF,t_70)
我们看看粉色的那个点的下一步是如何抉择的。
![在这里插入图片描述](https://img-blog.csdnimg.cn/20190718201205329.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3ZhcnlzaGFyZQ==,size_16,color_FFFFFF,t_70)


Bresenham是根据待选的两个点哪个离圆弧近就下一步选哪个。那它是怎么判断的呢？这两个点一定有一个在圆弧内一个在圆弧外。到底选哪个？Bresenham的方法就是直接计算两个点离圆弧之间的距离，然后判断哪个更近就选哪个。如下图所示：
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
![在这里插入图片描述](https://img-blog.csdnimg.cn/20190721174903599.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3ZhcnlzaGFyZQ==,size_16,color_FFFFFF,t_70)

github代码下载地址:[计算机图形学Bresenham画圆法Python代码](./bresenham_circle.py)



# 如何使用这个项目的教程和代码？

1. Clone 下载这个项目.

> git clone https://github.com/varyshare/easy_slam_tutorial.git

> cd easy_slam_tutorial/