# README

This README would normally document whatever steps are necessary to get the
application up and running.

Things you may want to cover:

* Ruby version - Created with Version 2.2.5

* System dependencies = minimal :D

* Configuration = Fan Blog

* Database creation = SQLite3

* Database initialization = VERY STABLE

* Deployment instructions (AKA how to run and see the site on your machine)

Pre instructions - If you get lost at any point and you need documentational help aside from this please visit https://guides.rubyonrails.org/getting_started.html for further guidence if needed.

Step 1

* You will need to install rails and SQLite3 on your machine in order to view/ use this site.

Open up a command line prompt. On macOS open Terminal.app, on Windows choose "Run" from your Start menu and type 'cmd.exe'. Any commands prefaced with a dollar sign $ should be run in the command line. Verify that you have a current version of Ruby installed:

$ ruby -v

the return should look something similar to this 

ruby 2.3.1p112

Please note Rails requires Ruby version 2.2.2 or later. If the version number returned is less than that number, you'll need to install a fresh copy of Ruby.

Step 2

A number of tools exist to help you quickly install Ruby and Ruby on Rails on your system. Windows users can use Rails Installer, while macOS users can use Tokaido. For more installation methods for most Operating Systems take a look at https://ruby-lang.org

If you are working on Windows, you should also install the Ruby Installer Development Kit.

You will also need an installation of the SQLite3 database. Many popular UNIX-like OSes ship with an acceptable version of SQLite3. On Windows, if you installed Rails through Rails Installer, you already have SQLite installed. Others can find installation instructions at the SQLite3 website. Verify that it is correctly installed and in your PATH:

$ sqlite3 --version

The program should report its version.

To install Rails, use the gem install command provided by RubyGems:

$ gem install rails

To verify that you have everything installed correctly, you should be able to run the following:

$ rails --version

If it says something like "Rails 5.2.1", you are ready to continue.


Step 3

YOU MEET ALL THE PREREQUIRMENTS YAY! You can now download the project files off my Github if you havent already done so.

Link to my Github - https://github.com/rfcowgillIV

once downloaded to your machine make sure to unzip the files where you wish to store them. Then open your terminal or command prompt and CD into the project.

typically the command will look someithing similar to 

CD /downloads/blog

or change the names of the folders to match your machines.


Step 4

Once you are in the project then you need to run the rails server in order to access the database accociated with the website.
This is a fan site that allows fans to go on and post articles about anything realted to the show: fan theroys, favorite epsisodes, quotes ECT. So some articles will already be loaded by default, feel free to read them at your leasure.

In order to run the rails server then type the command 

rails server 

into your termianl/ command prompt and the rails server will then proceed to run. Once the command is through running you are able to access the site.

Open your perfered browser on your machine and go to the url

http://localhost:3000

this is the url that the project is displayed in locally on your machine.

Step 5

The best step! Explore the site!!

