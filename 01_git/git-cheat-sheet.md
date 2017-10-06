# A Git cheat sheet

## Getting started:

* Initialize: `$ git init`
* Add files (and folders): `$ git add <file>`
* Commit your changes: `$ git commit`
    * edit your commit message!!
    * **Shortcut:** `$ git commit -am "this is my commit message"`
      * the `-a` commits all files that were already added
      * the `-m` appends the commit message in quotes

## Workflow:

* Make changes to files
* Check status: `$ git status`
* add new files: `$ git add newfile.txt`
* Commit when finished: `$ git commit -a`

## Working with remote Github repos:

A remote repository (repo) is one that is separate from the code on
your local machine (working-copy). It can be in another location on
your machine (say, in `~/git/`), or on a different machine that you
access remotely.

If you're using a service like Github, there is very little to do
beyond following the instructions provided when you initialize the
repo through a browser. If you're moving a local repo to another
machine where it will act as a remote repo, follow the instructions
below.

1. Setup (same as for regular repo) - start on local machine:

    `$ cd ~/project`  
    `$ git init`  
    `$ git add <file>`  
    `$ git commit -am "initial commit"`  

2. Go to Github.com, sign in, and click on the "+" to create a new repository

3. Fill in the details. If you are creating the repo on Github
   *before* you initialized one on your own machine, you can use the
   feature that lets you initialize with a `README` file, etc. If you
   want to import a repository you already have, *DON'T* do this.

4. Follow the instructions (which just tell your local repo to use
   Github as the remote repo), which will give you a series of
   commands to enter in a Git shell (alternatively, use the Github
   Desktop app).

5. Now you can work on the local copy, and do the usual:

    `$ git add newfiles.txt`  
    `$ git commit -a`

6. and when finished do:

    `$ git push`  
    to push changes back to the server.

7. To update a working copy from a repo (say, to work from a different
   machine, or on a repo that has more than one collaborator), do:

    `$ git pull`
	
	*before* making any changes of your own (otherwise you'll get merge conflicts).

## To fix mistakes:

* To reset the entire tree to the last commit:

    `$ git reset --hard HEAD`
    
* For single files:

    `$ git checkout filethatgotborked.txt`

## .gitignore file:

This is where you stick stuff that you *don't* want to include in the
repo (temporary files, images, backups, etc). Example:

    ## misc things
    *~
    *.pdf
    *.jpg
    *.bak
    
    ## latex stuff
    *.aux
    *.bbl
    *.blg
    *.bst
    *.log
    *.toc

    ## data stuff
    *.mat
    *.rda
    *.out
    
    ## things to keep
    !mynicedrawing.jpg
    !averysmalldatafile.rda

## Other useful commands:

* `$ git diff` to see changes since last commit (or compare commits)
* `$ git log` to see commit messages
* `$ gitk` to see a gui of the commit tree, messages, and diffs

## git command aliases:

You can create *aliases* for git commands by editing your `~/.gitconfig`
file, e.g.:

    [core]
        editor = emacs -q -nw

    [user]
        email = clark.richards@gmail.com

    [alias]
        st = status
        ci = commit
        br = branch
        co = checkout
        df = diff
        lg = log -p
        ft = fetch
        mg = merge
        pl = pull
        ps = push

## Other Resources:

* Get Git: www.git-scm.com
* GitHub.com (free and paid git repo hosting with a **TON** of
  features)
    * also see http://help.github.com
	* Github Desktop app
* Bitbucket (another hosting service with free private repos)
* GitX (git gui for OS X)
* [SourceTree](https://www.atlassian.com/software/sourcetree/overview) (haven't
  tried it, but hear it's good)
