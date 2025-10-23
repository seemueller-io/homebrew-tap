class MlxOmniServer < Formula
  include Language::Python::Virtualenv

  desc "OpenAI-compatible API server powered by Apple's MLX framework"
  homepage "https://github.com/madroidmaq/mlx-omni-server"
  url "https://github.com/madroidmaq/mlx-omni-server/archive/refs/tags/v0.5.1.tar.gz"
  # To get the actual SHA256 hash, download the package and run:
  # curl -L -o mlx-omni-server-0.5.1.tar.gz https://github.com/madroidmaq/mlx-omni-server/archive/refs/tags/v0.5.1.tar.gz
  # shasum -a 256 mlx-omni-server-0.5.1.tar.gz
  sha256 "a74f201457335613e47a5d50affee147f2393470dd377e0e5a53d1f4647ebe60"
  license "MIT"

  depends_on "python@3.11"
  # Build Pillow from source to avoid vendored .dylibs that fail relocation
  depends_on "jpeg-turbo"
  depends_on "libpng"
  depends_on "freetype"
  depends_on :macos

  # This formula installs the following key dependencies from PyPI:
  # - fastapi: Web framework for building APIs
  # - uvicorn: ASGI server
  # - pydantic: Data validation
  # - mlx-lm: Language model support using MLX
  # - mlx-whisper: Speech-to-text using MLX
  # - f5-tts-mlx: Text-to-speech using MLX
  # - mflux: Image generation using MLX
  # - mlx-embeddings: Text embeddings using MLX

  def install
    # Create an isolated virtualenv
    venv = virtualenv_create(libexec, "python3.11")

    # Force Pillow to build from source so it links against Homebrew libs
    # instead of bundling macOS .dylibs that Homebrew cannot relocate.
    venv.pip_install ["--no-binary", "Pillow", "Pillow"]

    # Install the package and its remaining dependencies into the venv
    venv.pip_install_and_link buildpath
  end

  # Only allow installation on Apple Silicon Macs
  pour_bottle? do
    reason "MLX Omni Server requires Apple Silicon (M-series) chips"
    satisfy { Hardware::CPU.arm? }
  end

  def caveats
    <<~EOS
      MLX Omni Server is designed specifically for Apple Silicon (M-series) chips.
      It will not work on Intel-based Macs.

      To start the server:
        mlx-omni-server

      The server will be available at:
        http://localhost:10240
    EOS
  end

  test do
    # Add a basic test to verify the installation
    assert_match "MLX Omni Server", shell_output("#{bin}/mlx-omni-server --help")
  end
end
