# fz

[![MIT license](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)
[![Shell](https://img.shields.io/badge/shell-bash-orange?logo=gnu-bash&logoColor=white)]()
[![Latest Tag](https://img.shields.io/github/v/tag/lfromanini/fz)](https://github.com/lfromanini/fz/tags)
[![GitHub Stars](https://img.shields.io/github/stars/lfromanini/fz?style=social)](https://github.com/lfromanini/fz/stargazers)
[![Dependencies](https://img.shields.io/badge/dependencies-bash%7Cfzf-lightgrey)](https://github.com/lfromanini/fz#requirements)
[![CI](https://github.com/lfromanini/fz/actions/workflows/ci.yaml/badge.svg)](https://github.com/lfromanini/fz/actions/workflows/ci.yaml)

fz - Pipe commands to FZF

```
    ffffffffffffffff                  
  f::::::::::::::::f                  
 f::::::::::::::::::f                 
 f::::::fffffff:::::f                 
 f:::::f       ffffffzzzzzzzzzzzzzzzzz
 f:::::f             z:::::::::::::::z
f:::::::ffffff       z::::::::::::::z 
f::::::::::::f       zzzzzzzz::::::z  
f::::::::::::f             z::::::z   
f:::::::ffffff            z::::::z    
 f:::::f                 z::::::z     
 f:::::f                z::::::z      
f:::::::f              z::::::zzzzzzzz
f:::::::f             z::::::::::::::z
f:::::::f            z:::::::::::::::z
fffffffff            zzzzzzzzzzzzzzzzz
```

## Description

**fz** is a simple Bash script for piping commands to [FZF](https://github.com/junegunn/fzf), allowing you to take advantage of features such as previewing and filtering.

## Usage

Run `fz` followed by a valid command. Run `fz --help` for a complete list of commands and options.

### Commands

#### env [QUERY]

Browse environment variables and their values. Press `<CTRL> + <A>` or `<CTRL> + <SPACE>` to select all filtered results.

```bash
fz env
fz env PATH
```

#### kill [SIGNAL]

Browse running processes and send a signal. Defaults to SIGTERM; `<CTRL> + <K>` sends SIGKILL.

```bash
fz kill
fz kill -9
```

#### man [QUERY]

Browse installed manual pages with previews.

```bash
fz man
fz man su
```

#### ssh [SSH_OPTIONS] [-- COMMAND [ARGUMENTS...]]

Browse SSH hosts and connect to the selected host. Arguments before `--` are passed to ssh; arguments after `--` are executed on the selected host.

```bash
fz ssh
fz ssh -p 2222
fz ssh -p 2222 -- hostname -A
```

#### tmux [QUERY]

Browse tmux sessions, windows and panes. Press `<ENTER>` to attach or switch to the selection; press `<CTRL> + <K>` to kill it.

**Requires tmux.**

```bash
fz tmux
fz tmux mySession
```

## Installation

1. Download the script:

Download the file named `fz` and make it executable.

```bash
# download fz to current folder
curl -O https://raw.githubusercontent.com/lfromanini/fz/main/bin/fz

# make it executable
chmod +x fz
```

2. Move it to a directory in `${PATH}`:

Choose a directory from `${PATH}`.

```bash
# check ${PATH}
tr ":" "\n" <<< "${PATH}" | sort
```

Move the script to the chosen directory, for example:

```bash
mv fz ~/.local/bin/
```

If you are moving it to a system directory, you may need to use `sudo`.

```bash
sudo mv fz /usr/local/bin/
```

3. Add shell completions to `.bashrc` and `.zshrc`

This allows you to use `fz <TAB><TAB>` or `fz kill <TAB><TAB>` to autocomplete commands:

```bash
# bash
echo 'source <( fz --bash-completion )' >> ~/.bashrc

# zsh
echo 'source <( fz --zsh-completion )' >> ~/.zshrc
```

Reload your shell configuration for the changes to take effect:

```bash
# bash
source ~/.bashrc

# zsh
source ~/.zshrc
```

4. Done!

## Contributing

Contributions are welcome. See [CONTRIBUTING.md](CONTRIBUTING.md) for development guidelines, testing and contribution conventions.

#### Requirements

- bash
- [fzf](https://github.com/junegunn/fzf)

##### Optional Requirements

- [bat](https://github.com/sharkdp/bat) (enables enhanced previews)
- tmux (enables the `fz tmux` command)

## LICENSE

The [MIT License](https://github.com/lfromanini/fz/blob/main/LICENSE) (MIT)
