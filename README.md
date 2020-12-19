# se_wakatime
Simple macro for SlickEdit to send data to wakatime

## About
This is a very basic Slick-C macro for SlickEdit that sends a heartbeat to wakatime (using the Wakatime CLI client) with a 1 minute interval. A heartbeat is only sent if the file that is open has been modified.

SlickEdit macros use a language called "Slick-C" which is based on the C programming language.

This macro was written by SlickEdit support and modified by myself, SlickEdit was kind enough to allow me to share this macro with others who are also looking for a basic Wakatime plugin for their IDE.

## Installation
_note: This plugis was only tested by myself on Debian GNU/Linux. This plugin should work with all Linux distributions but might need some modification for use with Windows or macOS. Edit line 37 if you don't use Linux or have the wakatime CLI installed in another directory than ~/.local/bin which is de default.

* You need to have [SlickEdit](https://www.slickedit.com "SlickEdit") installed. (_This macro was tested with SlickEdit Professional, I can't confirm if it also works with SlickEdit Standard_).

* You also need a (free) [Wakatime](https://www.wakatime.com "Wakatime") account

* install python3 pip installer (**sudo apt install python3-pip** on Debian based Linux distributions like Ubuntu and Linux mint).

* install the wakatime CLI client (**pip install wakatime**)

* create a wakatime configuration file (if you use _wakatime_ with another editor you should already have this file), the most important thing is the API key.
**touch ~/.wakatime.cfg**

* Edit the wakatime configuration file.
_this is a basic configuration file from wakatime_
**Put your API key (available at [Your Wakatime account](https://wakatime.com/settings/account "your wakatime account") in this configuration file**

~~~~
[settings]
debug = false
api_key = your-api-key
hide_file_names = false
hide_project_names = false
hide_branch_names =
exclude =
    ^COMMIT_EDITMSG$
    ^TAG_EDITMSG$
    ^/var/(?!www/).*
    ^/etc/
include =
    .*
include_only_with_project_file = false
status_bar_icon = true
status_bar_coding_activity = true
offline = true
proxy = https://user:pass@localhost:8080
no_ssl_verify = false
ssl_certs_file =
timeout = 30
hostname = machinename
[projectmap]
projects/foo = new project name
^/home/user/projects/bar(\d+)/ = project{0}
[git]
disable_submodules = false
~~~~
You can also set debug = false to debug = true to let wakatime create a log file **~/.wakatime.log** so you can see if there are any errors. (it's best to disable it again after you've checked it all works fine).

Edit the file **wakatime.e** in your favorite editor and change line 38 from *_str command = "**/home/patrick/.local/bin/wakatime** --plugin slickedit-wakatime --write --entity ":+p_buf_name;* to reflect the location where the Wakatime CLI is installed on your computer (for some reason "~/.local/bin/wakatime" does not work).

* Finally load the plugin into **slickedit**
1. Start Slickedit
2. Click Macro -> Load Macro (F12)
3. navigate to the location where you have downloaded the **wakatime.e** file (don't use your ~/Downloads directory).
4. Click open

* Now check the bottom left corner of the SlickEdit IDE and it should say "*Module(s) Loaded*". This will create a file called **slickedit.ex** which is the compiled macro that SlickEdit loads everytime it starts, so make sure you don't delete it.

## Use
If the installation was done correctly, you can edit files in SlickEdit and see the information in your Wakatime dashboard.

## Troubleshooting
If your data is now shown in wakatime, enable the debug mode and study the *.wakatime.log* file.
Make sure the **proxy** is setup correctly in the config file (or remove that line if you don't us a _proxy server_)

You can also checkout the [Wakatime GitHub page](https://github.com/wakatime/wakatime "wakatime CLI github page") for more information on the CLI client that is used.

### Note
By the way SlickEdit works (the macro is executed before the file is created on disk), wakatime can report a file as "does not exist" and not log it. To **solve** this you can edit and save the file straight after creating it, or create the file manually (with _touch_ for example and then open it it SE).
