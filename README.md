# Training: Docker build stages

## My wills

I have a simple React TS app (sorry, I did not customize the app **at all**). 

I want my app to be tested with `cypress`.

I want to develop, test and deploy my app using Docker and docker compose.

I want to keep my 3 docker-compose files, and I would like to optimize my Dockerfile with 2 goals:
- reducing the size of my image in order to upload it on the Dockerhub (for instance)
- improve docker build time using the cache

## First approaches

So far, I've tested two approaches.

Having a big Dockerfile, bullets proof, and changing the command executed each time (depending on if I am testing, livereloading or deploying) in the `docker-compose.yml` file. This approach works pretty well, but the built docker image **is huge: 2.23GB!!**. Since this size is not a problem when I'm working locally, I cannot push an image this big to the Dockerhub! (I can, but I won't). *This is the approach implemented in this repo.*

Having 3 Dockerfiles for each case I want to cover (livereloading, deploying or testing). This is pretty cool because for 2 of my 3 cases, I can start from a `node:alpine` image that is super light! But I have 2 problems with this approach: having 3 Dockerfiles instead of one is not that sexy, and by having 3 Dockerfiles, Docker does not understand how to share build cache between images! As a result, images size are pretty light, but the compilation time is very long because Docker cannot use its cache to make it faster! This approach is not implemented here.

## Few thoughts

**Why is my image so big?**

Because if I start my container and navigate into it, I can see that I have `node_modules`, Typescript, Cypress, ..., installed inside. But do I really need these tools to serve a simple static web app? **NO!**

**Why I cannot use `RUN rm -rf node_modules src` at the end of my Dockerfile?**

You may try! But the way Docker images are not that simple. Each command line in a Dockerfile is a layer. An image is a composition of all the layers. If your last command is deleting something, it just appends a new layer in the image, but it won't actually delete the other layers that have the files!

## How to optimize?

I want to optimize my Dockerfile! I just heard of an approach that could help me: **using Docker build stages**. Unfortunetly, I don't have the time to do it! Can you try it for me?

From the promises I heard, it should be possible:
- by working in the `Dockerfile`, by enabling build stages
- by changing just few things in `docker-compose.yml` files (`.test` and `.prod` also), removing the `command` entry and adding a `target` prop for the build

**And that's all!**

Indeed, I think with this approach, **you should be able to get an Docker image that is about 117MO!**. And that's better. Also, the cache will work to build different kind of images!