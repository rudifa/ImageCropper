#  <#Title#>

based on video tutorial ZOOM AND PAN LARGE IMAGES – UISCROLLVIEW by Brian Advent

problems:

- saves a cropped image, but this does not seem to correspond to the zoomed-in view
- after a second tap (after image was saved) the scroll seems to be wrogly initialized

On `master 82d0a39` we have

- initial default image
- load image button
- loaded image looks as if in `scaleAspectFit` mode (it is fully visible), however the code does `imageView.contentMode = .center` and then rescales `scrollView.zoomScale = minScale` 
- saved image is a cutout
- on second loadImage it is displaced - like the offset is wrong
- 3rd and subsequent loads are like second

- what is the centering effect of `scaleAspectFit`?

```
UIView.ContentMode.scaleToFill     = 0  fills, aspect ratio not preserved, default
UIView.ContentMode.scaleAspectFit  = 1  aspect ratio preserved, may not fill
UIView.ContentMode.scaleAspectFill = 2  aspect ratio preserved, may clip
UIView.ContentMode.center          = 4  center the content in the view’s bounds, keeping the proportions the same.
```

