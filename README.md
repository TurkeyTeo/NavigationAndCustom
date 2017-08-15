# NavigationAndCustom

- 自定义状态栏
- 自定义侧滑返回手势
- 监听UITabBarItem点击事件
- 使用UIAppearance协议设置属性


大家都知道，对于常规的UI，我们可以使用 TNV (UITabBarController -> NavigationController -> ViewController) 架构去搭建项目框架


### TabBarController：

**UITabBarController**为应用管理了多个顶层的按钮栏和转换视图，使用的时候需要将其视图添加到视图层次结构中，然后依次添加顶级视图控制器，如果在选项卡栏控制器中添加了大于五个视图控制器，则只显示前四个控制器。其余部分将在自动生成的更多项下访问。属性中有**viewControllers**，是viewController的集合； 一个** UITabBar **对象；还有一个**UITabBarControllerDelegate**代理对象，代理方法就不一一列举了，经常用到的有：

- `- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController NS_AVAILABLE_IOS(3_0);`当返回false时保留之前的tab页面，当返回值是 true 时，激活当前选中的 tab 页面。

- `- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController;`

  ​



#### UITabBar

- **items**：一个 UITabBarItem 列表，即每一个 tab 按钮对象组成的列表。

- **selectedItem**：当前被选中的 TabBarItem。

- **tintColor**：覆盖被选中的 TabBarItem 图片的颜色。（默认为蓝色。就是选中时图标的颜色。）

- **barTintColor**：整个 TabBar 的背景颜色。

- **UITabBarDelegate代理对象**：

  - `-(void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item;` // called when a new view is selected by the user (but not programatically)

  - `-(void)tabBar:(UITabBar *)tabBar willBeginCustomizingItems:(NSArray<UITabBarItem *> *)items __TVOS_PROHIBITED; `                    // called before customize sheet is shown. items is current item list

    ...

    ​

#### UITabBarItem

- **selectedImage**：TabBarItem 被选中时显示的图片，默认和未选中状态图片一样。
- **badgeValue**：右上角显示标记，常用于显示未读数，默认为nil



#### UIBarItem

是一个抽象类，主要是使用其子类UIBarButtonItem和UITabBarItem。他遵循了UIAppearance协议，包括title，image，imageInsets等属性



#### UIApearance

实际上是一个协议（Protocol），我们可以用它来获取一个类的外观代理（Appearance Proxy）。该协议需实现这几个方法：

- +(instancetype)appearance;
- +(instancetype)appearanceWhenContainedInInstancesOfClasses:(NSArray<Class <UIAppearanceContainer>> *)containerTypes NS_AVAILABLE_IOS(9_0);

UIAppearanceContainer是用于Class实现的协议，通常是ViewController，对于需要支持使用 appearance 来设置的属性，在属性后增加 `UI_APPEARANCE_SELECTOR` 宏声明。每一个实现 UIAppearance 协议的类，都会有一个 _UIApperance 实例，保存着这个类通过 appearance 设置属性的 invocations，在该类被添加或应用到视图树上的时候，它会检查并调用这些属性设置。这样就实现了让所有该类的实例都自动统一属性。

##### 注意事项

- 使用UIAppearance设置UI效果最好采用全局的设置，在所有界面初始化前开始设置。对于在使用UIAppearance之前已经添加到界面上的控件，则没有效果。

- 对于自定义的UI控件，使用UIAppearance无法直接改变UI控件的子控件。

  
***


### UINavigationController：

UINavigationController管理堆栈视图控制器和一个导航栏，它用来组织有层次关系的视图。如果一个navigation controller是内嵌在 tabbar controller中，他会使用堆栈底部的view controller 的标题和工具栏属性。

子控制器通过pop方法从栈顶移除，先销毁的是子控制器本身，然后子控制器里面的View才被销毁，因为子控制器是持有View的。

`- (instancetype)initWithRootViewController:(UIViewController *)rootViewController; `// Convenience method pushes the root view controller without animation.实际上是调用导航控制器的push方法。

当导航控制器通过push，pop或者设置视图控制器的堆栈显示了一个新的顶部控制器时会调用UINavigationControllerDelegate的代理方法。

`- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated;`

`- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated;`

...



#### UINavigationBar

最典型的用法就是放在屏幕顶端，包含着各级视图的导航按钮。它主要的几个属性是左按钮（返回按钮）、中心标题，以及可选的右按钮（实际上UINavigationBar并没有这些属性，其实是使用到其中的UINavigationItem）



#### UINavigationItem

- **title**：显示在顶端堆栈的标题，默认为nil

- **titleView**：自定义视图时使用

- **backBarButtonItem**：子导航项的后退按钮

每个视图控制器的导航项元素由所在视图控制器的navigationItem管理



#### UIBarButtonItem

同样继承自UIBarItem，是专门放在UIToolbar/ UINavigationBar上的控件，具有按钮的行为，有许多初始化的方法，包括title，image或者完全customView的。



### UIStatusBar:

**前景部分**：指的显示电池、时间等部分；

**背景部分**：就是显示黑色或者图片的背景部分；

***

#### 一些常用的Tip：

- 设置NavigationBar背景色：
  `[[UINavigationBar appearance] setBarTintColor:[UIColor whiteColor]];`


- 设置TabBar字体颜色：   

  ` [[UITabBar appearance] setTintColor:[UIColor yellowColor]];`
  等价于拿到tabBarItem设置`[item setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor yellowColor]} forState:UIControlStateSelected];`

- 设置TabBar样式（白色毛玻璃还是黑色毛玻璃效果）：
  `[[UITabBar appearance] setBarStyle:UIBarStyleBlack];`

- 设置状态栏颜色：

  ```objective-c
  UIView *statusBarView = [[UIView alloc] initWithFrame:CGRectMake(0, -20, self.view.bounds.size.width, 20)];
  statusBarView.backgroundColor = [UIColor yellowColor];
  [self.navigationController.navigationBar addSubview:statusBarView];
  ```

  同样用此方法也可改变状态栏颜色：`self.navigationController.navigationBar.barTintColor = [UIColor greenColor];`

- 改变导航栏的字体颜色：

  `    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor redColor]}];`

- 改变导航栏字体大小：
  `    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor redColor],NSFontAttributeName:[UIFont systemFontOfSize:22]}];`

- 设置导航栏返回图标：

  ```objective-c
  	UIButton * leftBtn = [UIButton buttonWithType:UIButtonTypeSystem];
      leftBtn.frame = CGRectMake(0, 0, 25,25);
      [leftBtn setBackgroundImage:[UIImage imageNamed:@"icon_back"] forState:UIControlStateNormal];
      [leftBtn addTarget:self action:@selector(XXX:) forControlEvents:UIControlEventTouchUpInside];
      UIBarButtonItem * leftBarBtn = [[UIBarButtonItem alloc]initWithCustomView:leftBtn];
      //创建UIBarButtonSystemItemFixedSpace
      UIBarButtonItem * spaceItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
      //将宽度设为负值
      spaceItem.width = -15;
      //将两个BarButtonItem都返回给NavigationItem
      self.navigationItem.leftBarButtonItems = @[spaceItem,leftBarBtn];
  ```

- 使用UIApearance设置全局样式：

  比如添加圆角属性：

  ```objective-c
  @property (nonatomic, assign) CGFloat radios UI_APPEARANCE_SELECTOR;
  ```

  在.m中：

  ```objective-c
  - (void)setRadios:(CGFloat)radios{
      _radios = radios;
      self.imageV.layer.cornerRadius = radios;
      self.imageV.layer.masksToBounds = YES;
  }
  ```

  在添加前：

  ```objective-c
  //    设置TableViewCell的圆角
      [TableViewCell appearance].radios = 4;
  ```

- 如果需要定制UITabBarController，需要自己继承然后去实现他的代理方法，比如如果需要添加一个点击同一个UITabBarItem时做刷新操作或者自定义操作，则可以在`- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item`该代理方法中判断是否同一个item，然后发送d对应通知去通知其他ViewController

- 如果需要自定义push或者pop操作，则可以自定义手势，或者自己去实现UIViewControllerAnimatedTransitioning协议添加转场动画，需要实现2个代理方法：

  ```objective-c
  - (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext;
  ```

  ```objective-c
  - (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext;
  ```

  或者使用runtime实现，具体可查看[FDFullscreenPopGesture](https://github.com/forkingdog/FDFullscreenPopGesture) 以及雨神的[iOS利用Runtime自定义控制器POP手势动画](http://www.jianshu.com/p/d39f7d22db6c)

- 在plist中设置status bar 的`Status bar is initially hidden`属性为YES，启动时会隐藏状态栏，（**注意：当 `Status bar is initially hidden` 设置为 `NO` 时，不管 `View controller-based status bar appearance` 设置为 `NO` 还是 `YES` ，都是无效的，只有 `Status bar is initially hidden` 设置为 `YES` 的时候， `View controller-based status bar appearance` 才生效**）

- 在plist中设置`View controller-based status bar appearance`属性为NO，会全局隐藏状态栏。 —>   等价于在在 `AppDelegate` 中代码实现`[UIApplication sharedApplication].statusBarHidden = YES;`（**注意：如果是通过代码实现状态栏的隐藏，必须在 Info.plist 文件中添加 `View controller-based status bar appearance` ，并且必须设置为 `NO` ，否则代码将不会有任何效果，而且代码只能隐藏 所有UIViewController 中的状态栏，不能隐藏在 LunchScreen时的状态栏。**）

- 在当期UIViewController隐藏状态栏，可以通过在 `Info.plist` 文件中添加 `View controller-based status bar appearance` 属性，并设置为 `YES`。然后在对应的UIViewController中添加如下代码：

  ```objective-c
  - (BOOL)prefersStatusBarHidden {
      return YES;
  }
  ```

- 如果想要单独设置状态栏颜色，可以使用kvc获取私有属性，设置方法如下：

  ```objective-c
  /**
   设置状态栏背景颜色
   @param color 设置颜色
   */
  - (void)setStatusBarBackgroundColor:(UIColor *)color {

      UIView *statusBar = [[[UIApplication sharedApplication] valueForKey:@"statusBarWindow"] valueForKey:@"statusBar"];
      if ([statusBar respondsToSelector:@selector(setBackgroundColor:)]) {
          statusBar.backgroundColor = color;
      }
  }
  ```

- 通过代码局部设置状态栏的文字颜色

  `self.navigationController.navigationBar.barStyle = UIBarStyleBlack;`

  ​
