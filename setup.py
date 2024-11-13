import os
import sys
import subprocess
import re


with open("./config_files_list.txt", "r") as f:
    lines = f.readlines()
    files = [os.path.expanduser(line.strip()) for line in lines]


def dotfile_path(path):
    filename = re.sub(r"/$", "", path)
    filename = os.path.basename(filename)
    filename = re.sub(r"^\.", "", filename)
    return f"./config_files/{filename}"


def build():
    if not os.path.exists("./config_files"):
        os.mkdir("./config_files")

    print("Collected files:")
    for file in files:
        subprocess.run(["cp", "-r", file, dotfile_path(file)])
        print(f"    - {dotfile_path(file)}")

    print("\nUpload to GitHub:")
    print("--------------------")
    print("  git add -A")
    print("  git commit -m 'Updated config files'")
    print("  git push origin main")


def install():

    # Conform the user wants to install the config files
    print("Do you want to install the config files? [y/n]", end=" ")
    answer = input()
    if answer != "y":
        print("Nothing has been changed.")
        sys.exit(0)

    # Copy the config files to the destination
    for file in files:

        # Check if the file already exists
        # If it does, make a backup
        if os.path.exists(file):
            print(f"File {file} already exists.")

            print("Do you want to make a backup? [y/n]", end=" ")
            answer = input()
            if answer == "y":
                print("making a backup...")
                subprocess.run(["cp", "-r", file, f"{file}.bak"])

        if not os.path.exists(os.path.dirname(file)):
            os.makedirs(os.path.dirname(file))

        subprocess.run(["cp", "-r", dotfile_path(file), file])


if __name__ == "__main__":
    if sys.argv[1] == "build":
        build()
    elif sys.argv[1] == "install":
        install()
    else:
        print("Invalid argument")
        sys.exit(1)
