# mysql-ramdisk-helper

## Introduction

Simple script to setup a ramdisk for development purposes. macOS only at the moment but can be easily updated to work on Linux.

## Script

What we have below isn’t new. I’ve taken what I found in [this blog post](http://kotega.com/blog/2010/apr/12/mysql-ramdisk-osx/) and created a bash script which I can run after each reboot (there is also a teardown script).

## Setup

Copy the `mysql-ramdisk-config.sh.example` file to `mysql-ramdisk-config.sh` and update if required.

## Usage

Run the script from your project (this is required to run the commands in ENVIRONMENT_SETUP_COMMANDS).

```
neil | ~/src/myrailsproject (master) $ ls -1 ../mysql-ramdisk-helper
LICENSE
README.md
mysql-ramdisk-config.sh
mysql-ramdisk-config.sh.example
mysql-ramdisk-setup.sh
mysql-ramdisk-teardown.sh

neil | ~/src/myrailsproject (master) $ ../mysql-ramdisk-helper/mysql-ramdisk-setup.sh
```

## Also

See [my blog post](https://neil.bar/mysql-in-memory-for-faster-testing-41bdafb1e0a9).
