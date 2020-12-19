/*!
 SlickEdit macro wakatime.e
 Author SlickEdit Support, SlickEdit Inc 11/2020
 
 This script executes the commandline client for Wakatime every 1 minute (default)
 which sends a "heartbeat" containing the editor name and the filename to wakatime.com
 
 make sure the wakatime CLI client is installed (pip install wakatime) and that the configuration
 contains your private API-Key (available at: https://wakatime.com/settings/account)
 
 This macro is only tested on Debian GNU/Linux, but should work on other Linux distributions.
 If you want to use this on a Windows or macOS machine you will need to edit the line containing
 the command (_str_command = "...":+p_buf_name;)
 
 Edited by Patrick Kox (November 13, 2020)
*/
#pragma option(pedantic,on)
#include "slick.sh"

static int periodic_timer_handle;
static int debugging=0;               // we assume the user is debugging the code and not editing it.

definit()
{
   periodic_timer_handle = -1;
}

// This is the function that will be called by the timer.
void periodic_callback()
{
   // This command is user specific Change /home/patrick/.local/bin/wakatime to the location 
   // where the CLI Plugin is installed. (linux default is ~/.local/bin/)
   // --plugin slickedit-wakatime let's Wakatime report this as comming from 
   //   Slickedit (so it will show as Slickedit in the Wakatime Dashboard.
   // --write indicates that there was written to the file. 
   // --entity refers to the file that was edited/saved (p_buf_name = the open 
   //   buffer) 
   _str command = "/home/patrick/.local/bin/wakatime --plugin slickedit-wakatime --write --entity ":+p_buf_name;
    
   // execute the command if the file was modified since the last time the 
   // function was called. (~/.wakatime.log) to check for errors. make sure 
   // "api_key = " is set to your Wakatime private api_key optinally set 
   // "hostname = " to your hostname so Wakatime can keep track of what host was 
   // used to edit the files. 
      
      // check if the file was modified, and only then executes the wakatime CLI client 
      // (if the file is not modified and wakatime is called, it won't be logged anyway).
      if (p_modify > 0) {
         shell(command);
      }
      
}

void start_periodic_timer()
{
   // Only start if it hasn't been started already.
   if (periodic_timer_handle < 0) {
      PERIOD_IN_MINUTES := 1;          // The wakatime default time between hearthbeats is 2 minutes
      periodic_timer_handle = _set_timer(PERIOD_IN_MINUTES * 60 * 1000, periodic_callback);
   }
}

void stop_periodic_timer()
{
   if (periodic_timer_handle >= 0 && _timer_is_valid(periodic_timer_handle)) {
      _kill_timer(periodic_timer_handle);
      periodic_timer_handle = -1;
   }
}

void _prjopen_waka()
{
   // This call_list hook ensure the hook is started as soon as a project is started. 
   start_periodic_timer();
}

void _buffer_add_waka()
{
   // Executed when a new file is added.
   // For some reason this causes Wakatime to give a "File not found error"
   _str command = "/home/patrick/.local/bin/wakatime --plugin slickedit-wakatime --write --entity ":+p_buf_name;
   shell(command);
} 

void _switchbuf_waka () // uncomment the last 2 lines of this function to have wakatime update everytime a new file/buffer
                        // is opened. This will cause a substantial delay when switching between files in the editor.
{
   // Executed when a new file is opened or when switching file-tabs.
   // This causes a delay when opening another file/tab.
   //   _str command = "/home/patrick/.local/bin/wakatime --plugin slickedit-wakatime --write --entity ":+p_buf_name;
   //   shell(command);
}

