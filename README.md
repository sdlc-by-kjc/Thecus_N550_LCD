# Thecus_N550_LCD
This repository contains some very simple scripts for controlling the LCD module on the Thecus N5550.  I am not a developer per se, just someone who can make things work with some Perl scripting and determineation.

My Thecus N5550 is running Ubuntu Mint as a seco0ndary NAS.  This distro runs well and allows me to utilize ZFS from the distribution.  The Thecus N5550 works fine as a lightweight secondary NAS.  My NAS is fully populatd with 4GB of RAM and 5 3TB drives.

My solution is based on the excellent work that @ipilcher contributed.  I have modified his "test.c" program so that the PIC is no lnger referenced an so that there is no menu output.  My script simply writes a file that redirects into the "test.c" program to update the LCD screen of the Thecus N5550.  This works well to utilize the LCD screen for an at-a-glance idea of any issues that the NAS may be having.  It should be very essy for anyone to make changes for their own particular needs.

This may woprk for other Thecus NAS that are also using the same LCD display and running any form of Linux.

Files:

lcd_display.c - the C program modified from test.c
monitor.pl - my perl script that monitors various conditions on the NAS and updates the LCD screen

Installation:

I placed all of my files in /data/scripts.  The script will run at boot from the root crontab.

1) Compile lcd_display.c using "cc lcd_disply.c"
2) Copy a.out to lcd_display
3) Make lcd_display executable - chmod 755 lcd_display
4) Make monitor.pl executable - chmod 755 monitor.pl
5) Create an entry in the root crontab - "@reboot /data/scripts/monitor.pl"

Testing:

1) Run the monitor.pl script as "./monitor.pl".  The LCD screen should change from showing "Self testing..." to a cycled display of information anout your Thecus N5550.
2) Reboot
3) The LCD display should show the output of the script once the NAS has completed a boot


