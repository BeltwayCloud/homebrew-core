class Libirecovery < Formula
  desc "Library and utility to talk to iBoot/iBSS via USB"
  homepage "https://www.libimobiledevice.org/"
  url "https://github.com/libimobiledevice/libirecovery/releases/download/1.1.0/libirecovery-1.1.0.tar.bz2"
  sha256 "ee3b1afbc0cab5309492cfcf3e132c6cc002617a57664ee0120ae918318e25f9"
  license "LGPL-2.1-only"
  head "https://github.com/libimobiledevice/libirecovery.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "f3ff5f59adbeb27276dd027588f872ee412ccbfe47fe288e552bd842caacc8ed"
    sha256 cellar: :any,                 arm64_ventura:  "4d21cd165479e408542f64d4b03e607650bed9eeaf8564ace51746310a443bea"
    sha256 cellar: :any,                 arm64_monterey: "f84e04eff5b2a9a9679179f427ff5eca930ea9210f86e58d905c23a4185229b2"
    sha256 cellar: :any,                 arm64_big_sur:  "934427f0de5e9990ca8569960ac0d6cd80f5739401e017b49bb4f79244c953ee"
    sha256 cellar: :any,                 sonoma:         "0f1d60730d00380399c88854a743341a082437f5ebd797642eb525ce85b5e6eb"
    sha256 cellar: :any,                 ventura:        "7be7894d857845b641bf1e0caad511eb5698d1f4f3b504db2e91bdf8c31289d4"
    sha256 cellar: :any,                 monterey:       "5bca397cb6420f3a30580995c2f452548f0e9947bf7bc511eb4f09f4510e5370"
    sha256 cellar: :any,                 big_sur:        "4237290aa629bfa59e546e4da6d76d190ca44df8a6205dccf8974541b0d3bc1e"
    sha256 cellar: :any,                 catalina:       "a2733550b10ce601236c7e88f8bf689371c42d83e11875459f57a2da8b5bd4e0"
    sha256 cellar: :any,                 mojave:         "09cc0a8c6798d5b9ce0bd08bebdec68ef774f5e3ab4e41837c342c07f888b7bb"
    sha256 cellar: :any,                 high_sierra:    "04679d947675817c497d74a4a36714ef89a865425c05bc2b936b9bbb9806fe18"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5a46932a6963064dee3ffdf461ef4e2d3e495b8f3d6f13a860794bc698624416"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "libimobiledevice-glue"

  on_linux do
    depends_on "libusb"
    depends_on "readline"
  end

  def install
    if build.head?
      system "./autogen.sh", *std_configure_args, "--disable-silent-rules"
    else
      system "./configure", *std_configure_args, "--disable-silent-rules"
    end
    system "make", "install"
  end

  test do
    assert_match "ERROR: Unable to connect to device", shell_output("#{bin}/irecovery -f nothing 2>&1", 255)
  end
end
