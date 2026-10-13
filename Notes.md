Publish
-------

- Find a way to manage version numbers independently for Unix v6 and 2.11BSD
- Consider pushing images when publishing the release:
  - Tag creates a release like in shadow-kvm
  - Publishing a release triggers actions to publish to GitHub


TODO
----

- Add tests to verify the image works when building a PR
- In parse-patches.sh add /bin/sh -ve to BSD shell scripts where possible
- Error checking for unix-v6
- https://www.tuhs.org/Archive/Distributions/Research/Utah_v4/
- https://www.tuhs.org/Archive/Distributions/DEC/
