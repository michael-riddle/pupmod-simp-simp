# == Class: simp::puppetdb
#
# This class enables a PuppetDB server with defaults set for SIMP
# compatibility.
#
# NOTE: Hiera variables *must* be set appropriately under the puppetdb
# namespace.
#
# == Parameters
#
# [*client_nets*]
#   Type: Array of IP Addresses/Hostnames
#   Default: hiera('client_nets',['127.0.0.1'])
#
#   This is used to allow specific hosts access to PuppetDB. This should be
#   restricted to only those hosts that need to talk to PuppetDB, primarly
#   Puppet Masters.
#
#   Unfortunately, this cannot be set via exported resources since PuppetDB
#   needs to be running prior to exported resources functioning properly. Once
#   PuppetDB is up, then you can switch this to exported resources mode using
#   the *use_exported_resources* variable.
#
# All other parameters are taken directly from puppetdb::server and will be
# collapsed into an embedded Hieradata file when data in modules exists.
#
# == Authors
#
#   * Trevor Vaughan <tvaughan@onyxpoint.com>
#
class simp::puppetdb (
  $client_nets              = hiera('client_nets',['127.0.0.1']),
  $listen_address           = '127.0.0.1',
  $listen_port              = '8138',
  $open_listen_port         = false,
  $ssl_listen_address       = '0.0.0.0',
  $ssl_listen_port          = hiera('puppetdb::master::config::puppetdb_port','8139'),
  $disable_ssl              = false,
  $open_ssl_listen_port     = $puppetdb::params::open_ssl_listen_port,
  $ssl_dir                  = $puppetdb::params::ssl_dir,
  $ssl_set_cert_paths       = $puppetdb::params::ssl_set_cert_paths,
  $ssl_cert_path            = $puppetdb::params::ssl_cert_path,
  $ssl_key_path             = $puppetdb::params::ssl_key_path,
  $ssl_ca_cert_path         = $puppetdb::params::ssl_ca_cert_path,
  $ssl_deploy_certs         = $puppetdb::params::ssl_deploy_certs,
  $ssl_key                  = $puppetdb::params::ssl_key,
  $ssl_cert                 = $puppetdb::params::ssl_cert,
  $ssl_ca_cert              = $puppetdb::params::ssl_ca_cert,
  $database                 = $puppetdb::params::database,
  $database_host            = $puppetdb::params::database_host,
  $database_port            = $puppetdb::params::database_port,
  $database_username        = $puppetdb::params::database_username,
  $database_password        = passgen('simp_puppetdb'),
  $database_name            = $puppetdb::params::database_name,
  $database_ssl             = $puppetdb::params::database_ssl,
  $node_ttl                 = $puppetdb::params::node_ttl,
  $node_purge_ttl           = $puppetdb::params::node_purge_ttl,
  $report_ttl               = $puppetdb::params::report_ttl,
  $gc_interval              = $puppetdb::params::gc_interval,
  $log_slow_statements      = $puppetdb::params::log_slow_statements,
  $conn_max_age             = $puppetdb::params::conn_max_age,
  $conn_keep_alive          = $puppetdb::params::conn_keep_alive,
  $conn_lifetime            = $puppetdb::params::conn_lifetime,
  $puppetdb_package         = $puppetdb::params::puppetdb_package,
  $puppetdb_version         = 'latest',
  $puppetdb_service         = $puppetdb::params::puppetdb_service,
  $puppetdb_service_status  = $puppetdb::params::puppetdb_service_status,
  $puppetdb_user            = $puppetdb::params::puppetdb_user,
  $puppetdb_group           = $puppetdb::params::puppetdb_group,
  $read_database            = $puppetdb::params::read_database,
  $read_database_host       = $puppetdb::params::read_database_host,
  $read_database_port       = $puppetdb::params::read_database_port,
  $read_database_username   = 'simp_puppetdb',
  $read_database_password   = passgen('simp_read_puppetdb'),
  $read_database_name       = 'simp_puppetdb',
  $read_database_ssl        = true,
  $read_log_slow_statements = $puppetdb::params::read_log_slow_statements,
  $read_conn_max_age        = $puppetdb::params::read_conn_max_age,
  $read_conn_keep_alive     = $puppetdb::params::read_conn_keep_alive,
  $read_conn_lifetime       = $puppetdb::params::read_conn_lifetime,
  $confdir                  = $puppetdb::params::confdir,
  $manage_firewall          = false,
  $java_args                = [
                                '-Djava.io.tmpdir=/var/lib/puppetdb',
                                '-XX:-HeapDumpOnOutOfMemoryError',
                                '-Djava.net.preferIPv4Stack=true'
                              ],
  $max_threads              = $puppetdb::params::max_threads,
) inherits puppetdb::params {

  validate_net_list($client_nets)

  include ::iptables

  class { '::puppetdb':
    listen_address           => $listen_address,
    listen_port              => $listen_port,
    open_listen_port         => $open_listen_port,
    ssl_listen_address       => $ssl_listen_address,
    ssl_listen_port          => $ssl_listen_port,
    disable_ssl              => $disable_ssl,
    open_ssl_listen_port     => $open_ssl_listen_port,
    ssl_dir                  => $ssl_dir,
    ssl_set_cert_paths       => $ssl_set_cert_paths,
    ssl_cert_path            => $ssl_cert_path,
    ssl_key_path             => $ssl_key_path,
    ssl_ca_cert_path         => $ssl_ca_cert_path,
    ssl_deploy_certs         => $ssl_deploy_certs,
    ssl_key                  => $ssl_key,
    ssl_cert                 => $ssl_cert,
    ssl_ca_cert              => $ssl_ca_cert,
    database                 => $database,
    database_host            => $database_host,
    database_port            => $database_port,
    database_username        => $database_username,
    database_password        => $database_password,
    database_name            => $database_name,
    database_ssl             => $database_ssl,
    node_ttl                 => $node_ttl,
    node_purge_ttl           => $node_purge_ttl,
    report_ttl               => $report_ttl,
    gc_interval              => $gc_interval,
    log_slow_statements      => $log_slow_statements,
    conn_max_age             => $conn_max_age,
    conn_keep_alive          => $conn_keep_alive,
    conn_lifetime            => $conn_lifetime,
    puppetdb_package         => $puppetdb_package,
    puppetdb_version         => $puppetdb_version,
    puppetdb_service         => $puppetdb_service,
    puppetdb_service_status  => $puppetdb_service_status,
    puppetdb_user            => $puppetdb_user,
    puppetdb_group           => $puppetdb_group,
    read_database            => $read_database,
    read_database_host       => $read_database_host,
    read_database_port       => $read_database_port,
    read_database_username   => $read_database_username,
    read_database_password   => $read_database_password,
    read_database_name       => $read_database_name,
    read_database_ssl        => $read_database_ssl,
    read_log_slow_statements => $read_log_slow_statements,
    read_conn_max_age        => $read_conn_max_age,
    read_conn_keep_alive     => $read_conn_keep_alive,
    read_conn_lifetime       => $read_conn_lifetime,
    confdir                  => $confdir,
    manage_firewall          => $manage_firewall,
    java_args                => $java_args,
    max_threads              => $max_threads,
  }

  iptables::add_tcp_stateful_listen { 'puppetdb':
    dports      => [$::puppetdb::ssl_listen_port],
    client_nets => $client_nets
  }
}
