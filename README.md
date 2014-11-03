#output the list of repos as a webpage
bundle install
./app/repos.rb > repos.html

#open in a browser (MacOS)
open repos.html

#open in a browser (GNOME desktop)
gtk-open repos.html

#open in a browser (GNOME windows)
start repos.html

