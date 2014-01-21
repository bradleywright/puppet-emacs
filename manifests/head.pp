# Public: Install HEAD Emacs.app from homebrew into /Applications.
#
# Examples
#
#   include emacs::head
class emacs::head {
  require homebrew

  $version = 'HEAD'

  homebrew::formula { 'emacs':
    before => Package['emacs'];
  }

  package { 'emacs':
    ensure          => $version,
    install_options => ['--cocoa'],
    notify          => Exec['fix-emacs-head-termcap'],
  }

  $target = "${homebrew::config::installdir}/Cellar/emacs/${version}/Emacs.app"

  file { '/Applications/Emacs.app':
    ensure  => link,
    target  => $target,
    require => Package['emacs'],
  }

    # So ansi-term behaves itself: http://stackoverflow.com/a/8920373
  exec { 'fix-emacs-head-termcap':
    command     => "tic -o \
      ~/.terminfo \
      ${target}/Contents/Resources/etc/e/eterm-color.ti",
    provider    => shell,
    refreshonly => true,
  }

  file { "${boxen::config::envdir}/emacs-macosx.sh":
    content => template('emacs/macosx-env.sh.erb'),
    require => File[$boxen::config::envdir]
  }
}
