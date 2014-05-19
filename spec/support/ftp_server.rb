require "testftpd"

def set_up_server
  @server = TestFtpd::Server.new(port: ftp_port, root_dir: ftp_root)
  @server.start
end

def ftp_root
  Pathname.pwd.to_s
end

def address
  'localhost:' + ftp_port.to_s
end

def ftp_port
  21212
end

def tear_down_server
  @server.shutdown
end