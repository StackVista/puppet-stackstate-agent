require 'spec_helper'

describe 'stackstate_agent::integrations::ceph' do
  let(:facts) {{
    operatingsystem: 'Ubuntu',
  }}
  let(:conf_dir) { '/etc/sts-agent/conf.d' }
  let(:dd_user) { 'sts-agent' }
  let(:dd_group) { 'root' }
  let(:dd_package) { 'stackstate-agent' }
  let(:dd_service) { 'stackstate-agent' }
  let(:conf_file) { "#{conf_dir}/ceph.yaml" }
  let(:sudo_conf_file) { '/etc/sudoers.d/stackstate_ceph' }

  it { should compile.with_all_deps }
  it { should contain_file(conf_file).with(
    owner: dd_user,
    group: dd_group,
    mode: '0600',
  )}
  it { should contain_file(conf_file).that_requires("Package[#{dd_package}]") }
  it { should contain_file(conf_file).that_notifies("Service[#{dd_service}]") }

  context 'with default parameters' do
    it { should contain_file(conf_file).with_content(/tags:\s+- name:ceph_cluster\s*?[^-]/m) }
    it { should contain_file(conf_file).with_content(/^\s*ceph_cmd:\s*\/usr\/bin\/ceph\s*?[^-]/m) }
    it { should contain_file(conf_file).with_content(/^\s*use_sudo:\sTrue$/) }
    it { should contain_file(sudo_conf_file).with_content(/^sts-agent\sALL=.*NOPASSWD:\/usr\/bin\/ceph$/) }
  end

end
