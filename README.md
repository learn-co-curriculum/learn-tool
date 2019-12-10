# Learn Tool

This gem is designed to aid in the creation, duplication and repair of Learn lessons.

## Installation and Setup

Before using `learn-tool`, you must install `hub`, GitHub's extended CLI API.

```sh
brew install hub
```

Once `hub` is installed, you'll need to get it configured before running
`learn-tool`. The best way to do this is to use `hub` once to create a
repository on learn-co-curriculum. In the shell:

- Create a new, empty folder and `cd` into it
- Run `git init` to initialize git
- Run `hub create learn-co-curriculum/<whatever-name-you've-chosen>`
  - You should be prompted to sign in to GitHub
  - **Note:** If you have set up two-factor identification on GitHub, when
    prompted for your password, you have two options:
    - If Github SMS' you a one-time password, use it!
    - Otherwise, instead of using your normal password, you
      need to enter a Personal Access Token. You can create a token in your
      GitHub settings page.
- If everything works as expected you should now have an empty `learn-co-curriculum` repo.
- Delete the repo, please. Everything should be set up now.

Install the `learn-tool` gem:

```sh
gem install learn-tool
```

## Lesson Creation

To create  a new repository, navigate to the folder where you'd like your
repo to be duplicated locally and type:

```sh
learn-tool --create
```

Follow the prompts to create a blank readme, code-along or lab repository. The
repo will be created locally and pushed to GitHub. When finished, you can `cd`
into the local folder or open it on github to start working. This command draws
from a number of existing templates.

- [Readme Template](https://github.com/learn-co-curriculum/readme-template)
- [Ruby Lab Template](https://github.com/learn-co-curriculum/ruby-lab-template)
- [JavaScript Lab Template](https://github.com/learn-co-curriculum/js-lab-template)
- React Lab Template (to be linked)

For other lesson types, start with a Readme.

## Lesson Duplication

To duplicate an existing repository, type:

```sh
learn-tool --duplicate
```

This command will make an exact copy of another repository. For example, you
could use this if you want to create a new Active Record lab and want to borrow
the configuration of an existing lab.

**Note**: if you have an idea on how improvement to an existing lesson, please
consider creating a fork and submit a pull request on the **original lesson**
rather than creating an altered duplicate.

## Lesson Linting and Repair

If you already have a repository or created one manually, it is important that
certain files are present:

- `.learn` - this file is required. In addition, this file must contain a
  `languages` attribute. Not including this file or the required attributet will
  cause deploy issues.
- `LICENSE.md` - All educational materials used through the Learn platform
  should include this file.
- `CONTRIBUTING.md` - This file contains information on how to contribute to our
  content.

To check if these files are present and correct, from the lesson directory type:

```sh
learn-tool --lint
```

Alternatively, you can provide an absolute path to the directory you would like to lint:

```sh
learn-tool --lint /Users/johnboy/lessons/jukebox-cli
```

To quickly add or fix these files, type:

```sh
learn-tool --repair
```

This command will replace or add the required files to the current repository. You can pass an absolute path of another directory you would like to repair:

```sh
learn-tool --repair /Users/johnboy/lessons/jukebox-cli
```
**Warning**: Repairing will overwrite any existing support files.

## Resources

- [Hub][hub]

[hub]: https://hub.github.com/hub.1.html
