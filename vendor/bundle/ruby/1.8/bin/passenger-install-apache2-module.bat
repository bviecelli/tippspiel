@ECHO OFF
IF NOT "%~f0" == "~f0" GOTO :WinNT
@"ruby.exe" "C:/_daten/mothes/tippspiel/tippspiel_mit_rails/vendor/bundle/ruby/1.8/bin/passenger-install-apache2-module" %1 %2 %3 %4 %5 %6 %7 %8 %9
GOTO :EOF
:WinNT
@"ruby.exe" "%~dpn0" %*
