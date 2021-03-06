# == Class: simp::rsyslog::stock
#
# Enable an rsyslog stock configuration.
#
# == Parameters
#
# [*is_server*]
# Type: Boolean
# Default: false
#   If true, use the server stock class, otherwise simply make this system a
#   client.
#
# [*security_relevant_logs*]
# Type: The selector logic portion of a rsyslog rule.
# Default: "if \$programname == 'sudosh' or \$programname == 'yum' or \$syslogfacility-text = 'cron' or \$syslogfacility-text == 'authpriv' or \$syslogfacility-text == 'local5' or \$syslogfacility-text == 'local6' or \$syslogfacility-text == 'local7' or \$syslogpriority-text == 'emerg' or ( \$syslogfacility-text == 'kern' and \$msg startswith 'IPT:' ) then"
#   This is the selector logic of an rsyslog rule. You can put anything here,
#   just please test it on a running system first!
#   Also, remember that most SIMP subsystems are configured to send to
#   local6.notice for their security logs.
#
# == Authors
#   * Trevor Vaughan <tvaughan@onyxpoint.com>
#
class simp::rsyslog::stock (
  $is_server = false,
  $security_relevant_logs = "if \$programname == 'sudosh' or \$programname == 'yum' or \$syslogfacility-text == 'cron' or \$syslogfacility-text == 'authpriv' or \$syslogfacility-text == 'local5' or \$syslogfacility-text == 'local6' or \$syslogfacility-text == 'local7' or \$syslogpriority-text == 'emerg' or ( \$syslogfacility-text == 'kern' and \$msg startswith 'IPT:' ) then"
){
  include 'rsyslog'
  include 'logrotate'
  include 'rsyslog::global'

  # This is just in case someone includes rsyslog::stock::log_server directly.
  if $is_server or defined(Class['rsyslog::stock::log_server']) {
    include 'rsyslog::stock::log_server'
  }
  else {
    include 'rsyslog::stock::log_local'
  }

  validate_bool($is_server)
  validate_string($security_relevant_logs)
}
