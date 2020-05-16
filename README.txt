=== Server scripts ===
== Description ==

Scripts to hel a home server run


Usage
-----
Copy the files in a dirtectory that suits you, Edit the Files to match your desired route to the logs otuputted by the scripts.
You can also use cron to schedule the execution.

## Admin menu

* The admin can choose up to five different themes from the installed ones to be changed by selecting them in a drop down at the beginning of each tab of the configuration page. Note that you can select the same theme several times if you run out of mods.
* You can force the selector to be displayed at the top of the page instead of using a widget or a shortcode.
* You can configure the style of the selector for each theme.
* At each theme tab the admin can set up to ten color modifications to classes or individual elements.
	### Admin menuOptions fields
	* Name an option to be displayed to the user. This option will be added in the select input field.
	* Select wich type of style will be changed, class or individual element. If you used the web developer tools of yor browser to determine the elements you want to alter, an individual element is named by an "id", and class by "class". A class often has several elements. Remember to enter exactly the name, errors will be thrown if the names are incorrect and maybe the page functionality will be altered.</p>
	* Type the element id or class to be altered.
	* Select the color of the background in the color selector tool.
	* Select the color of the font in the color selector tool.
	* Choose the transparency of the background, it will be dinamically updated over an image below.
	* Choose the transparency of the text, it will be dinamically updated over an image below.
	* The option button indicates if the edited option will be used by the plugin. No options will be added if they aren't active.
	* Save yor changes clicking the blue button at the end of the page</p>
	
### Displaying the select drop down
	* There are currently two options, fist is to add the "Style selector widget" that this plugin creates to any sidebar. You can also configure a title for the widget.
	* The second is via a shortcode. Place the shortcode "[s_selector]" anywhere to display the drop down menu
	* Additionally is a last minute adittion, you can uncoment the las line of the widget-selector.php file in the /public/partials dir of the pulugin directory using the wordpress plugin editor to show the drop down at the start of each page.

## Frontend
	* The user can choose between a default "Restore" option, and the ones defined by you. This option is persistent.
	* The user can select the size of the text. This option is not persistent.
	
== Installation ==

1 a. Upload `styleselector` directory to the `/wp-content/plugins/` directory
2 a. Activate the plugin through the 'Plugins' menu in WordPress

1 b. Upload the zip with the "Upload plugin" Administrator menu option.
2 b. Activate it.

3. An new option "Style selector" will appear in the settting menu. There will be the configuration screen.

== Frequently Asked Questions ==

= Works with multisites? =

Tested in a multisite with * domain names and works fine. Can't say yet if in a MU with only one domain will work the same.

= Works with xxx theme? =

Can't say. CSS is sometimes tricky and is nor always clear which element to change.
Some themes may prevent tampering or have dynamic HTML5 and javascript updates of the styles.

= Why can't I add my own stylesheet? =

This plugin isn't a theme switcher, neither a customizer, it just changes colors and size of the fonts for better reading.

= I have updated the plugin and fonts doesn't change size. =

Try refreshing all caches, sometimes it takes time to reload styles and scripts.


== Screenshots ==
1. Page dark themed by the plugin.
2. Page restored by the plugin.
3. Options panel. Here you configure the plugin
4. Inspector developer tool of a browser. You can use it to explore the elements of a page.

== Changelog ==
= 1.1.2 =
Patched a bug in the font loop.
Added option to present icons instead of a drop down select menu.

== Changelog ==
= 1.1.1 =

Size is set when loading to prevent font-size=0

= 1.1.0 =
Added font size to frontend.
Configurable selector.
Optional force selector on head.
Added fields to options database.
Some spelling errors corrected.
Added "overflow:auto" to options boxes.
Added some nonsense to the FAQ.

= 1.0 =
First version

== Upgrade Notice ==
= 1.1.2 =
Adde icons option, patched font size bug.

= 1.1.1 =

Size is set when loading to prevent font-size=0

= 1.1.0 =

Added some fronted and backend options. Corrected spelling and deleted some unneded code.

= 1.0 =
Plugin release.

== TODO ==
JSON export/import of settings.
Prepare code for translation.
Clean a bit the code.
Add background image backend option.

== Directories explanation ==
* styleselector: contains subdirectories, license, readme and unistall files.
 "styleselector.php" Bootstrap
 "uninstall.php" Unistall file made by the boilerplate plugin generator.
 "index.php" Blank file made by the boilerplate plugin generator.

* admin: Where the config routines reside. Has an css dir with the styles of the config page, a js dir with client side routines, mostly appearence related ones. Partials, where the display of options are made. And two files, index.php, bank, and class-styleselector where main routines reside.
* public: has the same structure of the admin one. In partial has also a widget management routines file. 
* assets: images and media needed by the plugin.
* includes: general routines to make the pluging integrate witn Wordpress.