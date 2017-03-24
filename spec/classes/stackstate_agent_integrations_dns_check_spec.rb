require 'spec_helper'

describe 'stackstate_agent::integrations::dns_check' do
  let(:facts) {{
    operatingsystem: 'Ubuntu',
  }}
  let(:conf_dir)   { '/etc/sts-agent/conf.d' }
  let(:dd_user)    { 'sts-agent' }
  let(:dd_group)   { 'root' }
  let(:dd_package) { 'stackstate-agent' }
  let(:dd_service) { 'stackstate-agent' }
  let(:conf_file)  { "#{conf_dir}/dns_check.yaml" }

  it { should compile.with_all_deps }
  it { should contain_file(conf_file).with(
    owner: dd_user,
    group: dd_group,
    mode: '0600',
  )}
  it { should contain_file(conf_file).that_requires("Package[#{dd_package}]") }
  it { should contain_file(conf_file).that_notifies("Service[#{dd_service}]") }

  context 'with default parameters' do
    it { should contain_file(conf_file).with_content(%r{hostname: google.com}) }
    it { should contain_file(conf_file).with_content(%r{nameserver: 8.8.8.8}) }
    it { should contain_file(conf_file).with_content(%r{timeout: 5}) }
  end

  context 'with parameters set' do
    let(:params) {{
      checks: [
        {
          'hostname'   => 'example.com',
          'nameserver' => '1.2.3.4',
          'timeout'    => 5,
        },
        {
          'hostname'   => 'localdomain.com',
          'nameserver' => '4.3.2.1',
          'timeout'    => 3,
        }
      ]
    }}

    it { should contain_file(conf_file).with_content(%r{hostname: example.com}) }
    it { should contain_file(conf_file).with_content(%r{nameserver: 1.2.3.4}) }
    it { should contain_file(conf_file).with_content(%r{timeout: 5}) }
    it { should contain_file(conf_file).with_content(%r{hostname: localdomain.com}) }
    it { should contain_file(conf_file).with_content(%r{nameserver: 4.3.2.1}) }
    it { should contain_file(conf_file).with_content(%r{timeout: 3}) }
  end
end
