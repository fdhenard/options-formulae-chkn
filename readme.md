# options-formulae-chkn #

## first time

- install dependencies of this project
    - `$ cd dev/repos/options-formulae-chkn/`
    - `chicken-install`
- `$ chicken-install system`

## To run in interpreter

- `$ csi`
- `#;1> (use system)`
- `#;2> (load "options-formulae-chkn.system")`
- `#;3> (load-system options-formulae-chkn)`
- `#;4> (import (prefix some-main-module smm:))`
- `#;5> (smm:do-something)`

### To run test script

- `$ csi`
- `#;1> ,l test-script.scm`
