require 'spec_helper'

describe 'emacs' do
  let(:version) { '24.1-boxen1' }
  let(:facts) { { :boxen_home => '/opt/boxen' } }

  it { should include_class('homebrew') }
  it { should contain_package('boxen/brews/emacs').with_ensure(version) }

  it do
    should contain_file('/Applications/Emacs.app').with({
      :ensure  => 'link',
      :target  => "/opt/boxen/homebrew/Cellar/#{version}/Emacs.app",
      :require => 'Package[boxen/brews/emacs]',
    })
  end
end
