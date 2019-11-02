#!/bin/bash

#
#  movePlistAndReloadSoundflower.sh
#  SoundBlossomer
#
#  Created by Luca Zorzi on 06/10/13.
#  Licensed under the BSD License
#  Copyright (c) 2013 Luca Zorzi. All rights reserved.
#

# Move Plist (tmp file provided as script arguement)
mv $1 /Library/Extensions/Soundflower.kext/Contents/Info.plist

# Correct ownership and permissions
chown root:wheel /Library/Extensions/Soundflower.kext/Contents/Info.plist
chmod 644 /Library/Extensions/Soundflower.kext/Contents/Info.plist

# Unload (twice, it is often needed) Soundflower's kext and then reload it
kextunload /Library/Extensions/Soundflower.kext
kextunload /Library/Extensions/Soundflower.kext
kextload /Library/Extensions/Soundflower.kext
