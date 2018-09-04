# UKAnimation


## Example
```
Animation(view: animView).shakeR().run()
// or 
Animation(view: animView)
    .move(to: [100,100]).stay()
    .fade(from: 1, to: 0).modify{$0?.autoreverses = true}.stay()
    .move(to: [300,400]).after(begin: 1, willGroup: true).stay()
    .shakeR(radian:10, times:4, duration:0.5).after(begin: 1.5, willGroup: true)
    .group().duration(2).modify{$0?.autoreverses = true}
    .run()
```
you can use your animation
```
Animation(view: animView).add { return /* your animation */}.run()
```

## Notice
when you use group(),  after(begin...) will set wilGroup to true before this.
