class Breezy < Formula
  include Language::Python::Virtualenv

  desc "Version control system implemented in Python with multi-format support"
  homepage "https://www.breezy-vcs.org/"
  url "https://files.pythonhosted.org/packages/94/15/6246755badf310cd8397cfc8b0e6cc454db6eec2a42d7a926ad2f72b4482/breezy-3.3.7.tar.gz"
  sha256 "e70e03277ffa97e1bc27a24b30539bd3132e6d0ad9512b91db6dd499c254980d"
  license "GPL-2.0-or-later"

  bottle do
    rebuild 2
    sha256 cellar: :any,                 arm64_sonoma:   "f15901e4c92437189ad9559aa819b08d59dc2091e4ad8af0925f93b39e533764"
    sha256 cellar: :any,                 arm64_ventura:  "9e5496b4f951036bfc021d5e2bb7b2b7792856f0c4a6fa45ebe03b0f4f17766f"
    sha256 cellar: :any,                 arm64_monterey: "3c1b8fefa81bc367ae31a09c2ba8e9bbb75ba0481ac46a60ff0e9052d1f9394a"
    sha256 cellar: :any,                 sonoma:         "aada017c0892e62473cfe05746fea02523c19a3ac14fe1b28545f7140063691e"
    sha256 cellar: :any,                 ventura:        "ad3a40974a921caa74117536189d77a8bd93109b9d7b3f69869705ce58127911"
    sha256 cellar: :any,                 monterey:       "217558ac5dd4ab8ce2024c31748976688363514aef789a004b97710188798d53"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ec5c5a4a8205d4ba57755d073f7b19f193b03255f53bf8183106f2c98aeee00f"
  end

  depends_on "gettext" => :build
  depends_on "rust" => :build
  depends_on "libyaml"
  depends_on "python@3.12"

  resource "configobj" do
    url "https://files.pythonhosted.org/packages/cb/87/17d4c6d634c044ab08b11c0cd2a8a136d103713d438f8792d7be2c5148fb/configobj-5.0.8.tar.gz"
    sha256 "6f704434a07dc4f4dc7c9a745172c1cad449feb548febd9f7fe362629c627a97"
  end

  resource "dulwich" do
    url "https://files.pythonhosted.org/packages/2b/e2/788910715b4910d08725d480278f625e315c3c011eb74b093213363042e0/dulwich-0.21.7.tar.gz"
    sha256 "a9e9c66833cea580c3ac12927e4b9711985d76afca98da971405d414de60e968"
  end

  resource "fastbencode" do
    url "https://files.pythonhosted.org/packages/20/ab/33ca3005953d689f1be9c1e0662f5359b7365479f7a8fbd66cb05e9a840d/fastbencode-0.2.tar.gz"
    sha256 "578eb9c4700d6705d71fbc8d7d57bca2cd987eca2cec1d9e77b9e0702db1e56f"
  end

  resource "merge3" do
    url "https://files.pythonhosted.org/packages/af/40/98be4a5641b0244be5881ff5e00057f8227ff183d8675a697bdfeae43b1a/merge3-0.0.14.tar.gz"
    sha256 "30406e99386f4a65280fb9c43e681890fa2a1d839cac2759d156c7cc16030159"
  end

  resource "patiencediff" do
    url "https://files.pythonhosted.org/packages/57/9f/0973293d232696ae191cef7c4e8eb1ebbdb7728c48662ebf04c26fd576e4/patiencediff-0.2.14.tar.gz"
    sha256 "a604d5727f996f0fd9de4534b143d3e803ec4f1b18e40cd78e91ab48a289a95f"
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/cd/e5/af35f7ea75cf72f2cd079c95ee16797de7cd71f29ea7c68ae5ce7be1eda0/PyYAML-6.0.1.tar.gz"
    sha256 "bfdf460b1736c775f2ba9f6a92bca30bc2095067b8a9d77876d1fad6cc3b4a43"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/71/39/171f1c67cd00715f190ba0b100d606d440a28c93c7714febeca8b79af85e/six-1.16.0.tar.gz"
    sha256 "1e61c37477a1626458e36f7b1d82aa5c9b094fa4802892072e49de9c60c4c926"
  end

  resource "tzlocal" do
    url "https://files.pythonhosted.org/packages/04/d3/c19d65ae67636fe63953b20c2e4a8ced4497ea232c43ff8d01db16de8dc0/tzlocal-5.2.tar.gz"
    sha256 "8d399205578f1a9342816409cc1e46a93ebd5755e39ea2d85334bea911bf0e6e"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/7a/50/7fd50a27caa0652cd4caf224aa87741ea41d3265ad13f010886167cfcc79/urllib3-2.2.1.tar.gz"
    sha256 "d0570876c61ab9e520d776c38acbbb5b05a776d3f9ff98a5c8fd5162a444cf19"
  end

  def install
    virtualenv_install_with_resources
    bin.each_child do |f|
      f.unlink
      f.write_env_script libexec/"bin"/f.basename, PATH: "#{libexec}/bin:$PATH"
    end
    man1.install_symlink Dir[libexec/"man/man1/*.1"]

    # Replace bazaar with breezy
    bin.install_symlink "brz" => "bzr"
  end

  test do
    brz = "#{bin}/brz"
    whoami = "Homebrew <homebrew@example.com>"
    system brz, "whoami", whoami
    assert_match whoami, shell_output("#{bin}/brz whoami")

    # Test bazaar compatibility
    system brz, "init-repo", "sample"
    system brz, "init", "sample/trunk"
    touch testpath/"sample/trunk/test.txt"
    cd "sample/trunk" do
      system brz, "add", "test.txt"
      system brz, "commit", "-m", "test"
    end

    # Test git compatibility
    system brz, "init", "--git", "sample2"
    touch testpath/"sample2/test.txt"
    cd "sample2" do
      system brz, "add", "test.txt"
      system brz, "commit", "-m", "test"
    end
  end
end
