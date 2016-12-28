# Docker run basic option
* `-t`
* `-i`
* `--rm`
* `-d`
# CPU and memory prioritization and limitations
TODO

# Overriding dockerfile default
We can override Dockerfile defaults when launching `docker run` commands  
for example, if an entrypoint is set in the Dockerfile, we can override it as  
follow :  
`docker run -ti --entrypoint=/bin/sh user/image`  
We can also change the user via the `-u` option:  
`docker run --rm -ti -u=nobody ubuntu bash`
Adding environment is very easy, just use the `-e` option :
`docker run --rm -ti -e VAR1=HelloWorld -e VAR2=foo`
or, if there are a lot of variables to add, we can add them into a basic file, with key and value, and add it as follow :
`docker run --rm -ti --env-file=path_to_file`

# Docker volumes and mounts
