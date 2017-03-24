require 'spec_helper'

describe 'stackstate_agent::redhat' do
  let(:facts) do
    {
      osfamily: 'redhat',
      operatingsystem: 'Fedora',
      architecture: 'x86_64'
    }
  end

  # it should install the mirror
  context 'with manage_repo => true' do
    let(:params){ {:manage_repo => true} }
    it do
      should contain_yumrepo('stackstate')
        .with_enabled(1)\
        .with_gpgcheck(1)\
          .with_gpgkey('https://yum.stackstate.com/STACKSTATE_RPM_KEY.public')\
        .with_baseurl('https://yum.stackstate.com/rpm/x86_64/')
    end
  end
  context 'with manage_repo => false' do
    let(:params){ {:manage_repo => false} }
    it do
      should_not contain_yumrepo('stackstate')
    end
  end


  # it should install the packages
  it do
    should contain_package('stackstate-agent-base')\
      .with_ensure('absent')\
      .that_comes_before('Package[stackstate-agent]')
  end
  it do
    should contain_package('stackstate-agent')\
      .with_ensure('latest')
  end

  # it should be able to start the service and enable the service by default
  it do
    should contain_service('stackstate-agent')\
      .that_requires('Package[stackstate-agent]')
  end
end
