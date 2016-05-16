# OCSliderViewController

支持iOS7及以上

OCSliderViewController是一种containerViewController，样式如下图所示，使用时，只需添加子控制器即可。

演示:
![Aaron Swartz](https://github.com/buluolemaodou/OCSliderViewController/raw/master/source/OCSliderViewControllerImage.gif)

使用:
    OCSliderViewController *svc = [[OCSliderViewController alloc] init];

    ViewController *vc = [[ViewController alloc] init];
    vc.ocSliderBarTitle = @"首页";

    ViewController *vc2 = [[ViewController alloc] init];
    vc2.ocSliderBarTitle = @"我的";

    ViewController *vc3 = [[ViewController alloc] init];
    vc3.ocSliderBarTitle = @"其它";

    ViewController *vc4 = [[ViewController alloc] init];
    vc4.ocSliderBarTitle = @"新增";

    ViewController *vc5 = [[ViewController alloc] init];
    vc5.ocSliderBarTitle = @"购买";

    ViewController *vc6 = [[ViewController alloc] init];
    vc6.ocSliderBarTitle = @"增加";

    svc.childViewControllers = @[vc,vc2,vc3,vc4,vc5,vc6];

如果想要自定义子控制器切换时的动画，请参考苹果官方文档中自定义转场动画章节，按照文档中描述步骤即可。（请注意，需要用OCSliderVCInteractiveDrive类替换UIKit的UIPercentDrivenInteractiveTransition类）
转场中断时，如果需要复原动画的时间曲线，请自行实现。

