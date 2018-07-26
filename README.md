#  <#Title#>

based on video tutorial ZOOM AND PAN LARGE IMAGES – UISCROLLVIEW by Brian Advent

problems:

- saves a cropped image, but this does not seem to correspond to the zoomed-in view
- after a second tap (after image was saved) the scroll seems to be wrogly initialized

On `master 82d0a39` we have

- initial default image
- load image button
- loaded image in `scaleAspectFit` mode (fully visible)
- saved image is a cutout
- on second loadImage it is displaced - like the offset is wrong
