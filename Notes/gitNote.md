Error: error: RPC failed; curl 18 transfer closed with 9776169 bytes remaining to read
fatal: The remote end hung up unexpectedly
fatal: early EOF
fatal: index-pack failed

文件太大导致，分次pull

First, turn off compression:

git config --global core.compression 0
Next, let's do a partial clone to truncate the amount of info coming down:

git clone --depth 1 <repo_URI>
When that works, go into the new directory and retrieve the rest of the clone:

git fetch --unshallow
or, alternately,

git fetch --depth=2147483647
Now, do a regular pull:

git pull --all
I think there is a glitch with msysgit in the 1.8.x versions that exacerbates these symptoms, so another option is to try with an earlier version of git (<= 1.8.3, I think).






