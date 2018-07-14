# KaliDockerFile
My evolving dockerfile for building a light, narrow-purpose Kali Linux container on a Windows 10 endpoint  

-----------------
Using the Dockerfile here, build the image using docker build.  
The naming convention for images is myname/imagename, e.g. the kali image is called mykalilinux/kali-linux-docker.  
Give the image a name using the -t option.  

```
docker build -t myname/imagename path/to/Dockerfile  
```

After the build is completed, run the image.  
The -ti options indicate that we want a tty and to keep STDIN open for interactive processes.  
Both apply if we’re running a shell, and the -p option indicates we want to expose the provided ports.  
The -v (volume) option in the below case indicates that we want to map the /root/clients folder on the host to the /clients folder in the container.  

```
docker run -ti -p 80:80 -p 443:443 -v /root/clients:/clients myname/imagename  
```

You should be ready for work in an environment you understand now.  

If you get back to a given PC and forgot the status of your docker container, see if it is running with:  

```
docker ps  
```

If you get back to a given PC and forgot the name of a given Docker image:  

```
docker image ls  
```
 
Thank you https://www.pentestpartners.com/security-blog/docker-for-hackers-a-pen-testers-guide/ 
