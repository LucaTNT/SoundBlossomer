SoundBlossomer
==============

This simple utility lets you manage your [Soundflower](http://cycling74.com/products/soundflower/) audio interfaces easily and effectively.
It also takes care of unloading and reloading Soundflower's kext to apply your changes.
You can find the binary of the latest version in the [releases page](https://github.com/LucaTNT/SoundBlossomer/releases).

### Usage
Just download the .app and run it, it should be pretty easy to get started. Or if you're a real nerd you can download the entire Xcode project and compile it yourself, how cool is that?

### How it works
Basically, it reads Soundflower's *Info.plist* file, checks for existing audio interfaces and allows you to edit, add or remove them.
Once you're done, it can either write the plist back and reload Soundflower's kext to apply your changes, or just save the plist without reloading.

### Note for OS X Yosemite users
OS X 10.10 Yosemite now prevents unsigned Kexts from being loaded. Changing Soundflower's Info.plist file like SoundBlossomer does, breaks the signature and thus the Kext fails to load.
As a workaround, you can enable unsigned Kexts by running

    sudo nvram boot-args="kext-dev-mode=1"

and then reboot.

### License
Soundblossomer is BSD-licensed - you can do pretty much whatever you want with it.
