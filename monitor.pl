#! /usr/bin/perl

#
# Copyright 2025 Kevin J. Conway kjc@sdlc_by_kjc.mygbiz.com
#
# This program is free software.  You can redistribute it or modify it under
# the terms of version 2 of the GNU General Public License (GPL), as published
# by the Free Software Foundation.
#
# This program is distributed in the hope that it will be useful, but WITHOUT
# ANY WARRANTY -- without even the implied warranty of MERCHANTIBILITY or
# FITNESS FOR A PARTICULAR PURPOSE.  See the text of the GPL for more details.
#
# Version 2 of the GNU General Public License is available at:
#
#   http://www.gnu.org/licenses/old-licenses/gpl-2.0.html
#

# This script offers a simple way to interface twith he lcd_display program to
# send informational messages to the LCD display of a Thecus N5550.  I am not a
# devloper.  I can simply make things wotrj with Perl scripting and some
# determination

# The Thecus LCD display has two (2) lines of twenty (20) characters each
# All messages must be formatted to fit this - the LCD display will ignore
# any text that overruns


#   MAIN   #

# Set the doit flaf so that the loop will run forever

  $doit = 1;

#  While the loop runs


  while ( $doit == 1 )

    {

#  Get CPU Temperatures anfd romat into two lines

    $sensors = `sensors | grep Core | cut -c16-19`;

    $sensors =~ s/\n/\ /g;
    $line_1 = "CPU TEMP ".$sensors."\n";

#  Get the status of the zdata1 zpool 

    $zfs_status = `zpool status | grep errors`;

    chomp $zfs_status;

    if ( $zfs_status =~ m/No known data errors/ )

      {

      $line_2 = "No ZFS errors\n";

      }

    else

      {

      $line_2 = "ZFS problem\n";

      }

#  Call the print_msg subroutine to send the message to the LCD

    print_msg();


#  Get the disk utilization

    $df_sda2 = `df -h | grep sda2  | cut -c35-38`;
    $df_zdata1 = `df -h | grep zdata1  | cut -c35-38`;
  
    chomp $df_sda2;
    chomp $df_zdata1;

    $line_1 = "Grandiose Disk %\n";
    $line_2 = "sda2 ".$df_sda2." zdata1 ".$df_zdata1."\n";

#  Call the print_msg subroutine to send the message to the LCD

    print_msg();


#  Get the machine name and uptime

    $name = `uname -n`;
    chomp $name;
    $line_1 = $name."\n";

    $uptime = `uptime | cut -c13-18`;
    chomp $uptime;
    $line_2 = "Uptime ".$uptime."\n";

#  Call the print_msg subroutine to send the message to the LCD

    print_msg();

#  Check disk status

    $bad_count = 0;
    $good_count = 0;

#  One DOM and five (5) disks are installed

    @DISK_LETTERS = ("a", "b", "c", "d", "e", "f");


     for $disk_letter (@DISK_LETTERS)

       {

       $disk = "\/dev\/sd".$disk_letter;
###     print "Examining disk $disk\n";

       $disk_error = `smartctl -a $disk | grep "ATA Error Count"`;

       if ( $disk_error eq "" )

         {

         $good_count += 1;

         }

       else { $bad_count += 1 }

       }

    $line_1 = "Good disks = $good_count\n";
    $line_2 = "Bad disks = $bad_count\n";                                                                                             
#  Call the print_msg subroutine to send the message to the LCD

    print_msg();

    
##   $doit = 0;

    }

#  END MAIN  #


#  SUBROUTINE  #

# Prints the message to the LCD using the lcd_display executable.
#  All messages must follow the following format.  This calls the 2-Line
# option of the lcd_display executable, prints the two lines of the message
# then quits the executable

# 9
# Line 1 of the message
# Line 2 of the message
# 0

  sub print_msg

    {

#  Open the output file or die

    open (LCD_MSG, ">lcd_msg") or die();
 

#  Print the lines to the output file

    print LCD_MSG "9\n";
    print LCD_MSG $line_1;
    print LCD_MSG $line_2;
    print LCD_MSG "0\n";


#  Close the output file

    close LCD_MSG;


#  Call the lcd_display executable to send the message to the N5550 LCD screen

    `/data/scripts/lcd_display < lcd_msg`;

#  Sleep for 5 seconds to jkeep the message on the screen

    sleep 5;

    }

#  END SUBROUTINES ##
