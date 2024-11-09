import os
import sys
import subprocess
import hashlib


with open("./config_files_list.txt", "r") as f:
    lines = f.readlines()
    files = [line.strip() for line in lines]


def build():
    if not os.path.exists("./src"):
        os.mkdir("./src")

    for file in files:
        file_path = os.path.expanduser(file)
        hashed_path = hashlib.sha256(file.encode()).hexdigest()
        subprocess.run(["cp", "-r", file_path, f"./src/{hashed_path}"])

    subprocess.run(["tar", "czf", "./config_files.tar.bz2", "./src/"])
    subprocess.run(["rm", "-rf", "./src/"])


def install():

    # Conform the user wants to install the config files
    print("Do you want to install the config files? [y/n]", end=" ")
    answer = input()
    if answer != "y":
        print("Nothing has been changed.")
        sys.exit(0)

    # Extract the config files
    subprocess.run(
        ["tar", "xvf", "config_files.tar.bz2", "."], stdout=subprocess.DEVNULL
    )

    # Copy the config files to the destination
    for file in files:
        file_path = os.path.expanduser(file)

        # Check if the file already exists
        # If it does, make a backup
        if os.path.exists(file_path):
            print(f"File {file_path} already exists.")

            print("Do you want to make a backup? [y/n]", end=" ")
            answer = input()
            if answer == "y":
                print("making a backup...")
                subprocess.run(["cp", "-r", file_path, f"{file_path}.bak"])

        hashed_path = hashlib.sha256(file.encode()).hexdigest()
        subprocess.run(["cp", "-r", f"./src/{hashed_path}", file_path])


if __name__ == "__main__":
    if sys.argv[1] == "build":
        build()
    elif sys.argv[1] == "install":
        install()
    else:
        print("Invalid argument")
        sys.exit(1)
