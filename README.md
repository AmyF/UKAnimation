# UKAnimation
CoreAnimation的链式调用的封装

## Pod
pod 'UKAnimation'

## Example
```
UKAnimation(animView).shakeR().run()
```
或者你可以组合多个动画
```
UKAnimation(animView)
    .move(to: [100,100]).stay()
    .fade(from: 1, to: 0).modify{$0?.autoreverses = true}.stay()
    .move(to: [300,400]).after(begin: 1, willGroup: true).stay()
    .shakeR(radian:10, times:4, duration:0.5).after(begin: 1.5, willGroup: true)
    .group().duration(2).modify{$0?.autoreverses = true}
    .run()
```

## Usage
使用的时候，如果不满意当前 _CAAnimation_ ，你可以使用 _modify<A>(aniamtion handler: (A?) -> Swift.Void)_ 去修改最后一个添加的动画
```
UKAnimation./* animation */.modify{$0?.autoreverses = true}.run()
```
UKAnimation也提供了 _forEach_ 去遍历每一个 _animation_
    
_handler(begin: Item.Handler? = default, end: Item.Handler? = default)_ 可以对最后一个 _animation_ 设置回调

除了自带的几个小动画，你也可以通过 _extension_ 去添加动画
```
extension UKAnimation {
// code your animation
} 
```
或者 _add(animation: CAAnimation)_ 
```
UKAnimation(animView).add { return /* your animation */}.run()
```

## Notice
所有的修改、合并、监听操作都是针对最后一个添加的 _animation_
当你使用 _after(begin offset: CFTimeInterval, willGroup: Bool = default)_ 的时候
你需要确定之后是否会将这个 _animation_ 加入一个 _CAAnimationGroup_ 否则动画会出现紊乱

## UKNoAnimation
你可以通过这个类来制作 _CAAnimation_ 或者一堆 _CAAnimation_
```
let animations: [CAAnimation] = UKNoAnimation().fade(from: 1, to: 0).allAnimation()
let animation: CAAnimation? = UKNoAnimation().fade(from: 1, to: 0).animation(by:"name")
```

