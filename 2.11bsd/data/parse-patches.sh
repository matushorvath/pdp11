#!/bin/sh -v

set -e

sed -n '89,182p' < 482.txt > data/482.sh
sed -n '205,$p' < 482.txt > data/482.patch

printf '#!/bin/sh -v\n\n' > data/483.sh
sed -n '94,106p' < 483.txt >> data/483.sh
sed -n '119,$p' < 483.txt > data/483.patch

printf '#!/bin/sh -v\n\n' > data/484.sh
sed -n '169,230p' < 484.txt >> data/484.sh
sed -n '237,$p' < 484.txt > data/484.patch

printf '#!/bin/sh -v\n\n' > data/485.sh
sed -n '29,31p' < 485.txt >> data/485.sh
sed -n '46,$p' < 485.txt > data/485.patch

printf '#!/bin/sh -v\n\n' > data/486.sh
sed -n '164,166p' < 486.txt >> data/486.sh
sed -n '181,$p' < 486.txt > data/486.patch

printf '#!/bin/sh -v\n\n' > data/487.sh
sed -n '121,150p' < 487.txt >> data/487.sh
sed -n '161,$p' < 487.txt > data/487.patch

printf '#!/bin/sh -v\n\n' > data/488.sh
sed -n '102,104p' < 488.txt >> data/488.sh
sed -n '113,141p' < 488.txt >> data/488.sh
sed -n '152,$p' < 488.txt > data/488.patch

printf '#!/bin/sh -v\n\n' > data/489.sh
sed -n '96,124p' < 489.txt >> data/489.sh
sed -n '137,$p' < 489.txt > data/489.patch

printf '#!/bin/sh -v\n\n' > data/490.sh
sed -n '80,83p' < 490.txt >> data/490.sh
sed -n '94,$p' < 490.txt > data/490.patch

printf '#!/bin/sh -v\n\n' > data/491.sh
sed -n '72,84p' < 491.txt >> data/491.sh
sed -n '99,$p' < 491.txt > data/491.patch

printf '#!/bin/sh -v\n\n' > data/492.sh
sed -n '123,141p' < 492.txt >> data/492.sh
sed -n '152,$p' < 492.txt > data/492.patch

printf '#!/bin/sh -v\n\n' > data/494.sh
sed -n '32,34p' < 494.txt >> data/494.sh
sed -n '48,$p' < 494.txt > data/494.patch

printf '#!/bin/sh -v\n\n' > data/495.sh
sed -n '45,51p' < 495.txt >> data/495.sh
sed -n '62,$p' < 495.txt > data/495.patch

printf '#!/bin/sh -v\n\n' > data/496.sh
sed -n '99,109p' < 496.txt >> data/496.sh
sed -n '120,$p' < 496.txt > data/496.patch

printf '#!/bin/sh -v\n\n' > data/497.sh
sed -n '43,51p' < 497.txt >> data/497.sh
sed -n '69,$p' < 497.txt > data/497.patch
# This should also update /VERSION

printf '#!/bin/sh -v\n\n' > data/498.sh
sed -n '109,138p' < 498.txt >> data/498.sh
sed -n '149,$p' < 498.txt > data/498.patch

chmod a+x data/*.sh
