#!/bin/sh

# Mirror files from tuhs.org

BASEURL=https://www.tuhs.org/Archive/Distributions
BASEDIR=mirror

URLS='
Other/OS_Course/v6/dist.tap
UCB/2BSD/2.11BSD-patch481/2.11BSD-481-simh-dist.tap
UCB/2BSD/2.11BSD/Patches/482
UCB/2BSD/2.11BSD/Patches/483
UCB/2BSD/2.11BSD/Patches/484
UCB/2BSD/2.11BSD/Patches/485
UCB/2BSD/2.11BSD/Patches/486
UCB/2BSD/2.11BSD/Patches/487
UCB/2BSD/2.11BSD/Patches/488
UCB/2BSD/2.11BSD/Patches/489
UCB/2BSD/2.11BSD/Patches/490
UCB/2BSD/2.11BSD/Patches/491
UCB/2BSD/2.11BSD/Patches/492
UCB/2BSD/2.11BSD/Patches/493
UCB/2BSD/2.11BSD/Patches/494
UCB/2BSD/2.11BSD/Patches/495
UCB/2BSD/2.11BSD/Patches/496
UCB/2BSD/2.11BSD/Patches/497
UCB/2BSD/2.11BSD/Patches/498
UCB/2BSD/2.11BSD/Patches/499
'

echo "$URLS" | while read -r path; do
    [ -z "$path" ] && continue
    mkdir -p "$(dirname "$BASEDIR/$path")"
    wget -O "$BASEDIR/$path" "$BASEURL/$path" </dev/null
done

find "$BASEDIR" -type f ! -name SHA256SUMS -exec sha256sum {} + > SHA256SUMS
