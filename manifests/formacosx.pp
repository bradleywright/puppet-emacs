# Public: Install Emacs.app from EmacsForMacOSX
#
# Examples
#
#   include emacs::formacosx
class emacs::formacosx {
  package { 'Emacs':
    provider => 'appdmg',
    source   => 'http://emacsformacosx.com/emacs-builds/Emacs-24.3-universal-10.6.8.dmg',
    notify   => Exec['fix-emacs-termcap'],
  }

  # So ansi-term behaves itself: http://stackoverflow.com/a/8920373
  exec { 'fix-emacs-termcap':
    command     => 'tic -o \
      ~/.terminfo \
      /Applications/Emacs.app/Contents/Resources/etc/e/eterm-color.ti',
    provider    => shell,
    refreshonly => true,
  }

  file { "${boxen::config::envdir}/emacs-macosx.sh":
    content => template('emacs/macosx-env.sh.erb'),
    require => File[$boxen::config::envdir]
  }
}
