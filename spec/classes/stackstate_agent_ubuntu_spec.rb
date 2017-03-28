require 'spec_helper'

describe 'stackstate_agent::ubuntu' do
  let(:facts) do
    {
      osfamily: 'debian',
      operatingsystem: 'Ubuntu'
    }
  end

  it do
    contain_file('/etc/apt/sources.list.d/stackstate.list')\
      .with_content(%r{deb\s+https://dl.bintray.com/stackstate-agent/stackstate-agent-deb-repo/})
  end

  # it should install the mirror
  it { should contain_stackstate_agent__ubuntu__install_key('C7A7DA52') }
  it { should contain_stackstate_agent__ubuntu__install_key('382E94DE') }
  it do
    should contain_file('/etc/apt/sources.list.d/stackstate.list')\
      .that_notifies('Exec[stackstate_apt-get_update]')
  end
  it { should contain_exec('stackstate_apt-get_update') }

  # it should install the packages
  it do
    should contain_package('apt-transport-https')\
      .that_comes_before('File[/etc/apt/sources.list.d/stackstate.list]')
  end
  it do
    should contain_package('stackstate-agent-base')\
      .with_ensure('absent')\
      .that_comes_before('Package[stackstate-agent]')
  end
  it do
    should contain_package('stackstate-agent')\
      .that_requires('File[/etc/apt/sources.list.d/stackstate.list]')\
      .that_requires('Exec[stackstate_apt-get_update]')
  end

  # it should be able to start the service and enable the service by default
  it do
    should contain_service('stackstate-agent')\
      .that_requires('Package[stackstate-agent]')
  end
end
