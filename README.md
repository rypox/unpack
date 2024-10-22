# unpack
Unpack all kinds of archives on the linux command line.

# Description

This script unpacks various types of archive files on Linux systems.

## Supported Archive Types

- .zip
- .tar
- .tar.gz, .tgz
- .tar.bz2, .tbz2
- .tar.xz, .txz
- .7z
- .rar

## Dependencies

Ensure you have the following tools installed:
- tar
- unzip
- 7z
- unrar

You can install these on most Linux distributions using:

* apt
    ```
    sudo apt update
    sudo apt install tar gzip bzip2 xz-utils unzip p7zip-full unrar
    ```

* dnf/yum
    ```
    sudo dnf update -y
    sudo dnf install -y tar gzip bzip2 xz-utils unzip p7zip p7zip-plugins unrar
    ```

## Deployment

1. Clone this repository:

    git clone https://github.com/your-username/unpack-script.git

2. Navigate to the script directory:

    cd unpack-script

3. Make the script executable:

    chmod +x unpack.sh

4. (Optional) Add the script to your PATH for system-wide access:

    sudo cp unpack.sh /usr/local/bin/unpack

## Usage

    ./unpack.sh [OPTIONS] <archive_file>

Or if you added it to your PATH:

    unpack [OPTIONS] <archive_file>

Use `--help` for more information on available options.
