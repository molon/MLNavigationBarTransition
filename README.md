# MLNavigationBarTransition

Inspired by [KMNavigationBarTransition](https://github.com/MoZhouqi/KMNavigationBarTransition). But using a very different implementation.
  
**The libirary uses a lot of unpublish apis(not private). But it's ok in my experience. If you are worried, please do not use it.**

- Only support for iOS7+.
- If two pages have different navigation bar background effect, an overlay effect not like official will appear.
- If the two pages have exactly the same navigation bar background effect, official effect will appear.
- If backButtons of two pages have different `tintColors`, a fade effect not like official will appear.
- If an overlay effect appears, the shadow border will certainly be displayed in the middle.
- Fixed a bug that caused flicker when two pages have different `barTintColor` on iOS 8.2 or below.

![MLNavigationBarTransition](https://raw.githubusercontent.com/molon/MLNavigationBarTransition/master/snapshot.gif)
