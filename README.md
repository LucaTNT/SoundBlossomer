SoundBlossomer
==============

This simple utility lets you manage your [Soundflower](http://cycling74.com/products/soundflower/) audio interfaces easily and effectively.
It also takes care of unloading and reloading Soundflower's kext to apply your changes.
You can find the binary of the latest version in the [releases page](https://github.com/LucaTNT/SoundBlossomer/releases).

### Deprecation notice
This project is no longer maintained, as I no longer need SoundBlossomer. I rely on Rogue Amoeba's excellent [Loopback app](https://rogueamoeba.com/loopback/), and I suggest you do the same, it's way more stable and polished than Soundflower+SoundBlossomer ever were.

### Usage
Just download the .app and run it, it should be pretty easy to get started. Or if you're a real nerd you can download the entire Xcode project and compile it yourself, how cool is that?

### How it works
Basically, it reads Soundflower's *Info.plist* file, checks for existing audio interfaces and allows you to edit, add or remove them.
Once you're done, it can either write the plist back and reload Soundflower's kext to apply your changes, or just save the plist without reloading.

### Note for OS X Yosemite users
OS X 10.10 Yosemite now prevents unsigned Kexts from being loaded. Soundflower's is not signed at the moment, so it won't load with OS X's default settings.
As a workaround, you can enable unsigned Kexts by running

    sudo nvram boot-args="kext-dev-mode=1"

and then reboot.

### License
Soundblossomer is BSD-licensed - you can do pretty much whatever you want with it.
