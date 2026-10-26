# This configuration file will be evaluated by Puma. The top-level methods that
# are invoked here are part of Puma's configuration DSL. For more information
# about methods provided by the DSL, see https://puma.io/puma/Puma/DSL.html.
#
# 2026 update: rewritten for Puma 6+ (the old Puma 3.11 had request-smuggling
# vulnerabilities, e.g. CVE-2020-11076, CVE-2021-41136, CVE-2022-24790).

# Puma handles each request on a thread; 3 is a good default for a small app.
threads_count = ENV.fetch("RAILS_MAX_THREADS", 3)
threads threads_count, threads_count

# Specifies the `port` that Puma will listen on to receive requests; default is 3000.
port ENV.fetch("PORT", 3000)

# Allow puma to be restarted by `bin/rails restart` command.
plugin :tmp_restart

# Specify the PID file. Defaults to tmp/pids/server.pid in development.
pidfile ENV["PIDFILE"] if ENV["PIDFILE"]
