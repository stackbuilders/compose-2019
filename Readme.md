# Haskell + ReasonML Example

## Requirements

- Install [haskell-stack](https://docs.haskellstack.org/en/stable/README/#how-to-install).
- Install [yarn](https://yarnpkg.com/en/)

## Getting Started

Clone this repository

```
git clone git@github.com:stackbuilders/compose-2019.git
```

You'll find four different projects in the repository root:

- `blog-types`: Haskell type definitions for our simple blog implementation
- `blog-server`: Simple [servant](https://www.servant.dev/) API that works as a
  backend for our blog
- `genetate-ocaml-types`: Executable that generates OCaml types based on our Haskell
  types defined in `blog-types`
- `blog-frontend`: The front end side of our blog written in [ReasonML](https://reasonml.github.io/)

In order to build everything, just do

```
stack build
```

from the repo root folder.

### Run the backend

```
stack exec blog-server-exe
```

Now the server should be up and running in http://localhost:8080
You can test the server is running with the following endpoint: http://
localhost:8080/articles. It should return a json with all the articles in the
default database.

### Generate front-end types

Before running the front-end server, we have to generate the OCaml types and the
serialization tests. This project uses the [ocaml-export](https://github.com/plow-technologies/ocaml-export)
library to make the Ocaml types. Run the following command:

```
stack exec generate-ocaml-types-exe
```

You will find the OCaml type definitions in the `blog-frontend/src/Exported` folder,
and the serialization tests in `blog-frontend/__test__/Exported`

### Start up the frontend

This is a [ReasonReact](https://reasonml.github.io/reason-react/) project that uses
the API we builded before with the exact same types.

```
cd blog-frontend
yarn install
yarn build
yarn test  # These are the serialization tests that make sure our types match
yarn start # starts the dev server
```

And that's it. Now you should have a frontend in http://localhost:3000.

**Happy hacking!**

## Contribute

File an issue or make a PR in https://github.com/plow-technologies/ocaml-export, your contribution is welcomed!!
