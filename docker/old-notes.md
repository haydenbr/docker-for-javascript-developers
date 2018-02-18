# Docker Dependencies

__LINK ON MEETUP!!!!!__

## Intro

~ git checkout 1.0.0

~ npm i

~ git checkout caa0237

~ npm i

### Shoutouts

- Sha
- Nick

### About me

- story with docker
- docker projects: load testing, deploy REST api

### What we're doing

- Docker for local dev
- examples: new years app, angular/ionic
- can apply to other languages
- survey languages: python, .net, ruby, JS, java, 

### The problem

#### Common solutions

- `rm -rf /dependencies`
- `rm -rf /project`
- update global version(s)
- abandon ship

#### Dependencies

##### System level dependencies

- OS, compiler, cli tools, language version, runtime version, browser
- does it need to be a global dependency?
- different projects need different version of the same dependency?

##### Project specific dependencies

- different version of project needs different dependencies
- open source smorgasbord
- multiple combinations

### JS Development

- package manager: npm
- npm installs into node_modules
- package.json describes dependencies and other meta data of project
- npm scripts

### Docker

#### Basics

Docker is a virtualization technology that allows you to create isolated,minimalistic environments that contain only the absolute necessary dependencies needed for a specific purpose.

- What's an image?
- What's a container?
- multiple use cases

#### Context of our problem

- PREVENTS the problem, doesn't solve. Lock in dependencies
- no dogma: this is A WAY to solve the problem
- take it or leave it. Feedback.
- isn't docker a dependency?
- LOCKING your dependencies

### The image

#### First pass

- naïve
- please use .dockerignore
- problem: npm each time if anything changes

#### Second pass

- slight improvement
- add package.json first, then npm i
- change in anything else wont trigger install
- added entry point

#### Third pass

- handle system dependencies first
- npm i, what is dependencies.json?
- platform dependency
- image versioning

##### Versioning

- bump.sh
- sync-config
- sync-pipeline (preview)
- copy-dependencies
    - problem: version in package.json
    - package.json, only with dependency info and necesarry scripts
    - config.xml, no version
    - Dockerfile
- docker-build

#### Final solution

- we can use volume mounts for other files
- how do I decide what to put in, what to leave out?
- for our purposes

#### Improvements?

- get rid of globals in the image
- node-slim?
- ideas?

### Demos

#### different versions of project

- fix the banana, v0 branch

#### additional use cases

- test different node version
- safer experimentation

#### volunteer :)

### Bonus!

#### Security / Privacy

##### Security

- computer infected, much harder to get to container
- peasants revolt in your container? your kingdom is still fine
- container like Mordor
- fork bomb?

##### Privacy

- do you really know what you're installing?
- npm i: 317MB, npm i -g: 88MB
- twitter in node_modules
- Ultron?

#### CI Builds

- tools based on docker
- circle ci, expensive
- bitbucket pipelines

##### Bit Bucket Pipelines

- yaml file
- syncing file
- build script

##### Pipelines result

- before, installed every time
- now, just building
- before and after with PNC
- look at new-years pipeline builds

### Closing

#### Cons

- upfront investment
- buy-in (start small)
- new mindset

#### Benefits

- easier to manage project dependencies
- easier to debug older / different versions
- easier for new team members
- bonus from your work!
