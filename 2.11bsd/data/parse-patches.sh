#!/bin/sh -v

set -e

sed -n '89,182p' < 482 > data/482.sh
sed -n '205,$p' < 482 > data/482.patch

printf '#!/bin/sh -ve\n\n' > data/483.sh
sed -n '94,106p' < 483 >> data/483.sh
sed -n '119,$p' < 483 > data/483.patch

printf '#!/bin/sh -ve\n\n' > data/484.sh
sed -n '169,230p' < 484 >> data/484.sh
sed -n '237,$p' < 484 > data/484.patch

printf '#!/bin/sh -ve\n\n' > data/485.sh
sed -n '29,31p' < 485 >> data/485.sh
sed -n '46,$p' < 485 > data/485.patch

printf '#!/bin/sh -ve\n\n' > data/486.sh
sed -n '164,166p' < 486 >> data/486.sh
sed -n '181,$p' < 486 > data/486.patch

printf '#!/bin/sh -ve\n\n' > data/487.sh
sed -n '121,150p' < 487 >> data/487.sh
sed -n '161,$p' < 487 > data/487.patch

printf '#!/bin/sh -ve\n\n' > data/488.sh
sed -n '102,104p' < 488 >> data/488.sh
sed -n '113,141p' < 488 >> data/488.sh
sed -n '152,$p' < 488 > data/488.patch

printf '#!/bin/sh -ve\n\n' > data/489.sh
sed -n '96,124p' < 489 >> data/489.sh
sed -n '137,$p' < 489 > data/489.patch

printf '#!/bin/sh -ve\n\n' > data/490.sh
sed -n '80,83p' < 490 >> data/490.sh
sed -n '94,$p' < 490 > data/490.patch

printf '#!/bin/sh -ve\n\n' > data/491.sh
sed -n '72,84p' < 491 >> data/491.sh
sed -n '99,$p' < 491 > data/491.patch

printf '#!/bin/sh -ve\n\n' > data/492.sh
sed -n '123,141p' < 492 >> data/492.sh
sed -n '152,$p' < 492 > data/492.patch

printf '#!/bin/sh -ve\n\n' > data/493.sh
sed -n '73,79p' < 493 >> data/493.sh
sed -n '119,$p' < 493 > data/493.patch

printf '#!/bin/sh -ve\n\n' > data/494.sh
sed -n '32,34p' < 494 >> data/494.sh
sed -n '48,$p' < 494 > data/494.patch

printf '#!/bin/sh -ve\n\n' > data/495.sh
sed -n '45,51p' < 495 >> data/495.sh
sed -n '62,$p' < 495 > data/495.patch

printf '#!/bin/sh -ve\n\n' > data/496.sh
sed -n '99,109p' < 496 >> data/496.sh
sed -n '120,$p' < 496 > data/496.patch

printf '#!/bin/sh -ve\n\n' > data/497.sh
sed -n '43,51p' < 497 >> data/497.sh
sed -n '69,$p' < 497 > data/497.patch
# This should also update /VERSION

# TODO this currently fails with /bin/sh -ve
printf '#!/bin/sh -v\n\n' > data/498.sh
sed -n '109,138p' < 498 >> data/498.sh
sed -i 's/YOUR_KERNEL_BUILD_DIRECTORY/SIMH/g' data/498.sh
sed -n '149,$p' < 498 > data/498.patch

printf '#!/bin/sh -ve\n\n' > data/499.sh
sed -n '367,380p' < 499 >> data/499.sh
# don't build /usr/src/games/warp
# TODO fix /usr/src/games/warp (run Makefile.SH before patching)
echo 'mv /usr/src/games/Makefile /usr/src/games/Makefile.orig' >> data/499.sh
echo 'sed "s/warp //" < /usr/src/games/Makefile.orig > /usr/src/games/Makefile' >> data/499.sh
sed -n '426,428p' < 499 >> data/499.sh
sed -n '448,$p' < 499 > data/499.shar

# /usr/src/games/warp/Makefile doesn't exist, but 499.shar tries to patch it
# workaround by removing corresponding part of the patch
# TODO fix /usr/src/games/warp (run Makefile.SH before patching)
sed -i '11048,11070d' data/499.shar

# /etc/disktab is installed from /usr/src/etc/disktab, before make install
# it contains an older version that fails the patch
# TODO install patched /usr/src/etc/disktab to /etc/disktab, perhaps before
sed -i '4836,4931d' data/499.shar

chmod a+x data/*.sh
