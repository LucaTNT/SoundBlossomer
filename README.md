SoundBlossomer
==============

This simple utility lets you manage your [Soundflower](http://cycling74.com/products/soundflower/) audio interfaces easily and effectively.
It also takes care of unloading and reloading Soundflower's kext to apply your changes.

### Usage
Just download the .app and run it, it should be pretty easy to get started. Or if you're a real nerd you can download the entire Xcode project and compile it yourself, how cool is that?

### How it works
Basically, it reads Soundflower's *Info.plist* file, checks for existing audio interfaces and allows you to edit, add or remove them.
Once you're done, it can either write the plist back and reload Soundflower's kext to apply your changes, or just save the plist without reloading.

### License
Soundblossomer is BSD-licensed - you can do pretty much whatever you want with it.