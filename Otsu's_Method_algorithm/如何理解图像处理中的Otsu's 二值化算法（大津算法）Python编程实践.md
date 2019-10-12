# Otsu's 二值化（大津算法）
## 二值化是什么？有什么用？
PDF扫描成电子版，文字识别，车牌识别等等图像处理场合均需要使用“二值化”操作。我们知道图像是一个矩阵组成，矩阵的元素是一个数字，这个数字是当前像素点对应的颜色（即像素值）。而图片的二值化操作就是将所有像素值变成要么是0要么是1.一般二值化怎么做的呢？答：“设置一个数字d，只要像素值大于这个阈值d那就设置为1，小于这个阈值d那就设置为0。当然也可以大于这个阈值设置为0，小于设置为1”。**但是这个阈值怎么找到的呢？计算出一个合适的阈值出来这就是 Otsu's 二值化（大津算法）要做的事情**。
下面是一幅图片对应的像素值矩阵（图片就是矩阵）：
$\begin{bmatrix} 
200,30,40\\
13, 40,45
\end{bmatrix}$
假设现在我通过Otsu's 二值化（大津算法）计算出上面那个图片二值化的最优阈值是39.
那么上面那个图片就会被二值化为：
$\begin{bmatrix} 
1,0,1\\
0, 1,1
\end{bmatrix}$
下面我们实验下。

## 实验1. 造一个数据
做图像处理必备技能就是人工制造一个纯净的图片检验算法正确性
```python
import numpy as np
import cv2
import matplotlib.pyplot as plt

######我们先制造一个200x200的图片用于二值化实验#######
def get_test_img():
    img_mat = np.zeros((200,200),dtype=np.uint8)# 记得设置成整数，不然opencv会将大于1的浮点数全显示成白色
    for row in range(200):
        for col in range(200):
            img_mat[row][col] = col
    return img_mat
img_mat = get_test_img()
plt.imshow(img_mat,cmap='gray')# 显示图片
plt.xlabel("raw img")
```
如下所示：
![在这里插入图片描述](https://img-blog.csdnimg.cn/20191012211830811.png)
## 2. 手工设置阈值进行二值化实验
```python
##########我们设置二值化的阈值为100，将像素值小于100设置为0 （黑色）大于100设置为1 （白色）#######
img_mat = get_test_img() # 注意这是实验1中那个函数
img_mat[img_mat<=100]=0
img_mat[img_mat>100]=1
plt.imshow(img_mat,cmap='gray')# 显示图片
plt.xlabel("binary img")
```
我们将实验1中的图片二值化为下面这张图。
![在这里插入图片描述](https://img-blog.csdnimg.cn/2019101221200258.png)
# Otsu's 二值化（大津算法）是怎么根据一张图片计算出它二值化的最优阈值的？
它就是统计各个像素值的出现的次数，然后遍历各种阈值（总共有256种可能的选择），然后让被划分的那两类的像素值的方差的加权和最小。加权和的权重就是对应类中像素值之和。这个方差就用统计学中的方差计算公式即可。
我总结下Otsu伪代码：
```
统计各个像素值的出现次数

while(遍历各种阈值的取值（0到255种可能）)
{
    1. 根据当前阈值对图像所有出现的像素值进行分类。
    大于阈值的像素值分为一个类A，小于阈值则分为另外一个类B。（到时候你可以让A类中所有像素值为1，B类所有像素值为0。也可以让类A所有像素值为0.这都是可以你自己定，所以我就用A，B代替了。）
    2. 计算类A的所有像素值的方差SA，计算类B中所有像素值的方差SB
    3. 计算类A中所有像素值之和IA，计算类B中所有像素点的像素值的像素值之和IB
    4. 计算当前阈值划分下两个类的像素值方差的加权和S=IA*SA+SB*IB
    5. 像素值方差的加权和S是否是目前遍历到的阈值划分下最小的那一个值？如果是那就保存当前这种取值
}

通过上面操作最终得到最优的阈值d。

while(遍历所有像素点）
{
   像素值大于阈值d赋值为1，
   像素值小于阈值d赋值为0
}
```
## otsu二值化实验
先用cv2中的otsu库函数看看效果
```python
# 调用cv2中的otsu库
img_mat = get_test_img() # 这是实验1中的那个函数
img_mat = img_mat.astype(np.uint8)
threshold,img_mat = cv2.threshold(img_mat,0,255,cv2.THRESH_BINARY+cv2.THRESH_OTSU)
print(threshold)
plt.imshow(img_mat,cmap='gray')
```
![在这里插入图片描述](https://img-blog.csdnimg.cn/20191012212222452.png)
再我们自己造一个轮子Python代码从零实现otsu二值化算法
```python

import numpy as np
# 自己造轮子写otsu二值化算法
img_mat = get_test_img()
img_mat = img_mat.astype(np.uint8)
##############统计各个像素值的出现次数##############
img_mat_vector = img_mat.flatten()
pixel_counter = np.zeros(256)
for pixel_value in img_mat_vector:
    pixel_counter[pixel_value] += 1

############遍历阈值的各种可能的取值############
min_variance = np.inf
best_threshold = 0
pixel_value = np.arange(256)
for threshold in range(256):
    # 1. 根据阈值对各个像素值进行划分
    pixel_value_A = pixel_value[0:threshold]
    pixel_value_B = pixel_value[threshold:]
    # 2. 计算类A的所有像素值的方差SA，计算类B中所有像素值的方差SB
    totalPixelNum_A = np.sum(pixel_counter[pixel_value_A]) 
    totalPixelNum_B = np.sum(pixel_counter[pixel_value_B])
    
    Probability_pixelvalue_A = pixel_counter[pixel_value_A]/totalPixelNum_A
    Probability_pixelvalue_B = pixel_counter[pixel_value_B]/totalPixelNum_B
    
    meanPixelValue_A = np.sum(pixel_value_A  *  Probability_pixelvalue_A)
    meanPixelValue_B = np.sum(pixel_value_B  *  Probability_pixelvalue_B)
    
    varianceA = np.sum(Probability_pixelvalue_A * (pixel_value_A-meanPixelValue_A)**2)
    varianceB = np.sum(Probability_pixelvalue_B * (pixel_value_B-meanPixelValue_B)**2)
    
    current_total_variance = totalPixelNum_A*varianceA + totalPixelNum_B*varianceB
    if current_total_variance<min_variance:
        min_variance = current_total_variance
        best_threshold = threshold
        
print("最优像素值的阈值为",best_threshold)
#######根据获得的阈值对图像各个像素像素点进行二值化######
img_mat[img_mat<best_threshold] = 0
img_mat[img_mat>=best_threshold] = 1
plt.imshow(img_mat,cmap='gray')
```
最优像素值的阈值为 100
![在这里插入图片描述](https://img-blog.csdnimg.cn/20191012212345739.png)
# 用实际数据实践
```python
# 手写一个otsu二值化
img = cv2.imread('./eight.png',cv2.IMREAD_GRAYSCALE)
# 图片数据我已放到github了
##############统计各个像素值的出现次数##############
img_vector = img.flatten()
pixel_counter = np.zeros(256)
for pixel_value in img_vector:
    pixel_counter[pixel_value] += 1

############遍历阈值的各种可能的取值############
min_variance = np.inf
best_threshold = 0
pixel_value = np.arange(256)
for threshold in range(256):
    # 1. 根据阈值对各个像素值进行划分
    pixel_value_A = pixel_value[0:threshold]
    pixel_value_B = pixel_value[threshold:]
    # 2. 计算类A的所有像素值的方差SA，计算类B中所有像素值的方差SB
    totalPixelNum_A = np.sum(pixel_counter[pixel_value_A]) 
    totalPixelNum_B = np.sum(pixel_counter[pixel_value_B])
    
    Probability_pixelvalue_A = pixel_counter[pixel_value_A]/totalPixelNum_A
    Probability_pixelvalue_B = pixel_counter[pixel_value_B]/totalPixelNum_B
    
    meanPixelValue_A = np.sum(pixel_value_A  *  Probability_pixelvalue_A)
    meanPixelValue_B = np.sum(pixel_value_B  *  Probability_pixelvalue_B)
    
    varianceA = np.sum(Probability_pixelvalue_A * (pixel_value_A-meanPixelValue_A)**2)
    varianceB = np.sum(Probability_pixelvalue_B * (pixel_value_B-meanPixelValue_B)**2)
    
    current_total_variance = totalPixelNum_A*varianceA + totalPixelNum_B*varianceB
    if current_total_variance<min_variance:
        min_variance = current_total_variance
        best_threshold = threshold
        
print("最优像素值的阈值为",best_threshold)
#######根据获得的阈值对图像各个像素像素点进行二值化######
img[img<best_threshold] = 0
img[img>=best_threshold] = 1
plt.imshow(img,cmap='gray')
```
实验结果如下所示
![在这里插入图片描述](https://img-blog.csdnimg.cn/20191012212420495.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3ZhcnlzaGFyZQ==,size_16,color_FFFFFF,t_70)

它的原始图片为：
![在这里插入图片描述](https://img-blog.csdnimg.cn/20191012212521922.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3ZhcnlzaGFyZQ==,size_26,color_FFFFFF,t_70)
