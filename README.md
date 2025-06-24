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

**fz** is a simple Bash script to pipe commands to [FZF](https://github.com/junegunn/fzf) so you can benefit from previewing, filtering, etc.

## Usage

Just type `fz` followed by a valid command. Type `fz --help` to see the available commands.

## Installation

1. Get it:

Download the file named `fz`.

```bash
curl -O https://raw.githubusercontent.com/lfromanini/fz/main/bin/fz
```

2. Move it to a place in `${PATH}`:

Choose a location from `${PATH}`.

```bash
# check ${PATH}
tr ":" "\n" <<< "${PATH}" | sort --unique
```

Move script to the choosen folder, for example:

```bash
mv fz ~/bin/
```

Make sure to use `sudo` if moving to a system folder.

```bash
sudo mv fz /usr/local/bin/
```

3. Done!

#### Requirements

* [fzf](https://github.com/junegunn/fzf)

## LICENSE

The [MIT License](https://github.com/lfromanini/fz/blob/main/LICENSE) (MIT)
