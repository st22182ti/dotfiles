## Requirements

- python version 3.x
- make

## Install

Just run:

```bash
make install
```

## Apply local config changes

1. Add your local config file's path to the `config_files_list.txt` file.
   If you just changed existing config files, you can skip this step.

2. Run:

```bash
make build

# If you manage your dotfiles with git:
git add -A
git commit -m "Update config files"
git push origin main
```

## File structure

- `config_files_list.txt`: List of config files to be managed.
- `config_files/`: Directory to store the config files.
- `setup.py`: Python script to install & manage the config files.
- `Makefile`: Makefile to run the setup.py script.

## How it works

#### Build

The `setup.py` script reads the `config_files_list.txt` file and copy the files to the `config_files/` directory.

#### Install

The `setup.py` script reads the `config_files_list.txt` file and copy the files in `config_files` directory to the correct location.
