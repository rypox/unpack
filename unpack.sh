#!/bin/bash

show_help() {
    echo "Usage: unpack.sh [OPTIONS] <archive_file>"
    echo
    echo "Unpack various types of archive files."
    echo
    echo "Options:"
    echo "  --help    Show this help message and exit"
    echo
    echo "Supported archive types:"
    echo "  .zip, .tar, .tar.gz, .tgz, .tar.bz2, .tbz2, .tar.xz, .txz, .gz, .bz2, .xz, .7z, .rar"
    echo
    echo "The script will create a new directory named after the archive if it doesn't contain a root folder."
}


unpack_archive() {
    local archive="$1"
    local filename=$(basename "$archive")
    local basename="${filename%.*}"
    local mime_type=$(file -b --mime-type "$archive")
    local temp_dir=$(mktemp -d)

    # Check available disk space
    local required_space=$(du -b "$archive" | cut -f1)
    local available_space=$(df -P . | awk 'NR==2 {print $4}')

    if [ $available_space -lt $required_space ]; then
        echo "Error: Not enough disk space to unpack the archive."
        rm -rf "$temp_dir"
        return 1
    fi

    case "$mime_type" in
        "application/x-tar"|"application/gzip"|"application/x-bzip2"|"application/x-xz")
            if ! command -v tar &> /dev/null; then
                echo "Error: tar command not found"
                rm -rf "$temp_dir"
                return 1
            fi
            tar -xvf "$archive" -C "$temp_dir" || {
                echo "Error: Failed to extract archive"
                rm -rf "$temp_dir"
                return 1
            }
            ;;
        "application/zip")
            if ! command -v unzip &> /dev/null; then
                echo "Error: unzip command not found"
                rm -rf "$temp_dir"
                return 1
            fi
            unzip "$archive" -d "$temp_dir" || {
                echo "Error: Failed to extract archive"
                rm -rf "$temp_dir"
                return 1
            }
            ;;
        *)
            echo "Error: Unsupported archive type: $mime_type"
            rm -rf "$temp_dir"
            return 1
            ;;
    esac

    # Check if the archive created a root folder
    local extracted_files=("$temp_dir"/*)
    local num_extracted=${#extracted_files[@]}

    if [ $num_extracted -eq 1 ] && [ -d "${extracted_files[0]}" ]; then
        echo "Archive already has a root folder: ${extracted_files[0]}"
        mv "${extracted_files[0]}" . || {
            echo "Error: Failed to move extracted folder"
            rm -rf "$temp_dir"
            return 1
        }
    else
        echo "Creating root folder: $basename"
        mkdir "$basename" || {
            echo "Error: Failed to create root folder"
            rm -rf "$temp_dir"
            return 1
        }
        mv "$temp_dir"/* "$basename" || {
            echo "Error: Failed to move extracted files"
            rm -rf "$temp_dir"
            return 1
        }
    fi

    rm -rf "$temp_dir"
    echo "Archive unpacked successfully"
}


if [ "$1" = "--help" ]; then
    show_help
    exit 0
fi

if [ $# -eq 0 ]; then
    echo "Error: No archive file specified"
    echo "Use --help for usage information"
    exit 1
fi

unpack_archive "$1"
