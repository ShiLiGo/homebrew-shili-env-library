class Uwsgi < Formula
    desc "Full stack for building hosting services"
    homepage "https://uwsgi-docs.readthedocs.io/en/latest/"
    url "https://files.pythonhosted.org/packages/6f/f0/d794e9c7359f488b158e88c9e718c5600efdb74a0daf77331e5ffb6c87c4/uwsgi-2.0.30.tar.gz"
    sha256 "c12aa652124f062ac216077da59f6d247bd7ef938234445881552e58afb1eb5f"
    license "GPL-2.0-or-later"
    head "https://github.com/unbit/uwsgi.git", branch: "master"
  
    depends_on "pkgconf" => :build
    depends_on "openssl@3"
    depends_on "pcre2"
    depends_on "python@3.10"
    depends_on "sqlite"
    depends_on "yajl"
    depends_on "python@2"
  
    uses_from_macos "curl"
    uses_from_macos "libxcrypt"
    uses_from_macos "libxml2"
    uses_from_macos "openldap"
    uses_from_macos "perl"
  
    on_linux do
      depends_on "linux-pam"
    end
  
    def python3
      "python3.10"
    end

    def python27
        Formula["python@2"].opt_bin/"python"
    end
  
    def install
      openssl = Formula["openssl@3"]
      ENV.prepend "CFLAGS", "-I#{openssl.opt_include}"
      ENV.prepend "LDFLAGS", "-L#{openssl.opt_lib}"
  
      (buildpath/"buildconf/brew.ini").write <<~INI
        [uwsgi]
        ssl = true
        json = yajl
        xml = libxml2
        yaml = embedded
        inherit = base
        plugin_dir = #{libexec}/uwsgi
        embedded_plugins = null
      INI
  
      system python3, "uwsgiconfig.py", "--verbose", "--build", "brew"
  
      plugins = %w[airbrake alarm_curl asyncio cache
                   carbon cgi cheaper_backlog2 cheaper_busyness
                   corerouter curl_cron dumbloop dummy
                   echo emperor_amqp fastrouter forkptyrouter gevent
                   http logcrypto logfile ldap logpipe logsocket
                   msgpack notfound pam ping psgi pty rawrouter
                   router_basicauth router_cache router_expires
                   router_hash router_http router_memcached
                   router_metrics router_radius router_redirect
                   router_redis router_rewrite router_static
                   router_uwsgi router_xmldir rpc signal spooler
                   sqlite3 sslrouter stats_pusher_file
                   stats_pusher_socket symcall syslog
                   transformation_chunked transformation_gzip
                   transformation_offload transformation_tofile
                   transformation_toupper ugreen webdav zergpool]
      plugins << "alarm_speech" if OS.mac?
      plugins << "cplusplus" if OS.linux?
  
      (libexec/"uwsgi").mkpath
      plugins.each do |plugin|
        system python3, "uwsgiconfig.py", "--verbose", "--plugin", "plugins/#{plugin}", "brew"
      end
  
      system python3, "uwsgiconfig.py", "--verbose", "--plugin", "plugins/python", "brew", "python3"
      system python27, "uwsgiconfig.py", "--verbose", "--plugin", "plugins/python", "brew", "python"
  
      bin.install "uwsgi"
    end

    def post_install
      (HOMEBREW_PREFIX/"etc/uwsgi/apps-enabled").mkpath
      (HOMEBREW_PREFIX/"var/run/uwsgi").mkpath
      (HOMEBREW_PREFIX/"var/log/uwsgi/app").mkpath
    end
  
    service do
      run [opt_bin/"uwsgi", "--uid", "_www", "--gid", "_www", "--master", "--die-on-term", "--autoload", "--logto",
           HOMEBREW_PREFIX/"var/log/uwsgi.log", "--emperor", HOMEBREW_PREFIX/"etc/uwsgi/apps-enabled"]
      keep_alive true
      working_dir HOMEBREW_PREFIX
    end
  
    test do
      (testpath/"helloworld.py").write <<~PYTHON
        def application(env, start_response):
          start_response('200 OK', [('Content-Type','text/html')])
          return [b"Hello World"]
      PYTHON
  
      port = free_port
      args = %W[
        --http-socket 127.0.0.1:#{port}
        --protocol=http
        --plugin python3
        -w helloworld
      ]
      pid = spawn("#{bin}/uwsgi", *args)
      sleep 4
      sleep 6 if Hardware::CPU.intel?
  
      begin
        assert_match "Hello World", shell_output("curl localhost:#{port}")
      ensure
        Process.kill("SIGINT", pid)
        Process.wait(pid)
      end
    end
  end  