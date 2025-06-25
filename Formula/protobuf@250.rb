class ProtobufAT250 < Formula
  homepage 'http://code.google.com/p/protobuf/'
  url 'https://github.com/protocolbuffers/protobuf/releases/download/v2.5.0/protobuf-2.5.0.tar.gz'
  sha256 'c55aa3dc538e6fd5eaf732f4eb6b98bdcb7cedb5b91d3b5bdcf29c98c293f58e'

  depends_on "python@2" => :optional

  def install
    # Don't build in debug mode. See:
    # https://github.com/Homebrew/homebrew/issues/9279
    # http://code.google.com/p/protobuf/source/browse/trunk/configure.ac#61
    ENV.prepend 'CXXFLAGS', '-DNDEBUG'

    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--with-zlib"
    system "make"
    system "make install"

    # Install editor support and examples
    doc.install %w( editors examples )

    if build.with? 'python'
      chdir 'python' do
        ENV['PROTOCOL_BUFFERS_PYTHON_IMPLEMENTATION'] = 'cpp'
        ENV.append_to_cflags "-I#{include}"
        ENV.append_to_cflags "-L#{lib}"
        system 'python', 'setup.py', 'build'
        system 'python', 'setup.py', 'install', "--prefix=#{prefix}",
               '--single-version-externally-managed', '--record=installed.txt'
      end
    end
  end

  def caveats; <<~EOS
    Editor support and examples have been installed to:
      #{doc}
    EOS
  end
end