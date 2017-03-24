require 'spec_helper'

describe "stackstate_agent::integration" do
    let (:title) { "test" }
    let(:facts) do
      {
        operatingsystem: 'CentOS',
        osfamily: 'redhat'
      }
    end
    let (:params) {{
        :instances => [
            { 'one' => "two" }
        ]
    }}
    it { should compile }
    it { should contain_file('/etc/sts-agent/conf.d/test.yaml').with_content(/init_config: /) }
    gem_spec = Gem.loaded_specs['puppet']
    if gem_spec.version >= Gem::Version.new('4.0.0')
      it { should contain_file('/etc/sts-agent/conf.d/test.yaml').with_content(/---\ninit_config: \ninstances:\n- one: two\n/) }
    else
      it { should contain_file('/etc/sts-agent/conf.d/test.yaml').with_content(/--- \n  init_config: \n  instances: \n    - one: two/) }
    end
    it { should contain_file('/etc/sts-agent/conf.d/test.yaml').that_notifies("Service[stackstate-agent]") }
end
