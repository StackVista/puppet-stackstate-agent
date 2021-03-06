require 'spec_helper'

describe 'stackstate_agent::integrations::haproxy' do
  let(:facts) {{
    operatingsystem: 'Ubuntu',
    ipaddress: '1.2.3.4',
  }}
  let(:conf_dir) { '/etc/sts-agent/conf.d' }
  let(:dd_user) { 'sts-agent' }
  let(:dd_group) { 'root' }
  let(:dd_package) { 'stackstate-agent' }
  let(:dd_service) { 'stackstate-agent' }
  let(:conf_file) { "#{conf_dir}/haproxy.yaml" }

  it { should compile.with_all_deps }
  it { should contain_file(conf_file).with(
    owner: dd_user,
    group: dd_group,
    mode: '0644',
  )}
  it { should contain_file(conf_file).that_requires("Package[#{dd_package}]") }
  it { should contain_file(conf_file).that_notifies("Service[#{dd_service}]") }

  context 'with default parameters' do
    it { should contain_file(conf_file).with_content(%r{url: http://1.2.3.4:8080}) }
    it { should contain_file(conf_file).without_content(%r{username: }) }
    it { should contain_file(conf_file).without_content(%r{password: }) }
  end

  context 'with url set' do
    let(:params) {{
      url: 'http://foo.bar:8421',
    }}
    it { should contain_file(conf_file).with_content(%r{url: http://foo.bar:8421}) }
  end

  context 'with creds set correctly' do
    let(:params) {{
      creds: {
        'username' => 'foo',
        'password' => 'bar',
      },
    }}
    it { should contain_file(conf_file).with_content(%r{username: foo}) }
    it { should contain_file(conf_file).with_content(%r{password: bar}) }
  end

  context 'with creds set incorrectly' do
    let(:params) {{
      'invalid' => 'is this real life',
    }}

    skip 'functionality not yet implemented' do
      it { should contain_file(conf_file).without_content(/invalid: is this real life/) }
    end
  end

  context 'with instances set' do
    let(:params) {{
      instances: [
        {
          'url'   => 'http://foo.bar:8421',
          'creds' => {
            'username' => 'foo',
            'password' => 'bar',
          }
        },
        {
          'url'   => 'http://shoe.baz:1248',
          'creds' => {
            'username' => 'shoe',
            'password' => 'baz',
          }
        },
      ]
    }}
    it { should contain_file(conf_file).with_content(%r{url: http://foo.bar:8421}) }
    it { should contain_file(conf_file).with_content(%r{username: foo}) }
    it { should contain_file(conf_file).with_content(%r{password: bar}) }
    it { should contain_file(conf_file).with_content(%r{url: http://shoe.baz:1248}) }
    it { should contain_file(conf_file).with_content(%r{username: shoe}) }
    it { should contain_file(conf_file).with_content(%r{password: baz}) }
  end
end
