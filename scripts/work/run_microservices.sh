#!/bin/bash
gnome-terminal --tab -- bash -ic "export TITLE_DEFAULT='Administration'; cd ~/Trobbit/TrobbitAdministration; nest start --watch; exec bash;"
gnome-terminal --tab -- bash -ic "export TITLE_DEFAULT='Operation'; cd ~/Trobbit/TrobbitOperation; nest start --watch; exec bash;"
gnome-terminal --tab -- bash -ic "export TITLE_DEFAULT='Security'; cd ~/Trobbit/TrobbitSecurity; nest start --watch; exec bash;"
gnome-terminal --tab -- bash -ic "export TITLE_DEFAULT='Gateway'; cd ~/Trobbit/TrobbitApi; nest start --watch; exec bash;"
gnome-terminal --tab -- bash -ic "export TITLE_DEFAULT='Client'; cd ~/Trobbit/TrobbitClient; npm start; exec bash;"
gnome-terminal --tab -- bash -ic "export TITLE_DEFAULT='Socket'; cd ~/Trobbit/TrobbitSocket; nest start --watch; exec bash;"


