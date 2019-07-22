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

img = np.zeros((7,7)) # 创建一个105x105的画布
count = 0
def draw(x,y):
    """ 
     绘制点(x,y)
     注意：需要把(x,y)变换到数组坐标系（图形学坐标系）
     因为数组(0,0)是左上，而原先坐标系(0,0)是中心点
     而且数组行数向下是增加的。
    """

    img[-y+int(img.shape[0]/2),x+int(img.shape[1]/2)] = 1

pass

r_pixel = 3 # 圆的半径,单位：像素
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




