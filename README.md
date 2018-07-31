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

ba06825: at last we have same behavior for scroll view btw initial image and loaded image.

tentative_4: cropping looks plausible, but it is problematic for a large image (4288,2848)
semms to be related to 
croppedImage scrollView.size=(375.0, 375.0) scrollView.offset=(1628.5, 2006.5) zoomScale=1.0
2018-07-28 22:50:44.747878+0200 ImageCropper[41456:23353561] imageBlockSetCreate:829: *** buffer height mismatch: rect:{0,1920,4288,768}  size:{4288,2848}

Look at /GitHub/iOS/-aatish-r-ImageCropper - it uses a different approach to cropping 

2018_07_31

- cropping still not correctly aligned?
- make sure that cropped view has same aspect ratio as the scroll view!

