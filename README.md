> 输出一篇关于core animation的读书笔记，书籍为《iOS Core Animation: Advanced Techniques 中文译本》。旨在记录与讨论core animation的知识，不记录基ccccc础知识。

### 1. 图层与视图

#### 1.1 CALayer图层

每一个UIView对象中都有一个CALayer对象。我们知道，IOS 中所有的视图UIView都是基于UIView派生的，UIView可以处理与用户的交互，而内容渲染都是交给CALayer对象的。

当然UIView的另一个作用就是创建合管理这个图层，保证子视图在层级关系中添加或移出时，所关联的图层结构也能跟着变化。而这个图层结构便是图层树。

#### 1.2 图层的能力

虽然苹果在UIView上已经队CALayer进行了一次封装，但是有一些功能并没有暴露出来，例如：圆角，阴影等。因此要使用还需要操纵CALayer对象。具体功能如下图所示：

![51ea1e8b98097483bd4636e29269733e](/Users/lengguocheng/Library/Caches/BaiduMacHi/Share/images/51ea1e8b98097483bd4636e29269733e.png)

#### 1.3 图层的使用

##### 1.3.1 简单使用

如果仅仅改变某几个简单分属性，只需要改变该UIView的layer中属性就可以，例如：

```objective-c
view.layer.xxx
```

xxx这是上一小节列出的属性。

##### 1.3.2 子图层

我们知道UIView中，视图的图层是通过添加子视图来实现的：

```objective-c
- (void)addSubView:(UIView *)view;
```

同样的，对于CALayer也有一个类似的API来添加子图层：

```objective-c
- (void)addSublayer:(CALayer *)layer;
```

##### 1.3.3 自定义子图层

在我们要使用一个关于相机的controller的时候，会使用相机会提供一个预览图层：`AVCaptureVideoPreviewLayer`。这其实也是一个CALayer，我们需要将这个layer添加到子图层上，并且需要设置同步session。但是出了添加这个方法，还是可以使用UIView的一个类方法：

```objective-c
+ (Class)layerClass;
```

每一个UIView都是寄宿在一个CALayer的示例上。这个图层是由视图自动创建和管理的，那我们可以用别的图层类型替代它么？一旦被创建，我们就无法代替这个图层了。但是如果我们继承了UIView，那我们就可以重写+layerClass方法使得在创建的时候能返回一个不同的图层子类。UIView会在初始化的时候调用+layerClass方法，然后用它的返回类型来创建宿主图层。

#### 1.4 总结

最后总结一下，使用图层和UIView的时机：

**1. 使用UIView**

使用图层关联的视图而不是`CALayer`的好处在于，你能在使用所有`CALayer`底层特性的同时，也可以使用`UIView`的高级API（比如自动排版，布局和事件处理）

**2. 使用CALayer**

当满足以下条件的时候，你可能更需要使用`CALayer`而不是`UIView`:

- 开发同时可以在Mac OS上运行的跨平台应用
- 使用多种`CALayer`的子类，并且不想创建额外的`UIView`去包封装它们所有。
- 做一些对性能特别挑剔的工作，比如对`UIView`一些可忽略不计的操作都会引起显著的不同。

`总的来说，处理视图会比单独处理图层更加方便。`

### 2. contents系列属性

#### 2.1 contents属性

类型为id，也就是可以赋值为任何类型，但是如果赋值不是CGImage，那么layer则是空白的，因此该属性通常称寄宿图。(具体原因不在此赘述)对contents赋值时，需要如下使用：

```objective-c
layer.contents = (__bridge id)image.CGImage;
```

因为类型不兼容，需要用`__bridge`进行转换。

#### 2.2 contentsGravity

UIView有一个属性叫：contentMode，它是一个枚举类型，用来决定内容的对齐方式。通常用在UIView的派生类UIIMageView上。常用属性注释如下：

```objective-c
typedef NS_ENUM(NSInteger, UIViewContentMode) {
    UIViewContentModeScaleToFill, //缩放填充，可能会导致图片变形。
    UIViewContentModeScaleAspectFit,  //等比缩放把图片整体显示在ImageView中，所以可能会出现ImageView有空白部分  
    UIViewContentModeScaleAspectFill,     //等比缩放图片把整个ImageView填充满，所以可能会出现图片部分显示不出来
    UIViewContentModeRedraw,              // redraw on bounds change (calls -setNeedsDisplay)
    UIViewContentModeCenter,              
    UIViewContentModeTop,
    UIViewContentModeBottom,
    UIViewContentModeLeft,
    UIViewContentModeRight,
    UIViewContentModeTopLeft,
    UIViewContentModeTopRight,
    UIViewContentModeBottomLeft,
    UIViewContentModeBottomRight,
};
```

与CALayer对象属性叫contentsGravity，但其是NSString类型

```objective-c
kCAGravityCenter
kCAGravityTop
kCAGravityBottom
kCAGravityLeft
kCAGravityRight
kCAGravityTopLeft
kCAGravityTopRight
kCAGravityBottomLeft
kCAGravityBottomRight
kCAGravityResize
kCAGravityResizeAspect
kCAGravityResizeAspectFill
```

和`cotentMode`一样，`contentsGravity`的目的是为了决定内容在图层的边界中怎么对齐。

#### 2.3 contentsScale

该属性的类型为CGFloat，定义了寄宿图的像素尺寸与视图大小的比例，默认情况下为1.0。

由于对IUView或者layer设置了对齐方式，被拉伸以适应图层的边界。如果设置缩放大小，可以采用仿射变换。

contentsScale其实属于支持高分辨率屏幕机制的一部分。用来判断寄宿图。如果`contentsScale`设置为1.0，将会以每个点1个像素绘制图片，如果设置为2.0，则会以每个点2个像素绘制图片，这就是我们熟知的Retina屏幕。（在不使用拉伸的对齐方式时，contentsScale将会带来明显的变化）。

因此在使用寄宿图的时候，一定要主要contentsScale属性，否则在高像素屏幕下会显示不正确，其使用方式如下：

```objective-c
layer.contentsScale = [UIScreen mainScreen].scale;
```

#### 2.4 makeToBounds

默认情况下，UIView会绘制超出边界之外的内容，在CALayer也是。在UIView中饭有一个叫 clipsToBounds的属性来决定是否显示超出边界的内容，而CALayer对应的属性叫makeToBounds。设置为YES则裁剪掉超出边界的内容。

#### 2.5 contentsRect

该属性主要是设置contents要显示的某一个区域，是两个坐标组成：{x1,y1,x2,y2}，但是该坐标是以用单位来使用的，也就是说，最大是1。通常是{0,0,1,1}，也就是显示完全的寄宿图。通常在我们某一个视图上，需要加载很多小图，可以这样做：把小图片拼合后，打包整合到一张大图上，然后一次性载入。相比多次载入不同的图片，这样做能够带来很多方面的好处：内存使用，载入时间，渲染性能等等

![图2.6](https://zsisme.gitbooks.io/ios-/content/chapter2/2.6.png)

### 3. 自定义绘制

#### 3.1 drawRect

##### 3.1.1 drawRect介绍

根据设置layer的contents并不是唯一设置寄宿图的方式，通过继承UIView并重写`- (void)drawRect:`方法也可以自定义绘制寄宿图。

对于UIView来说，并不在乎说最底层是不是一张图片，还是一个颜色。但是如果UIView检测到drawRect被调用了，就会为视图分配一个寄宿图。这个寄宿图的像素尺寸等于视图大小乘以`contentsScale`。如果不需要寄宿图，则不必要重写该方法，尤其提供一个空的drawRect。这会造成CPU资源和内存的浪费，这也是为什么苹果建议：如果没有自定义绘制的任务就不要在子类中写一个空的-drawRect:方法。

##### 3.1.2 drawRect注意事项

1. view初始化时没有设置rect时不会被调用
2. 重新调整frame后会调用
3. 不能主动调用
4. 可以调用setNeedsDisplay，或者setNeedsDisplayInRect，系统自动调用drawRect

##### 3.1.3 drawRect使用

新建一个类,继承UIView 实现drawRect:方法,然后在这个方法里写：

1.获取上下文 (使用贝塞尔直接画图，则不需要获取。注意用上下文绘制会带来内存的消耗)

2.描述路径 

3.把描述路径添加到上下文当中 

4.把上下文的内容显示到View上

```objective-c
UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(0, 0) radius:_cornerRadius startAngle:0 endAngle:M_PI/2.0 clockwise:YES];
[path addLineToPoint:CGPointMake(0, 0)];
[path closePath];
path.lineWidth = 5.0;
path.lineCapStyle = kCGLineCapRound;
path.lineJoinStyle = kCGLineJoinRound;
[_fillColor set];
[path fill];
```

想学习更多则参看大佬写的[**【drawRect:绘图】**](https://www.jianshu.com/p/324c879de586)

#### 3.2 CALayerDelegate

`-drawRect:`方法的背后实际上都是底层的`CALayer`进行了重绘和保存中间产生的图片，`CALayer`的`delegate`属性默认实现了`CALayerDelegate`协议，当它需要内容信息的时候会调用协议中的方法来拿。当视图重绘时，因为它的支持图层`CALayer`的代理就是视图本身，所以支持图层会请求视图给它一个寄宿图来显示，它此刻会调用：

```
 - (void)displayLayer:(CALayer *)layer;
```

如果视图实现了这个方法，就可以拿到`layer`来直接设置`contents`寄宿图，如果这个方法没有实现，支持图层`CALayer`会尝试调用：

```
 - (void)drawLayer:(CALayer *)layer inContext:(CGContextRef)ctx;
```

这个方法调用之前，`CALayer`创建了一个合适尺寸的空寄宿图（尺寸由`bounds`和`contentsScale`决定）和一个`Core Graphics`的绘制上下文环境，为绘制寄宿图做准备，它作为`ctx`参数传入。

![image-20201201155852503](/Users/lengguocheng/Library/Application Support/typora-user-images/image-20201201155852503.png)

我们在blueLayer上显式地调用了`-display`。不同于UIView，当图层显示在屏幕上时，CALayer不会自动重绘它的内容。它把重绘的决定权交给了开发者。当使用CALayerDelegate绘制寄宿图的时候，layer没有对超出边界外的内容提供绘制支持。因此会发生裁剪。

#### 3.3 总结

除非需要自定义一个单独的图层，几乎没有机会用到CALayerDelegate协议。因为当UIView创建了它的宿主图层时，它就会自动地把图层的delegate设置为它自己，并提供了一个`-displayLayer:`的实现，那所有的问题就都没了。

当使用寄宿了视图的图层的时候，也不必实现`-displayLayer:`和`-drawLayer:inContext:`方法来绘制寄宿图。通常做法是实现UIView的`-drawRect:`方法，UIView就会帮你做完剩下的工作，包括在需要重绘的时候调用`-display`方法。

不建议使用 Core Graphics 绘图，使用 CAShapeLayer 搭配 贝塞尔曲线已经能完成大部分需求，且与 Core Graphics 相比可节省大量内存占用。

### 4. 图层几何

#### 4.1 布局

这里只说明UIView的两个容易混淆的属性：frame和bounds

frame是相对于父视图的，以父视图左上角为(0,0)点

bounds是对于自身的，以自己的左上角为(0,0)。对于这个属性，更改bounds的坐标，实际是更改自身坐标系的原点的坐标，进而影响到“子view”的显示位置。那么还需要具体的了解的话，请参考：[**【frame和bounds的区别】**](https://www.jianshu.com/p/964313cfbdaa)

#### 4.2 锚点

UIView有一个center属性，其对应图层的postion属性。而这两个属性与anchorPoint对应的，anchorPoint对应图层的中心点。`anchorPoint`用单位坐标来描述，也就是图层的相对坐标，图层左上角是{0, 0}，右下角是{1, 1}，因此默认坐标是{0.5, 0.5}。`anchorPoint`可以通过指定x和y值小于0或者大于1，使它放置在图层范围之外。注意:当改变了`anchorPoint`，`position`属性保持固定的值并没有发生改变，但是`frame`却移动了。

#### 4.3 HitTest

##### 4.3.1 convertRect&&convertPoint

[A convertRect:B.frame  toView:C]：计算A上的B视图在C中的位置CGRect

 [A convertRect:B.frame fromView:C]：计算C上的B视图在A中的位置CGRect

[A convertPoint:B.center toView:C]：计算A上的B视图在C中的位置CGPoint

[A convertPoint:B.center fromView:C]：计算C上的B视图在A中的位置CGPoint

##### 4.3.3 containsPoint

这是CALayer的一个方法。接受一个在本图层坐标系下的`CGPoint`，如果这个点在图层`frame`范围内就返回`YES`

##### 4.3.4 -hitTest:

同样是CALayer的一个方法，接受一个`CGPoint`类型参数，而不是`BOOL`类型，它返回图层本身，或者包含这个坐标点的叶子节点图层，反之返回nil。

需要区别与UIView的`- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event`方法。

##### 4.3.5 hitTest: withEvent

对于UIView的这个方法，通常用在子视图超出了父视图的边界，但是仍要响应某时间。因此需要重写该方法，通常用下面的格式：

```objective-c
- (UIView*)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    // 如果交互未打开，或者透明度小于0.05 或者 视图被隐藏
    if (self.userInteractionEnabled == NO || self.alpha < 0.05 || self.hidden == YES)
    {
        return nil;
    }
    // 如果 touch 的point 在 self 的bounds 内
    if ([self pointInside:point withEvent:event])
    {
        NSInteger count = self.subviews.count;
        for ( int i = 0; i < count; I++)
        {
            UIView* subView = self.subviews[count - 1 - I];
            //进行坐标转化
            CGPoint coverPoint = [subView convertPoint:point fromView:self];
            // 调用子视图的 hitTest 重复上面的步骤。找到了，返回hitTest view ,没找到返回有自身处理
            UIView *hitTestView = [subView hitTest:coverPoint withEvent:event];
            if (hitTestView)
            {
                return hitTestView;
            }
        }
        return self;
    }
    return nil;
}
```

### 5. 贝塞尔曲线

#### 5.1 介绍

UIBezierPath位于UIKit框架，通过官方文档的描述知道，该类允许开发者定义一个由直线和曲线组成的路径，并运用在自定义的视图中。这个路径可以是一个矩形、圆、曲线等。贝塞尔曲线的数理知识这里不做赘述。

#### 5.2 常用属性

`CGPath：`将`UIBezierPath`类转换成`CGPath`

`currentPoint`: 当前path的位置，可以理解为path的**终点**

`lineWidth`: 线条宽度

`lineCapStyle`: 端点样式，即就是起点

`lineJoinStyle`: 连接类型，即就是终点

`flatness`: 绘线的精细程度，默认为0.6，数值越大，需要处理的时间越长

`usesEvenOddFillRule`: 判断奇偶数组的规则绘制图像,图形复杂时填充颜色的一种规则。类似棋盘

`miterLimit`: 最大斜接长度（只有在使用kCGLineJoinMiter是才有效,最大限制为10）， 边角的角度越小，斜接长度就会越大，为了避免斜接长度过长，使用lineLimit属性限制，如果斜接长度超过miterLimit，边角就会以KCALineJoinBevel类型来显示

`- setLineDash:count:phase:`为path绘制虚线，dash数组存放各段虚线的长度，count是数组元素数量，phase是起始位置

针对端点样式与连接样式的枚举如下：

```objective-c
 // lineCapStyle     // 端点类型
 kCGLineCapButt,     // 无端点
 kCGLineCapRound,    // 圆形端点
 kCGLineCapSquare    // 方形端点（样式上和kCGLineCapButt是一样的，但是比kCGLineCapButt长一点）
 
 // lineJoinStyle     // 交叉点的类型
 kCGLineJoinMiter,    // 尖角衔接
 kCGLineJoinRound,    // 圆角衔接
 kCGLineJoinBevel     // 斜角衔接
```

#### 5.3 初始化方法

```objective-c
 // 初始化方法,需要用实例方法添加线条.使用比较多,可以根据需要任意定制样式,画任何我们想画的图形.
 + (instancetype)bezierPath;
 
 // 返回一个矩形 path
 + (instancetype)bezierPathWithRect:(CGRect)rect;
 
 // 返回一个圆形或者椭圆形 path
 + (instancetype)bezierPathWithOvalInRect:(CGRect)rect;
 
 // 返回一个带圆角的矩形 path ,矩形的四个角都是圆角;
 + (instancetype)bezierPathWithRoundedRect:(CGRect)rect cornerRadius:(CGFloat)cornerRadius;
 
 // 返回一个带圆角的矩形 path , UIRectCorner 枚举值可以设置只绘制某个圆角;
 + (instancetype)bezierPathWithRoundedRect:(CGRect)rect byRoundingCorners:(UIRectCorner)corners cornerRadii:(CGSize)cornerRadii;
 
 // 返回一段圆弧,参数说明: center: 弧线中心点的坐标 radius: 弧线所在圆的半径 startAngle: 弧线开始的角度值 endAngle: 弧线结束的角度值 clockwise: 是否顺时针画弧线.
 + (instancetype)bezierPathWithArcCenter:(CGPoint)center radius:(CGFloat)radius startAngle:(CGFloat)startAngle endAngle:(CGFloat)endAngle clockwise:(BOOL)clockwise;
 
 // 用一条 CGpath 初始化
 + (instancetype)bezierPathWithCGPath:(CGPathRef)CGPath;
 
 // 返回一个反转当前路径的路径对象.(反方向绘制path)
 - (UIBezierPath *)bezierPathByReversingPath;
```

#### 5.4 路径构建

```objective-c
 - (void)moveToPoint:(CGPoint)point;
 // 以 point点 开始作为起点, 一般用`+ (instancetype)bezierPath`创建的贝塞尔曲线，先用该方法标注一个起点，再调用其他的创建线条的方法来绘制曲线
 
 // 绘制二次贝塞尔曲线的关键方法,即从path的最后一点开始添加一条线到point点
 - (void)addLineToPoint:(CGPoint)point;
 
 // 绘制二次贝塞尔曲线的关键方法,和`-moveToPoint:`配合使用. endPoint为终止点,controlPoint为控制点.
 - (void)addQuadCurveToPoint:(CGPoint)endPoint controlPoint:(CGPoint)controlPoint;
 
 // 绘制三次贝塞尔曲线的关键方法,以三个点画一段曲线. 一般和moveToPoint:配合使用.
 // 其中,起始点由`-moveToPoint:`设置,终止点位为`endPoint:`, 控制点1的坐标controlPoint1,控制点2的坐标是controlPoint2.
 - (void)addCurveToPoint:(CGPoint)endPoint controlPoint1:(CGPoint)controlPoint1 controlPoint2:(CGPoint)controlPoint2;
 
 // 绘制一段圆弧, center:原点坐标,radius:半径,startAngle:起始角度,endAngle:终止角度,clockwise顺时针/逆时针方向绘制
 - (void)addArcWithCenter:(CGPoint)center radius:(CGFloat)radius startAngle:(CGFloat)startAngle endAngle:(CGFloat)endAngle clockwise:(BOOL)clockwise;
 
 // 闭合线
 - (void)closePath;
 
 // 移除所有的点,从而有效地删除所有子路径
 - (void)removeAllPoints;
 
 // 追加指定的bezierPath到路径上
 - (void)appendPath:(UIBezierPath *)bezierPath;
 
 // 用仿射变换矩阵变换路径的所有点
 - (void)applyTransform:(CGAffineTransform)transform;
```

#### 5.5 其他方法

下列方法必须配合图形上下文进行调用。

```objective-c
 // 填充图形颜色，与[color set]配合使用
 - (void)fill;
 
 // 填充连线颜色，与[color set]配合使用
 - (void)stroke;
 
 // 填充模式, alpha 设置
 - (void)fillWithBlendMode:(CGBlendMode)blendMode alpha:(CGFloat)alpha;
 
 // 链接模式, alpha 设置
 - (void)strokeWithBlendMode:(CGBlendMode)blendMode alpha:(CGFloat)alpha;
 
 // 图形绘制超出当前路径范围,则不可见
 - (void)addClip;
```

#### 5.6 总结

贝塞尔曲线通常配合图层来使用，或者直接在自定义的视图中，重写drawRect来画寄宿图。在第6节中，会有贝塞尔出现的使用。

### 6. 专用图层

#### 6.1 分类

专用图层一共有如下几类：

CAShapeLayer：是一个通过矢量图形而不是bitmap来绘制的图层子类，通过贝塞尔曲线定义路径。

CATextLayer：文字现实图层，`CATextLayer`也要比`UILabel`渲染得快得多，支持富文本。

CATransformLayer：渲染 3D Layer层次结构。

CAGradientLayer：用来生成两种或更多颜色平滑渐变的。

CAReplicatorLayer：自动赋值subLyaer。它会绘制一个或多个图层的子图层，并在每个复制体上应用不同的变换。

CAEmitterLayer：用于绘制粒子效果，如烟花。

CAEAGLLayer：用于 Open GL ES 绘制图层。

CAScrollLayer：管理可滑动区域。

下面按经常使用的图层，进行Demo 示例。

#### 6.2 CAShaperLayer

##### 6.2.1 画板

```objective-c
#import "DrawingBoardView.h"
#import "Masonry.h"
@interface DrawingBoardView ()
@property (nonatomic, strong) UIButton *closeButton;
@property (nonatomic, strong) UIButton *cleanButton;
@property (nonatomic, strong) UIButton *backButton;
@property (nonatomic, strong) CAShapeLayer *drawLayer;
@property (nonatomic, strong) UIBezierPath *drawPath;
@property (nonatomic, copy) NSMutableArray *curPathArr;
@end
@implementation DrawingBoardView
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self setUpSubViews];
        _curPathArr = [NSMutableArray array];
    }
    return self;
}

- (void)setUpSubViews {
    [self addSubview:self.cleanButton];
    [self addSubview:self.backButton];
    [self.layer addSublayer:self.drawLayer];
    
    [self.cleanButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(-20);
        make.left.mas_equalTo(50);
        make.size.mas_equalTo(CGSizeMake(50, 30));
    }];
    
    [self.backButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(-20);
        make.right.mas_equalTo(-50);
        make.size.mas_equalTo(CGSizeMake(50, 30));
    }];
   
}
/*
 Only override drawRect: if you perform custom drawing.
 An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
     Drawing code
}
*/

#pragma mark - touch action
// 一根或者多根手指开始触摸view（手指按下）
-(void)touchesBegan:(NSSet*)touches withEvent:(UIEvent*)event {
    UITouch *touch = touches.anyObject;
    //UIBezierPath *newPath = [UIBezierPath bezierPath];
    [self.curPathArr addObject:[self.drawPath copy]];
    [self.drawPath moveToPoint:[touch locationInView:self]];
    //[self.curPathArr addObject:newPath];
}
// 一根或者多根手指在view上移动（随着手指的移动，会持续调用该方法）
-(void)touchesMoved:(NSSet*)touches withEvent:(UIEvent*)event {
    UITouch *touch = touches.anyObject;
    [self.drawPath addLineToPoint:[touch locationInView:self]];
    self.drawLayer.path = self.drawPath.CGPath;
    [self setNeedsDisplay];
}

// 一根或者多根手指离开view（手指抬起）
//-(void)touchesEnded:(NSSet*)touches withEvent:(UIEvent*)event {
//
//}

// 某个系统事件(例如电话呼入)打断触摸过程
//-(void)touchesCancelled:(NSSet*)touches withEvent:(UIEvent*)event {
//
//}

#pragma mark - getter

- (UIButton *)cleanButton {
    if (!_cleanButton) {
        _cleanButton = [self getButtonConfigWithTitle:@"清空"];
        [_cleanButton addTarget:self action:@selector(cleanButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cleanButton;
}

- (UIButton *)backButton {
    if (!_backButton) {
        _backButton = [self getButtonConfigWithTitle:@"撤回"];
        [_backButton addTarget:self action:@selector(backButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _backButton;
}

- (CAShapeLayer *)drawLayer {
    if (!_drawLayer) {
        _drawLayer = [CAShapeLayer layer];
        _drawLayer.fillColor = [UIColor clearColor].CGColor;
        _drawLayer.strokeColor = [UIColor blackColor].CGColor;
        _drawLayer.lineWidth = 6.0;
        
    }
    return _drawLayer;
}

- (UIBezierPath *)drawPath {
    if (!_drawPath) {
        _drawPath = [UIBezierPath bezierPath];
        _drawPath.lineCapStyle = kCGLineCapRound;
        _drawPath.lineJoinStyle = kCGLineJoinRound;
    }
    return _drawPath;
}

#pragma mark - button action

- (void)cleanButtonAction:(UIButton *)sender {
    [self.curPathArr removeAllObjects];
    [self.drawPath removeAllPoints];
    self.drawLayer.path = self.drawPath.CGPath;
    [self setNeedsDisplay];
}

- (void)backButtonAction:(UIButton *)sender {
    UIBezierPath *path = [self.curPathArr lastObject];
    [self.curPathArr removeLastObject];
    self.drawLayer.path = path.CGPath;
    [self.drawPath removeAllPoints];
    self.drawPath = path;
    [self setNeedsDisplay];
}

#pragma mark - other

- (UIButton *)getButtonConfigWithTitle:(NSString *)title {
    UIButton *btn = [[UIButton alloc] init];
    [btn setTitle:title forState:UIControlStateNormal];
    btn.backgroundColor = [UIColor orangeColor];
    btn.layer.cornerRadius = 10.0;
    btn.layer.shadowColor = [UIColor blackColor].CGColor;
    btn.layer.shadowRadius = 3.0;   
    return btn;
}
@end
```

### 7. 隐式动画

#### 7.1 事物

在第 1.2 中图层的能力中，大部分都是可以可做动画的属性，当它们被改变时，图层并没有立马发生改变，而是平滑的度过到新值，这便是隐式动画。隐式动画并不需要我们做什么，Core Animation通过事物和图层行为来发起一个隐式动画。

事务实际上是Core Animation用来包含一系列属性动画集合的机制，任何用指定事务去改变可以做动画的图层属性都不会立刻发生变化，而是当事务一旦提交的时候开始用一个动画过渡到新值。

事务是通过`CATransaction`类来做管理，`CATransaction`没有属性或者实例方法，并且也不能用`+alloc`和`-init`方法创建它。但是可以用`+begin`和`+commit`分别来入栈或者出栈。

任何可以做动画的图层属性都会被添加到栈顶的事务，你可以通过`+setAnimationDuration:`方法设置当前事务的动画时间，或者通过`+animationDuration`方法来获取值（默认0.25秒）。

Core Animation在每个run loop周期中自动开始一次新的事务（run loop是iOS负责收集用户输入，处理定时器或者网络事件并且重新绘制屏幕的东西），即使你不显式的用`[CATransaction begin]`开始一次事务，任何在一次run loop循环中属性的改变都会被集中起来，然后做一次0.25秒的动画。

`CATransaction`的`+begin`和`+commit`方法在`+animateWithDuration:animations:`内部自动调用，这样block中所有属性的改变都会被事务所包含。这样也可以避免开发者由于对`+begin`和`+commit`匹配的失误造成的风险。

#### 7.2 图层行为

UIView是不支持隐式动画的，因为UIView把CALayer的隐式动画给禁用了。图层的动画属性的搜索过程如下：

- 图层首先检测它是否有委托，并且是否实现`CALayerDelegate`协议指定的`-actionForLayer:forKey`方法。如果有，直接调用并返回结果。
- 如果没有委托，或者委托没有实现`-actionForLayer:forKey`方法，图层接着检查包含属性名称对应行为映射的`actions`字典。
- 如果`actions字典`没有包含对应的属性，那么图层接着在它的`style`字典接着搜索属性名。
- 最后，如果在`style`里面也找不到对应的行为，那么图层将会直接调用定义了每个属性的标准行为的`-defaultActionForKey:`方法。

UIView成为CALayer的代理后，对于`-actionForLayer:forKey`方法返回了nil，因此禁用了动画。

如果我们需要禁用自定义layer的隐式动画，可以采用：

```objective-c
[CATransaction begin];
[CATransaction setDisableActions:YES];
[CATransaction commit];
```

#### 7.3 呈现树

当改变一个图层的属性，属性值的确是立刻更新的（如果读取它的数据，你会发现它的值在你设置它的那一刻就已经生效了），但是屏幕上并没有马上发生改变。这是因为设置的属性并没有直接调整图层的外观，相反，他只是定义了图层动画结束之后将要变化的外观。

当设置`CALayer`的属性，实际上是在定义当前事务结束之后图层如何显示的模型。Core Animation扮演了一个控制器的角色，并且负责根据图层行为和事务设置去不断更新视图的这些属性在屏幕上的状态。

每个图层属性的显示值都被存储在一个叫做呈现图层的独立图层当中，他可以通过`-presentationLayer`方法来访问。这个呈现图层实际上是模型图层的复制，但是它的属性值代表了在任何指定时刻当前外观效果。换句话说，你可以通过呈现图层的值来获取当前屏幕上真正显示出来的值

呈现图层的结构称为呈现树。

### 8. 自定义动画

对于动画的时间，做了几个demo。(点击进入)[https://github.com/Be-doing/AnimationDemo/]
