class Cerebro < Formula
  desc "cerebro is an open source(MIT License) elasticsearch web admin tool built using Scala, Play Framework, AngularJS and Bootstrap."
  homepage "https://github.com/lmenezes/cerebro"
  url "https://github.com/lmenezes/cerebro/releases/download/v0.9.2/cerebro-0.9.2.tgz"
  sha256 "aa7663813a72be40a5b285fea6c9aa4df0a09b663eb1133506fccb67fb832c66"

  depends_on "openjdk@8"

  def install
    # Remove Windows files
    rm_f Dir["bin/*.bat"]

    # Install everything else into package directory
    libexec.install "bin", "conf", "lib"

    # Move config files into etc
    (etc/"cerebro").install Dir[libexec/"conf/*"]
    (libexec/"conf").rmtree

    bin.install libexec/"bin/cerebro"
    bin.env_script_all_files(libexec/"bin", Language::Java.java_home_env("1.8"))
  end

  def post_install
    ln_s etc/"cerebro", libexec/"conf" unless (libexec/"conf").exist?
  end

  def caveats
    <<~EOS
      Config: #{etc}/cerebro/application.conf
    EOS
  end

  plist_options :manual => "cerebro"

  def plist
    <<~EOS
      <?xml version="1.0" encoding="UTF-8"?>
      <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
      <plist version="1.0">
        <dict>
          <key>KeepAlive</key>
          <true/>
          <key>Label</key>
          <string>#{plist_name}</string>
          <key>ProgramArguments</key>
          <array>
            <string>#{opt_bin}/cerebro</string>
          </array>
          <key>RunAtLoad</key>
          <true/>
          <key>WorkingDirectory</key>
          <string>#{var}</string>
          <key>StandardErrorPath</key>
          <string>#{var}/log/cerebro.log</string>
          <key>StandardOutPath</key>
          <string>#{var}/log/cerebro.log</string>
        </dict>
      </plist>
    EOS
  end

  test do
    # `test do` will create, run in and delete a temporary directory.
    #
    # This test will fail and we won't accept that! For Homebrew/homebrew-core
    # this will need to be a test that verifies the functionality of the
    # software. Run the test with `brew test cerebro`. Options passed
    # to `brew install` such as `--HEAD` also need to be provided to `brew test`.
    #
    # The installed folder is not in the path, so use the entire path to any
    # executables being tested: `system "#{bin}/program", "do", "something"`.
    system "false"
  end
end
