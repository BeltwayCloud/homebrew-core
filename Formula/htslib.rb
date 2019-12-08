class Htslib < Formula
  desc "C library for high-throughput sequencing data formats"
  homepage "https://www.htslib.org/"
  url "https://github.com/samtools/htslib/releases/download/1.10/htslib-1.10.tar.bz2"
  sha256 "7ae44dd9faeb4c4293e9bb4815164ac28c6c6fae81fed4791df2fa878f57a972"

  bottle do
    cellar :any
    sha256 "b04f9a91003fadfe9515bfbaeb4debdb34bef51713a0145ce5b64d1c44c4e49c" => :catalina
    sha256 "708e1bf70be4d14c4cc937984cb56cc7f47048a266f62988e630fe874e4bc848" => :mojave
    sha256 "8200a468ef3bc3fd85523e80ed7d3c99b86ea8b120ea06acbfc8c8f36bd878e8" => :high_sierra
    sha256 "bdbd67c240d87c70d045067bd29de21eddaa73b13ec7e855776467df6167562b" => :sierra
    sha256 "fa53384739075cd0bc825a32dfd35b2dcdf363dbf2c6d081dfd515b5cbd5c722" => :el_capitan
  end

  depends_on "xz"

  uses_from_macos "bzip2"
  uses_from_macos "curl"
  uses_from_macos "zlib"

  def install
    system "./configure", "--prefix=#{prefix}", "--enable-libcurl"
    system "make", "install"
    pkgshare.install "test"
  end

  test do
    sam = pkgshare/"test/ce#1.sam"
    assert_match "SAM", shell_output("#{bin}/htsfile #{sam}")
    system "#{bin}/bgzip -c #{sam} > sam.gz"
    assert_predicate testpath/"sam.gz", :exist?
    system "#{bin}/tabix", "-p", "sam", "sam.gz"
    assert_predicate testpath/"sam.gz.tbi", :exist?
  end
end
