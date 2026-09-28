<img align="right" src="https://cdn.rawgit.com/sindresorhus/awesome/d7305f38d29fed78fa85652e3a63e154dd8e8829/media/badge.svg">

# fz

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

Run `fz` followed by a valid command. Run `fz --help` to see the available commands.

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
mv fz ~/bin/
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

Restart your shell for the changes to take effect.

4. Done!

#### Requirements

- bash
- [fzf](https://github.com/junegunn/fzf)

##### Optional Requirements

- [bat](https://github.com/sharkdp/bat) (enables enhanced previews)
- tmux (enables the `fz tmux` command)

## LICENSE

The [MIT License](https://github.com/lfromanini/fz/blob/main/LICENSE) (MIT)
