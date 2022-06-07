# TODO

## ModuleNotFoundError: No module named 'dvc'

```shell
/home/user # docker run -it <id> sh
```

Error

```python
Traceback (most recent call last):
  File "/home/user/.local/bin/dvc", line 5, in <module>
    from dvc.cli import main
ModuleNotFoundError: No module named 'dvc'
```

Warning

```shell
Defaulting to user installation because normal site-packages is not writeable
``

DVC location

```shell
which dvc #/home/user/.local/bin/dvc
```

DVC content

```python
#!/usr/local/bin/python3
# -*- coding: utf-8 -*-
import re
import sys
from dvc.cli import main
if __name__ == '__main__':
    sys.argv[0] = re.sub(r'(-script\.pyw|\.exe)?$', '', sys.argv[0])
    sys.exit(main())
```

Maybe PATH to `.local/lib/python3.7/site-packages/dvc`?


## local_serve.sh

Local image repo to use dvc with k8s

## Build with --squash or --squash-all

Combine layers into one.

## Append '$LDFLAGS' for pygit2 used by dvc

Append '$LDFLAGS' to append existing Flags.
Using triggers error 'cannot find $LDFLAGS: No such file or directory'
