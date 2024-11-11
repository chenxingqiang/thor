#!/usr/bin/env ruby

class Thor < Formula
  desc "Template Handler & Organizer - A powerful project scaffolding tool"
  homepage "https://github.com/chenxingqiang/thor"
  url "https://github.com/chenxingqiang/thor/archive/v0.1.0.tar.gz"
  sha256 "REPLACE_WITH_ACTUAL_SHA256" # 发布时替换
  license "MIT"
  head "https://github.com/chenxingqiang/thor.git", branch: "main"

  depends_on "bash"
  depends_on "jq"
  depends_on "git"
  depends_on "tree"

  def install
    system "./scripts/build.sh"

    # Install main program
    bin.install "bin/thor"
    bin.install Dir["bin/thor-*"]

    # Install library files
    libexec.install "lib"

    # Install completion files
    bash_completion.install "completions/thor.bash"
    zsh_completion.install "completions/thor.zsh"
    fish_completion.install "completions/thor.fish"

    # Install man page
    man1.install "share/man/man1/thor.1"

    # Create configuration directory
    (prefix/"etc/thor").install "config/thor.conf"
  end

  def post_install
    system "#{bin}/thor", "init", "--system"
  end

  test do
    system "#{bin}/thor", "--version"
    system "#{bin}/thor", "init", "test-project", "--template", "minimal"
    assert_predicate testpath/"test-project", :directory?
    assert_predicate testpath/"test-project/.gitignore", :exist?

    # Test git command
    system "#{bin}/thor", "git", "ignore", "node"
    assert_predicate testpath/".gitignore", :exist?

    # Test template functionality
    system "#{bin}/thor", "template", "list"
    assert_match "Available templates:", shell_output("#{bin}/thor template list")
  end

  def caveats
    <<~EOS
      To enable shell completion, add the following to your shell config:

      For bash:
        source #{opt_share}/bash-completion/completions/thor.bash

      For zsh:
        source #{opt_share}/zsh/site-functions/_thor

      For fish:
        source #{opt_share}/fish/vendor_completions.d/thor.fish

      Configuration file is located at:
        #{etc}/thor/thor.conf
    EOS
  end
end