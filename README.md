# Start your Python application from here!

Are you tired to setup a new environment to your project?

Every time you need to start a project you have to create a new virtualenv and install all packages needed for this project.

Or even worry about downloading the latest python version. 


Not anymore!

Start from here. One command line and you have setup all your environment and packages.

You will have the same environment to run your develop and production code.

But I like to code using **Jupyter**. Yes! It is possible. Just install **jupyter** with poetry inside the container and share the container 8888 port. **Jupyter-lab** too.

New branch of this repository with **Jupyter-lab** installed coming soon.


## Requirements

All you need is to install [docker](https://docs.docker.com/get-docker/) and [docker compose](https://docs.docker.com/compose/install/).

To keep your environment up to date, use [poetry](https://python-poetry.org/docs/cli/) to install and manage yours packages.

Poetry come installed inside the container and is easy to use.

It is not that hard, give it a try. Hard work has been made easier.

No! You **don't need** to download and install **Python**, **Anaconda** or other environment.

All you need to start is here.

---


## Before start

1. Change the name package named `python_app`. Give it a cool name!


2. On pyproject.toml 
    * Change the **name** of the application.
    
    * Change the author, instead you are me.
    
    * Observe the *coolest* part and **make your own CLI**.
    
        On `[tool.poetry.scripts]` you can define a entrypoint to your application. The way it is, to execute the function `main` inside the `python_app.cli` package, you just need type `app` in the terminal.
        Pay attention! Once you changed the name of the package `python_app`, you must change the CLI entrypoint to the same you used in the package.
        

3. Start the dev container.

    ```sh
    UID=$UID GID=$GID docker-compose up -d
    ```

4. It is a good idea update the package that is already installed for you. Use **poetry** to do it.

    ```sh
    docker exec app poetry update    
    ```

---

## Executing
First, build and start your python docker container

```sh
UID=$UID GID=$GID docker-compose up -d --build
```

##### **NOTE!**
* Use `UID` and `GID` to have the same files permissions inside the container.
* Use `--build` always you want to reinstall your packages, or **remove it** if you just want to start.

Awesome! Your have your develop environment created!
Let's start:

* Open your *command line* inside the container

    ```sh
    docker-compose exec app bash
    ```

* Execute your application
    * Inside the container
    
        ```sh
        app
        ```
        
        Or
        
        ```sh
        python script.py
        ```
        
    * Outside the container
    
        ```sh
        docker-compose exec app app
        ```
        
        ##### **Note!** 
        The **first** `app` is the `service` named inside the `docker-compose.yml` file.
        The **second** `app`, in this case, is the same you execute inside the container. 
        
        Or
        
        ```sh
        docker-compose app python script.py
        ```

    ##### **Note!** 
    After changing the application's `CLI` command in` pyproject.toml`, as described in [Before starting #2](#before-start), you will have to use the same command defined here (instead of `app`).

### When finish
After a hard time developing, stop your container with

```sh
docker-compose down
```

and go take a good cup of coffee.

---

## Format your code
Your code can look pretty!

You can use `black` and `isort` to format your code using PEP's look like.

This tools are included for development and they are awesome.


### [isort](https://pycqa.github.io/isort/)
Use [`isort`](https://pycqa.github.io/isort/) to order your imports.

```sh
docker-compose exec app isort **/*.py
```

### [black](https://black.readthedocs.io/en/stable/)
[`black`](https://black.readthedocs.io/en/stable/) can format your code to look better.

```sh
docker-compose exec app black **/*.py
```

---

## Deployment
It is done!

Yes! Is done.

The production container will be able to build your project and install it on Python.

Yeah! It will not be a simple script, but a real package for python and is installable, like `pandas`, `boto3`, `flask` or any other python package.

To use the deployment container you must inform the `docker-compose.prod.yml` to `docker-compose`.

```sh
UID=$UID GID=$GID docker-compose -f docker-compose.prod.yml up -d --build
```

### Run your tests

```sh
docker-compose exec app pytest
```

### Run your code

```sh
docker-compose exec app app
```

Or

```sh
docker-compose exec app python script.py
```

---

## I want to use a previous Python Version
[Why you shouldn't](https://www.youtube.com/watch?v=cEkA9PH2oEk)

[![Why you shouldn't](https://i.ytimg.com/vi/cEkA9PH2oEk/hqdefault.jpg?sqp=-oaymwEcCPYBEIoBSFXyq4qpAw4IARUAAIhCGAFwAcABBg==&rs=AOn4CLDe4NMkx0xUwL7boR64pEjGvxO2Hg)](https://www.youtube.com/watch?v=cEkA9PH2oEk)

Don't forget to subscribe and like this video for more!

Well, if you arrived here you really need to use a previous python version. 
Are you sure?
OK! Let's do this. It is not that hard.

We have some file you must change little things.

#### Dockerfile
In the first line we have this:

```Dockerfile
FROM python:3.9-slim-buster as base
```
Yes! `3.9` is the python version you are using. Just change it.
You can define the exact version you want, like `3.7.10`, but, if you watched the video, you know that is better set `3.7`.

```Dockerfile
FROM python:3.7-slim-buster as base
```

Or

```Dockerfile
FROM python:3.7.10-slim-buster as base
```

#### Dockerfile.prod
Wow! Look that! For the production Dockerfile we have the same line!
It's that what ensure you have the same environment for development and production. 
Don't matter you are using Linux, Windows, Mac. When you deploy your application it will work like **work in your machine**

```Dockerfile
FROM python:3.9-slim-buster as base
```
Go! Change it.

```Dockerfile
FROM python:3.7-slim-buster as base
```
Or

```Dockerfile
FROM python:3.7.10-slim-buster as base
```

#### pyproject.toml
Good! Now you broke your container.
Just change one more thing and we are done.

Open your `pyproject.toml` file and look for these lines:

```toml
[tool.poetry.dependencies]
python = "^3.9"
```

Yep! It is that what broke your container.
Poetry need a python version bigger then `3.9` and now we are using `3.7`.
Let's change this.

```toml
[tool.poetry.dependencies]
python = "^3.7"
```
Or, if you want use exactly `3.7.10`. Remember, this is **highly not recommended**.

```toml
[tool.poetry.dependencies]
python = "3.7.10"
```
