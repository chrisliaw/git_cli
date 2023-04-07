# GitCli

This project is aimed to create the interfacing to GIT via the Command Line Interface (CLI). This is due to the CLI is always the latest version while library is lacking behind. Furthermore, library for Ruby or Java might not be coming in so soon, being later should be a better in keeping up the changes.

Hence the interfacing with the CLI seems the better way to do that.

This codes are tested using git version 2.25.1, Linux x86\_64 

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'git_cli'
```

And then execute:

$ bundle install

Or install it yourself as:

    $ gem install git_cli

## Usage

Example usage:

```ruby
require 'git_cli'

# Gvcs is artificial namespace to shield the actual 
# GitCli package name. It is designed so that if we 
# have another VCS coming all client code can remain
# unchanged since the specific package name is not 
# being used in client application. The new VCS provider
# can just provide all functions via the interface
# Only draw back is this cannot run multiple VCS at the 
# same time
#
# vcs is encapsulation of general functions (read below)
vcs = Gvcs::Vcs.new
vcs.init(path) # init workspace at the given path
vcs.clone("/source/repos", "/destination/repos") # clone a project

workspace = Gvcs::Workspace.new(vcs, "/any/git/repository")
# workspace now can invoke all supported git operations 

```

## Supported GIT Operation

The following operations are supported on the git command line:
- Generall functions (to make a directory become git workspace) 
  - vcs.init("/path/to/new/workspace")
  - vcs.clone("/source/repos","/path/to/workspace")
- Workspace command
  - workspace.root\_path
    > git rev-parse --show-toplevel
  - workspace.is\_workspace? 
    - Call git status see if error thrown
  - workspace.repos 
    - Returns list of remote repositories
  - workspace.clean?
    - Return true if there is no new,deleted,modified and staged files
  - workspace.add("/path/a","/path/b","/path/c/a")
    > git add
  - workspace.remove\_staging("/path/a","/path/b","/path/c/a") 
    > git reset
  - workspace.remove\_vcs("/path/a","/path/b","/path/c/a") 
    > git rm --cached 
  - workspace.commit("commit message", { files: ["/path/a"."/path/b"] })
    > git commit /path/a /path/b -m "commit message"
  - workspace.commit\_all("commit message")
    > git commit -am 
  - workspace.status
    > git status 
    - Returns list of GitCli::Delta::VCSItem carries attributes @path, @full and @type
  - workspace.modified\_files # git diff --name-only --diff-filter=M [returns modified directories and files in an array]
  - workspace.conflicted\_files # git diff --name-only --diff-filter=U [returns conflicted directories and files in an array]
  - workspace.new\_files # git ls-files --others --exclude-standard --directory [returns new directories and files (non tracked) in an array]
  - workspace.deleted\_files # git ls-files -d [returns deleted directories and files in an array]
  - workspace.staged\_files # git diff --name-only --cached  [returns staged directories and files in an array]
  - workspace.reset\_file\_changes("/path/to/file") # git checkout --
  - workspace.reset\_all\_changes # git reset --hard
  - workspace.calculat\_distance("origin/HEAD","HEAD") # git rev-list 'origin/HEAD'..'HEAD' --count [returns integer value how far is it]
  - workspace.is\_local\_ahead\_of\_remote?("origin/HEAD","branch-main") # aggregated from calculate\_distance() with default _to_ value fixed at "HEAD" [returns boolean]
  - workspace.is\_remote\_ahead\_of\_local?("origin/HEAD","branch-main") # aggregated from calculate\_distance() with default _from_ value fixed at "HEAD" [returns boolean]
  - workspace.push("origin","master") # git push origin master
  - workspace.push\_with\_tags("origin","master") # git push origin master --tags
  - workspace.pull("origin","master") # git pull
  - workspace.current\_branch # git branch --show-current [returns branch name]
  - workspace.local\_branches # git branch [return local branches in an array]
  - workspace.remote\_branches # git branch -r [return remote branches in an array]
  - workspace.all\_branches # concate output of local\_branches and remote\_branches [returns array]
  - workspace.switch\_branch("new-branch") # git checkout new-branch
  - workspace.create\_branch("new-branch") # git branch new-branch
  - workspace.download\_all\_remote\_branches\_name # git fetch -all
  - workspace.merge\_branch("development") # git merge development
  - workspace.delete\_branch("development") # git branch -d development
  - workspace.diff # git diff
  - workspace.diff\_file("/path/a") # git diff /path/a
  - workspace.diff\_branch("master/HEAD","development/HEAD") # git diff master/HEAD..development/HEAD
  - workspace.diff\_working\_with\_last\_commit # git diff HEAD^ HEAD
  - workspace.diff\_index\_with\_last\_commit # git diff --cached
  - workspace.ignore("/path/a","/path/b") # Append entries into .gitignore file
  - workspace.ignore\_rules # read the .gitignore files and returns its content in an array
  - workspace.update\_ignore\_rules("\*.log") # add non file entries into .gitignore
  - workspace.show\_log(commit\_id) # git show commit\_id
  - workspace.all\_tags # git tag [returns array]
  - workspace.tag\_info("tag name", "%H|%ad|%an|%s") # git show tag\_name --format="%H|%ad|%an|%s"
  - workspace.create\_tag(tagname) # git tag tagname
  - workspace.create\_tag(tagname, message) # git tag -a tagname -m message
  - workspace.create\_tag\_from\_commit(tagname, commit) # git tag -a tagname commit
  - workspace.create\_tag\_from\_commit(tagname, commit, message) # git tag -a tagname -m message commit
  - workspace.fetch\_tag\_to\_local  # git fetch --all --tags
  - workspace.show\_tag\_detail(tagname) # git show tagname
  - workspace.delete\_tag(tagname) # git tag -d tagname
  - workspace.delete\_remote\_tag("origin","tagname") # git push origin --delete tagname
  - workspace.checkout\_tag(tagname, branch) # git checkout tags/tagname -b branch
  - workspace.tag\_points\_at?("HEAD") # git tag --points-at HEAD [Return boolean]
  - workspace.remote\_config # git remote -vv [return Hash with repos name as key, points to hash with "push" or "fetch" as key]
  - workspace.add\_remote(name, url) # git remote add name url
  - workspace.remove\_remote(name) # git remote remove name
  - workspace.stash\_changes(msg) # git stash save "msg"
  - workspace.stash\_all\_chanegs(msg) # git stash save --include-untracked
  - workspace.stash\_all\_chanegs(msg, true) # git stash save --include-untracked(-u) --all(-a)
  - workspace.stash\_list # git stash list [returns boolean and hash of stash info]
  - workspace.stash\_restore # git stash apply
  - workspace.stash\_restore(id) # git stash apply id --> ID can be obtained from stash\_list. Something like "stash@{0}"
  - workspace.stash\_restore\_and\_remove  # git stash pop
  - workspace.stash\_restore\_and\_remove(id)  # git stash pop id --> ID can be obtained from stash\_list. Something like "stash@{0}"
  - workspace.stash\_to\_new\_branch(branch) # git stash branch
  - workspace.stash\_to\_new\_branch(branch, id) # git stash branch id
  - workspace.stash\_clear # git stash clear
  - workspace.stash\_remove # git stash drop
  - workspace.stash\_remove(id) # git stash drop id



## Return Value

Unless otherwise stated, the API shall return an array, with 1st element is the boolean status value running the command line (taken from $?) and 2nd element shall be the standard output of the running command. Note though all command was run with flag '2>&1' which effectively redirected the STDERR to STDOUT which should be captured by the program.

This is due to all running of command line is via the backtick (\`) method. The reason to use this is backtick allow interaction with user. If there is an input needed, backtick will actually wait user input at the prompt, although not ideal, but it is the simplest and easiest for now.
  
  
