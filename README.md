# MLNavigationBarTransition [中文介绍](https://github.com/molon/MLNavigationBarTransition#中文介绍)
## Screenshot
![MLNavigationBarTransition](https://raw.githubusercontent.com/molon/MLNavigationBarTransition/master/snapshot.gif)

## Introduction

Inspired by [KMNavigationBarTransition](https://github.com/MoZhouqi/KMNavigationBarTransition). First of all, this statement and thanks. But due to individual details can not meet personal preferences, with a completely different violent way to re-build a wheel.

- Only support for iOS7+.
- If two pages have different navigation bar background effect, an overlay effect not like official will appear.
- If an overlay effect appears or navigation bar's `alpha` less than `1.0f`, the shadow border will certainly be displayed in the middle. Regardless of whether the ` translucent` of the navigation bar is `YES`.
- If the two pages have exactly the same navigation bar background effect, official effect will appear.
- If backButtons of two pages have different `tintColor`, a fade effect not like official will appear.
- Fixed a bug that caused flicker when two pages have different `barTintColor` on iOS 8.2 or below.

### Addition Tips

- Please do not set `navigationBarHidden` to` YES`(it has bugs). If you want to hide the navigation bar, use `self.navigationBar.ml_backgroundView.alpha = 0.0f;`
- If you want to hide the bottom shadow of the navigation bar, use `self.navigationController.navigationBar.ml_backgroundShadowView.hidden = YES`
- Keep `translucent` as` YES` as far as possible, because if it is `NO`, the head of the page in the navigator will remain under the navigation bar, so if the navigation bar's `alpha` less than `1.0f`, will reveal views below, resulting in abnormal results.

## 中文介绍
一直想做个类似微信转场里导航条效果的库，并且一直苦于SDK里`navigationBarHidden`为`YES`时候的BUG没能良好解决。
在发现了[KMNavigationBarTransition](https://github.com/MoZhouqi/KMNavigationBarTransition)之后得到灵感，首先对此表示声明以及感谢，但是由于个别细节无法满足个人喜好，就用了完全不一样的比较暴力的方式重新造了个轮子。

- 只支持iOS7+
- 如果两个页面有不一样的导航条背景效果的话，转场时候将会出现导航条叠加的效果。(即使只有底部阴影条显示透明度不同这种细节，也会被认作不同)
- 如果一个叠加效果显示了或者导航条背景有透明度，中间必定会显示阴影条，无论导航条的`translucent`是否为`YES`。
- 如果两个页面具有完完全全一模一样的导航条背景效果，使用原生转场效果。
- 如果两个页面的导航条返回按钮有不一样的`tintColor`，转场时候会有一个过渡效果，不会像原生那样立即就改变为目的`tintColor`。
- 在iOS 8.2或以下系统，如果两个页面的`barTintColor`不一样之后会出现闪烁现象的BUG修复。
- 对子页面的`view`没有任何侵入。

### 一些提示
- 请不要设置`navigationBarHidden`为`YES`，如果想隐藏导航条，请使用`self.navigationBar.ml_backgroundView.alpha = 0.0f;`
- 如果想要隐藏导航条底部阴影条，请使用`self.navigationController.navigationBar.ml_backgroundShadowView.hidden = YES`
- 尽量让`translucent`保持为`YES`，因为它若为`NO`，则导航器里的页面的头部会保持在导航条之下，这样的话，若对导航条背景设置透明度的话，就会透出下面的view，产生异常效果。
